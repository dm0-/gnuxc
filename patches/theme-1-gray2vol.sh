#!/bin/bash -e
# Generate the image with: convert -colorspace Gray -depth 8 [...] image.gray

# Verify we were given a non-empty readable file.
image=${1?Usage: $0 /path/to/image.gray}
test -f "$image" -a -r "$image" -a -s "$image" || exit 1

# Check if it's a "2x" image and double the rows.
test "${image/2x/}" = "$image" && c=0c || c=18

# Verify the image has (could have?) 12/24 rows.
declare -i size=$(stat -c '%s' "$image")
! (( size % 0x$c )) || exit 2

# Verify the number of columns can fit in two bytes.
declare -i w=$(( size / 0x$c ))
(( w <= 0xFFFF )) || exit 3

# Write the image header.
echo -en '\x01\x'$(printf '%02x\\x%02x' $(( w >> 8 )) $(( w % 256 )))'\x00\x'$c

# Map the 8-bit depth grayscale pixels to the Mac palette.
declare -ar gray=( d6 ff fe ab fd fc 80 fb fa 55 f9 f8 2a f7 f6 00 )
while IFS= read -rsN1 pixel
do
        echo -en '\x'${gray[$(( $(LANG=C printf '%u' "'$pixel") >> 4 ))]}
done < <(tr $'\xff' $'\xfe' < "$image") # (read can't handle 0xFF)
