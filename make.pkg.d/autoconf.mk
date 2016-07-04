autoconf                := autoconf-2.69
autoconf_sha1           := e891c3193029775e83e0534ac0ee0c4c711f6d23
autoconf_url            := http://ftpmirror.gnu.org/autoconf/$(autoconf).tar.xz

$(eval $(call verify-download,http://git.savannah.gnu.org/cgit/autoconf.git/patch?id=a357718b081f1678748ead5d7cb67c766c930441,0091d209848613cf2825207f6600dd496935b09e,fix-texinfo.patch))

$(prepare-rule):
# Fix errors in the documentation that break the build.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-texinfo.patch)

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,m4 perl)
	$(MAKE) -C $(builddir) install
