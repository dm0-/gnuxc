# Copyright (C) 2013 David Michael <fedora.dm0@gmail.com>
#
# This file is part of gnuxc.
#
# gnuxc is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# gnuxc is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# gnuxc.  If not, see <http://www.gnu.org/licenses/>.

# Locate build system components.
makefile := $(lastword $(MAKEFILE_LIST))
patchdir := $(dir $(makefile))patches
pkgdir   := $(dir $(makefile))make.pkg.d
timedir  := $(CURDIR)/timestamps

# Determine the cross-compilation system types.
arch  := i686
host  := $(arch)-pc-gnu
build := $(shell rpm -E %_build)
ifneq ($(host),$(build))
sysroot = /usr/$(host)/sys-root
export .LIBPATTERNS = $(sysroot)/usr/lib/lib%.so $(sysroot)/usr/lib/lib%.a
endif

# Customize these settings on the command-line, if desired.
export DESTDIR := $(CURDIR)/gnu-root
export CFLAGS   = -O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 \
	-fexceptions -fstack-protector --param=ssp-buffer-size=4 \
	-grecord-gcc-switches
export CXXFLAGS = $(CFLAGS)
export LDFLAGS  = -Wl,-z,relro

# Configure external commands and their default behavior.
AUTOGEN  := autoreconf --force --install
CONVERT  := convert
COPY     := cp --force
CVS      := cvs
DOWNLOAD := wget --output-document=- # curl --location
ECHO     := echo
EDIT     := sed --in-place
GIT      := git
INSTALL  := install
LINK     := ln --force
MKDIR    := mkdir --parents
MOVE     := mv --force
PATCH    := patch --force --strip=0
SYMLINK  := ln --force --no-dereference --symbolic
RM       := rm --force
RMDIR    := rmdir
TAR      := tar --no-same-owner --numeric-owner --overwrite --owner=0 --group=0
TOUCH    := touch

# Define the template for configuring packages.
configure = configure \
	--build=$(build) --host=$(host) --target=$(host) \
	--program-prefix= \
	--prefix=/usr \
	--exec-prefix='$${prefix}' \
	--bindir='$${exec_prefix}/bin' \
	--datadir='$${datarootdir}' \
	--datarootdir='$${prefix}/share' \
	--docdir='$${datarootdir}/doc/$${PACKAGE_TARNAME}' \
	--includedir='$${prefix}/include' \
	--infodir='$${datarootdir}/info' \
	--libdir='$${exec_prefix}/lib' \
	--libexecdir='$${exec_prefix}/libexec' \
	--localedir='$${datarootdir}/locale' \
	--localstatedir=/var \
	--mandir='$${datarootdir}/man' \
	--oldincludedir='$${includedir}' \
	--sbindir='$${exec_prefix}/sbin' \
	--sharedstatedir='$${localstatedir}/lib' \
	--sysconfdir=/etc
ifneq ($(host),$(build))
configure += \
	ac_cv_func_{c,m,re}alloc_0_nonnull=yes \
	ac_cv_func_memcmp_working=yes \
	ac_cv_func_posix_get{grg,pwu}id_r=yes \
	gl_cv_func_chown_{ctime,slash}_works=yes \
	gl_cv_func_fnmatch_{gnu,posix}=yes \
	gl_cv_func_getcwd_null=yes \
	gl_cv_func_getopt_gnu=yes \
	gl_cv_func_{gettimeofday,tzset}_clobber=no \
	gl_cv_func_lstat_dereferences_slashed_symlink=yes \
	gl_cv_func_mkdir_trailing_{dot,slash}_works=yes \
	gl_cv_func_mkfifo_works=yes \
	gl_cv_func_printf_directive_{a,f,ls}=yes \
	gl_cv_func_printf_{enomem,infinite,long_double}=yes \
	gl_cv_func_printf_flag_{grouping,leftadjust,zero}=yes \
	gl_cv_func_printf_{positions,precision,sizes_c99}=yes \
	gl_cv_func_readlink_works=yes \
	gl_cv_func_realpath_works=yes \
	gl_cv_func_rename_{dest,link}_works=yes \
	gl_cv_func_rmdir_works=yes \
	gl_cv_func_stat_{dir,file}_slash=yes \
	gl_cv_func_symlink_works=yes \
	gl_cv_func_working_acl_get_file=yes \
	gl_cv_func_working_mktime=yes \
	gl_cv_struct_dirent_d_ino=yes \
	glib_cv_stack_grows=yes \
	glib_cv_uscore=no
endif

# Manually decompress source archives on the fly to save disk space.
targ_bz2  := --bzip2
targ_gz   := --gzip
targ_lz   := --lzip
targ_lzma := --lzma
targ_tgz  := $(targ_gz)
targ_xz   := --xz

# Declare generic targets for the user interface.
packages := $(patsubst $(pkgdir)/%.mk,%,$(wildcard $(pkgdir)/*.mk))

.PHONY:   all $(packages) \
  prepare-all $(packages:%=prepare-%)   prepare \
configure-all $(packages:%=configure-%) configure \
    build-all $(packages:%=build-%)     build \
  install-all $(packages:%=install-%)   install \
     dist-all $(packages:%=dist-%)      dist \
    clean-all $(packages:%=clean-%)     clean

all: $(packages)
prepare-all prepare: $(packages:%=prepare-%)
configure-all configure: $(packages:%=configure-%)
build-all build: $(packages:%=build-%)
install-all install: $(packages:%=install-%)
dist-all dist: $(packages:%=dist-%)
clean-all clean: $(packages:%=clean-%)
	test '!' -d $(timedir) || $(RMDIR) $(timedir)

# Log when each step successfully completes, so it isn't needlessly repeated.
vpath %-rule $(timedir)
$(timedir):
	$(MKDIR) $@
$(timedir)/%-stamp: %-rule | $(timedir)
	$(TOUCH) $(@D)/$(<F) && $(LINK) $(@D)/$(<F) $@
prepared   = $(1:%=$(timedir)/prepare-%-stamp)
configured = $(1:%=$(timedir)/configure-%-stamp)
built      = $(1:%=$(timedir)/build-%-stamp)
installed  = $(1:%=$(timedir)/install-%-stamp)

# Define the skeleton targets for each package's build phases.
define init-package-rules =
$$($(1)):
ifeq ($$(firstword $$(subst ://, ,$$($(1)_url))),git)
	$$(GIT) clone $$($(1)_branch:%=-b %) -n $$($(1)_url) $$@
	$$(GIT) --git-dir=$$@/.git --work-tree=$$@ reset --hard $$($(1)_snap)
else ifeq ($$(firstword $$(subst ://, ,$$($(1)_url))),cvs)
	$$(CVS) -d:pserver:$$($(1)_url:cvs://%=%) export \
		-D$$($(1)_snap) -d$$@ -kv $$(firstword $$($(1)_branch) $(1))
else ifneq ($$($(1)_url),)
	$$(DOWNLOAD) $$($(1)_url) | \
	$$(TAR) $$($(1)_branch:%=--transform='s,^/*%/*,$$@/,') \
		$$(targ_$$(lastword $$(subst ., ,$$($(1)_url)))) -x
else
	$$(MKDIR) $$@
endif
$$($(1))/configure: $$(timedir)/prepare-$(1)-stamp
	test -x $$@ || \
	( test -f $$@.ac -o -f $$@.in && $$(AUTOGEN) $$(@D) ) ; \
	$$(TOUCH) $$@
$$($(1)).tar.xz: $$($(1))/configure
	$$(TAR) --exclude=autom4te.cache --exclude-vcs --xz -cf $$@ $$($(1))

prepare-$(1)-rule: | $$($(1))
configure-$(1)-rule: $$($(1))/configure
build-$(1)-rule: $$(timedir)/configure-$(1)-stamp
install-$(1)-rule: $$(timedir)/build-$(1)-stamp

prepare-$(1): $$(timedir)/prepare-$(1)-stamp
configure-$(1): $$(timedir)/configure-$(1)-stamp
build-$(1) $(1): $$(timedir)/build-$(1)-stamp
install-$(1): $$(timedir)/install-$(1)-stamp

dist-$(1): $$($(1)).tar.xz
clean-$(1):
	$$(RM) $$(timedir)/{prepare,configure,build,install}-$(1)-{rule,stamp}
	$$(RM) --recursive $$($(1))
endef

# Declare the package rules.
include $(pkgdir)/*.mk
$(foreach package,$(packages),$(eval $(call init-package-rules,$(package))))
