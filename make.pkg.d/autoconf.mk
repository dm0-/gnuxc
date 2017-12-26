autoconf                := autoconf-2.69
autoconf_key            := 71C2CC22B1C4602927D2F3AAA7A16B4A2527436A
autoconf_url            := http://ftpmirror.gnu.org/autoconf/$(autoconf).tar.xz

$(eval $(call verify-download,fix-texinfo.patch,http://git.savannah.gnu.org/cgit/autoconf.git/patch?id=a357718b081f1678748ead5d7cb67c766c930441,4aea9a8c22f27026c26e9196808447e8362fca0d))

$(prepare-rule):
# Fix errors in the documentation that break the build.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-texinfo.patch)

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,m4 perl)
	$(MAKE) -C $(builddir) install
