xorg-macros             := xorg-macros-1.19.1
xorg-macros_branch      := $(xorg-macros:xorg-%=util-%)
xorg-macros_sha1        := 386e993ba339e561aa6d93073a4dcbab24e30bad
xorg-macros_url         := http://xorg.freedesktop.org/releases/individual/util/$(xorg-macros_branch).tar.bz2

$(prepare-rule):
# Don't install the generic INSTALL file.
	$(EDIT) '/^dist_pkgdata_DATA *=/s/ INSTALL//' $(builddir)/Makefile.am
	$(RM) $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
