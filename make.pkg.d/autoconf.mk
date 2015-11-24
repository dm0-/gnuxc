autoconf                := autoconf-2.69
autoconf_url            := http://ftpmirror.gnu.org/autoconf/$(autoconf).tar.xz

$(prepare-rule):
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/autoconf.git/patch?id='a357718b081f1678748ead5d7cb67c766c930441 | $(PATCH) -d $(builddir) -p1

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,m4 perl)
	$(MAKE) -C $(builddir) install
