#!/usr/bin/make -f
# Copyright (C) 2013,2014 David Michael <fedora.dm0@gmail.com>
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
build := $(MAKE_HOST)
host  := $(arch)-pc-gnu
ifneq ($(host),$(build))
sysroot = /usr/$(host)/sys-root
export CONFIG_SITE = $(sysroot)/usr/share/config.site
export .LIBPATTERNS = $(sysroot)/usr/lib/lib%.so $(sysroot)/usr/lib/lib%.a
endif

# Customize these settings on the command-line, if desired.
export DESTDIR := $(CURDIR)/gnu-root
export CFLAGS   = -O2 -g -pipe -Wall -Werror=format-security \
	-Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector-strong \
	--param=ssp-buffer-size=4 -grecord-gcc-switches
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
GIT      := git -c user.name='GNU Hacker' -c user.email='root@localhost'
INSTALL  := install
LINK     := ln --force
MKDIR    := mkdir --parents
MOVE     := mv --force
PATCH    := patch --force --fuzz=0 --strip=0
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

# Manually decompress source archives on the fly to save disk space.
targ_bz2  := --bzip2
targ_gz   := --gzip
targ_lz   := --lzip
targ_lzma := --lzma
targ_tgz  := $(targ_gz)
targ_xz   := --xz

# Declare generic targets for the user interface.
packages := $(patsubst $(pkgdir)/%.mk,%,$(wildcard $(pkgdir)/*.mk))
packages-requested := $(filter-out $(subst *,%,$(exclude)),$(packages))

.PHONY:   all $(packages) \
  prepare-all $(packages:%=prepare-%)   prepare \
configure-all $(packages:%=configure-%) configure \
    build-all $(packages:%=build-%)     build \
  install-all $(packages:%=install-%)   install \
     dist-all $(packages:%=dist-%)      dist \
    clean-all $(packages:%=clean-%)     clean

all: $(packages-requested)
prepare-all prepare: $(packages-requested:%=prepare-%)
configure-all configure: $(packages-requested:%=configure-%)
build-all build: $(packages-requested:%=build-%)
install-all install: $(packages-requested:%=install-%)
dist-all dist: $(packages-requested:%=dist-%)
clean-all clean: $(packages-requested:%=clean-%)
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
	$$(GIT) clone $$($(1)_branch:%=-b %) -n '$$($(1)_url)' $$@
	$$(GIT) -C $$@ reset --hard $$($(1)_snap)
else ifeq ($$(firstword $$(subst ://, ,$$($(1)_url))),cvs)
	$$(CVS) -d'$$($(1)_url:cvs://%=:pserver:%)' export \
		-D$$($(1)_snap) -d$$@ -kv $$(firstword $$($(1)_branch) $(1))
else ifneq ($$(filter tar tgz,$$(subst ., ,$$($(1)_url))),)
	$$(DOWNLOAD) '$$($(1)_url)' | \
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
