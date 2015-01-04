/* Expose SMBIOS data to the console and configuration files */
/*
 *  GRUB  --  GRand Unified Bootloader
 *  Copyright (C) 2013,2014  Free Software Foundation, Inc.
 *
 *  GRUB is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  GRUB is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with GRUB.  If not, see <http://www.gnu.org/licenses/>.
 */

#include <grub/dl.h>
#include <grub/extcmd.h>
#include <grub/i18n.h>
#include <grub/misc.h>
#include <grub/mm.h>

#ifdef GRUB_MACHINE_EFI
#include <grub/efi/efi.h>
#else
#include <grub/acpi.h>
#endif

GRUB_MOD_LICENSE ("GPLv3+");


/* Reference: DMTF Standard DSP0134 2.7.1 Table 1 */

struct __attribute__ ((packed)) grub_smbios_ieps
  {
    grub_uint8_t  anchor[5]; /* "_DMI_" */
    grub_uint8_t  checksum;
    grub_uint16_t table_length;
    grub_uint32_t table_address;
    grub_uint16_t structures;
    grub_uint8_t  revision;
  };

struct __attribute__ ((packed)) grub_smbios_eps
  {
    grub_uint8_t  anchor[4]; /* "_SM_" */
    grub_uint8_t  checksum;
    grub_uint8_t  length;
    grub_uint8_t  version_major;
    grub_uint8_t  version_minor;
    grub_uint16_t maximum_structure_size;
    grub_uint8_t  revision;
    grub_uint8_t  formatted[5];
    struct grub_smbios_ieps intermediate;
  };

static struct grub_smbios_eps *eps = NULL;


/* Reference: DMTF Standard DSP0134 2.7.1 Section 5.2.1 */

/*
 * In order for any of this module to function, it needs to find an entry point
 * structure.  This returns a pointer to a struct that identifies the fields of
 * the EPS, or NULL if it cannot be located.
 */
static const struct grub_smbios_eps *
grub_smbios_locate_eps (void)
{
#ifdef GRUB_MACHINE_EFI
  static const grub_efi_guid_t smbios_guid = GRUB_EFI_SMBIOS_TABLE_GUID;
  const grub_efi_system_table_t *st = grub_efi_system_table;
  grub_efi_configuration_table_t *t = st->configuration_table;
  unsigned int i;

  for (i = 0; i < st->num_table_entries; i++)
    if (grub_memcmp (&smbios_guid, &t->vendor_guid, sizeof (smbios_guid)) == 0)
      {
        grub_dprintf ("smbios", "Found entry point structure at %p\n",
                      t->vendor_table);
        return t->vendor_table;
      }
    else
      t++;
#else
  grub_uint8_t *ptr;

  for (ptr = 0x000F0000; ptr < 0x00100000; ptr += 16)
    if (grub_memcmp (ptr, "_SM_", 4) == 0
        && grub_byte_checksum (ptr, ptr[5]) == 0)
      {
        grub_dprintf ("smbios", "Found entry point structure at %p\n", ptr);
        return ptr;
      }
#endif

  grub_dprintf ("smbios", "Failed to locate entry point structure\n");
  return NULL;
}


/* Reference: DMTF Standard DSP0134 2.7.1 Sections 6.1.2-6.1.3 */

/*
 * Given a pointer to the first bytes of an entry, print its contents in a
 * semi-human-readable format.  Return the size of the entry printed.
 */
static grub_uint16_t
grub_smbios_dump_entry (const grub_uint8_t *entry)
{
  grub_uint8_t *ptr = entry;
  grub_uint8_t newstr = 1;
  grub_uint8_t length;

  /* Write the entry's mandatory four header bytes. */
  length = ptr[1];
  grub_printf ("Entry: Type=0x%02x Length=0x%02x Handle=0x%04x\n",
               ptr[0], length, *(1 + (grub_uint16_t *)ptr));

  /* Dump of the formatted area (including the header) in hex. */
  grub_printf (" Hex Dump: ");
  while (length-- > 0)
    grub_printf ("%02x", *ptr++);
  grub_printf ("\n");

  /* Print each string found in the appended string list. */
  while (ptr[0] != 0 || ptr[1] != 0)
    {
      if (newstr)
        grub_printf (" String: %s\n", ptr);
      newstr = *ptr++ == 0;
    }
  ptr += 2;

  /* Return the total number of bytes covered. */
  return ptr - entry;
}


/* Reference: DMTF Standard DSP0134 2.7.1 Sections 6.1.2-6.1.3 */

/*
 * Return or print a matched table entry.  Multiple entries can be matched if
 * they are being printed.
 *
 * This method can handle up to three criteria for selecting an entry:
 *   - The entry's "type" field             (use outside [0,0xFF] to ignore)
 *   - The entry's "handle" field           (use outside [0,0xFFFF] to ignore)
 *   - The entry to return if several match (use 0 to print all matches)
 *
 * The parameter "print" was added for verbose debugging.  When non-zero, the
 * matched entries are printed to the console instead of returned.
 */
static const grub_uint8_t *
grub_smbios_match_entry (const struct grub_smbios_eps *eps,
                         const grub_int16_t type,
                         const grub_int32_t handle,
                         const grub_uint16_t match,
                         const grub_uint8_t print)
{
  grub_uint8_t *table_address = eps->intermediate.table_address;
  grub_uint16_t table_length = eps->intermediate.table_length;
  grub_uint16_t structures = eps->intermediate.structures;
  grub_uint8_t *ptr = table_address;
  grub_uint16_t structure = 0;
  grub_uint16_t matches = 0;

  while (ptr - table_address < table_length && structure++ < structures)

    /* Test if the current entry matches the given parameters. */
    if ((handle < 0 || 65535 < handle || handle == *(1 + (grub_uint16_t *)ptr))
        && (type < 0 || 255 < type || type == ptr[0])
        && (match == 0 || match == ++matches))
      {
        if (print)
          {
            ptr += grub_smbios_dump_entry (ptr);
            if (match > 0)
              break;
          }
        else
          return ptr;
      }

    /* If the entry didn't match, skip it (formatted area and string list). */
    else
      {
        ptr += ptr[1];
        while (*ptr++ != 0 || *ptr++ != 0);
      }

  return NULL;
}


/* Reference: DMTF Standard DSP0134 2.7.1 Section 6.1.3 */

/*
 * Given a pointer to a string list and a number, iterate over each of the
 * strings until the desired item is reached.  (The value of 1 indicates the
 * first string, etc.)
 */
static const char *
grub_smbios_get_string (const grub_uint8_t *strings, const grub_uint8_t number)
{
  grub_uint8_t *ptr = strings;
  grub_uint8_t newstr = 1;
  grub_uint8_t index = 1;

  /* A string referenced with zero is interpreted as unset. */
  if (number == 0)
    return NULL;

  /* Search the string table, incrementing the counter as each null passes. */
  while (ptr[0] != 0 || ptr[1] != 0)
    {
      if (newstr && number == index++)
        return ptr;
      newstr = *ptr++ == 0;
    }

  /* The requested string index is greater than the number of table entries. */
  return NULL;
}


static grub_err_t
grub_cmd_smbios (grub_extcmd_context_t ctxt,
                 int argc __attribute__ ((unused)),
                 char **argv __attribute__ ((unused)))
{
  struct grub_arg_list *state = ctxt->state;

  grub_int16_t type = -1;
  grub_int32_t handle = -1;
  grub_uint16_t match = 0;
  grub_uint8_t offset;

  grub_uint8_t *entry;
  grub_uint8_t accessors;
  grub_uint8_t i;
  char buffer[24]; /* 64-bit number -> maximum 20 decimal digits */
  char *value = buffer;

  if (eps == NULL)
    return grub_error (GRUB_ERR_FILE_NOT_FOUND, N_("missing entry point"));

  /* Only one value can be returned at a time; reject multiple selections. */
  accessors = !!state[3].set + !!state[4].set + !!state[5].set
            + !!state[6].set + !!state[7].set;
  if (accessors > 1)
    return grub_error (GRUB_ERR_BAD_ARGUMENT, N_("too many -b|-w|-d|-q|-s"));

  /* Reject the environment variable if no value was selected. */
  if (accessors == 0 && state[8].set)
    return grub_error (GRUB_ERR_BAD_ARGUMENT, N_("-v without -b|-w|-d|-q|-s"));

  /* Read the given matching parameters. */
  if (state[0].set)
    type = grub_strtol (state[0].arg, NULL, 0);
  if (state[1].set)
    handle = grub_strtol (state[1].arg, NULL, 0);
  if (state[2].set)
    match = grub_strtoul (state[2].arg, NULL, 0);

  /* When not selecting a value, print all matching entries and quit. */
  if (accessors == 0)
    {
      grub_smbios_match_entry (eps, type, handle, match, 1);
      return GRUB_ERR_NONE;
    }

  /* Select a single entry from the matching parameters. */
  entry = grub_smbios_match_entry (eps, type, handle, match, 0);
  if (entry == NULL)
    return grub_error (GRUB_ERR_FILE_NOT_FOUND, N_("no such entry"));

  /* Ensure the specified offset+length is within the matched entry. */
  for (i = 3; i <= 7; i++)
    if (state[i].set)
      {
        offset = grub_strtoul (state[i].arg, NULL, 0);
        if (offset + (1 << (i == 7 ? 0 : i - 3)) > entry[1])
          return grub_error (GRUB_ERR_OUT_OF_RANGE, N_("value outside entry"));
        break;
      }

  /* If a string was requested, try to find its pointer. */
  if (state[7].set)
    {
      value = grub_smbios_get_string (entry + entry[1], entry[offset]);
      if (value == NULL)
        return grub_error (GRUB_ERR_OUT_OF_RANGE, N_("string not defined"));
    }

  /* Create a string from a numeric value suitable for printing. */
  else if (state[3].set)
    grub_snprintf (buffer, sizeof (buffer), "%u", entry[offset]);
  else if (state[4].set)
    grub_snprintf (buffer, sizeof (buffer), "%u",
                   *(grub_uint16_t *)(entry + offset));
  else if (state[5].set)
    grub_snprintf (buffer, sizeof (buffer), "%" PRIuGRUB_UINT32_T,
                   *(grub_uint32_t *)(entry + offset));
  else if (state[6].set)
    grub_snprintf (buffer, sizeof (buffer), "%" PRIuGRUB_UINT64_T,
                   *(grub_uint64_t *)(entry + offset));

  /* Store or print the requested value. */
  if (state[8].set)
    {
      grub_env_set (state[8].arg, value);
      grub_env_export (state[8].arg);
    }
  else
    grub_printf ("%s\n", value);

  return GRUB_ERR_NONE;
}


static grub_extcmd_t cmd;

static const struct grub_arg_option options[] =
  {
    {"type",   't', 0, N_("Match entries with the given type\n\t\t\t"
                          "\"byte\" is an integer in the range 0-255\n\t\t\t"
                          "[default: -1 (ignore types while matching)]"),
                       N_("byte"), ARG_TYPE_INT},
    {"handle", 'h', 0, N_("Match entries with the given handle\n\t\t\t"
                          "\"word\" is an integer in the range 0-65535\n\t\t\t"
                          "[default: -1 (ignore handles while matching)]"),
                       N_("word"), ARG_TYPE_INT},
    {"match",  'm', 0, N_("Select the entry to use when several match\n\t\t\t"
                          "\"number\" is a positive integer\n\t\t\t"
                          "[default: 0 (all matches) for entry dumps\n\t\t\t"
                          "          1 (first match) for value retrieval]"),
                       N_("number"), ARG_TYPE_INT},
    {"get-byte",   'b', 0, N_("Get the byte's value at the given offset"),
                           N_("offset"), ARG_TYPE_INT},
    {"get-word",   'w', 0, N_("Get two bytes' value at the given offset"),
                           N_("offset"), ARG_TYPE_INT},
    {"get-dword",  'd', 0, N_("Get four bytes' value at the given offset"),
                           N_("offset"), ARG_TYPE_INT},
    {"get-qword",  'q', 0, N_("Get eight bytes' value at the given offset"),
                           N_("offset"), ARG_TYPE_INT},
    {"get-string", 's', 0, N_("Get the string referenced at the given offset"),
                           N_("offset"), ARG_TYPE_INT},
    {"variable", 'v', 0, N_("Store the value in the given variable name"),
                         N_("name"), ARG_TYPE_STRING},
    {0, 0, 0, 0, 0, 0}
  };

GRUB_MOD_INIT(smbios)
{
  /* SMBIOS data is supposed to be static, so find it only once during init. */
  eps = grub_smbios_locate_eps ();

  cmd = grub_register_extcmd ("smbios", grub_cmd_smbios, 0,
                              N_("[-t byte] [-h word] [-m number] "
                                 "[{-b|-w|-d|-q|-s} offset [-v name]]"),
                              N_("Expose SMBIOS data.\n\n"
"The options -t, -h, -m are used to match specific entries.  Their defaults "
"match all entries.  Without any additional options, matched entries are "
"printed to the console.\n\n"
"Only one of -b, -w, -d, -q, -s can be given to return a specific value from "
"a single matched entry.  The value is read at a byte offset, and the option "
"determines the data type.  (See the SMBIOS reference specification for "
"standard values, or review you your OEM's documentation for others.)  The "
"selected value is printed to the console, or if -v is given, the value is "
"stored in the named environment variable.\n\n"
"Example to save the name of the manufacturer of the system's second CPU:"
"\n\tsmbios -t 4 -m 2 -s 7 -v cpu2manu\n\techo $cpu2manu\n"
"It says to match type 4 entries (Processor Information) and use the second "
"match, then find the string referenced by its seventh byte."), options);
}

GRUB_MOD_FINI(smbios)
{
  grub_unregister_extcmd (cmd);
}
