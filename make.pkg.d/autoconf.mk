autoconf                := autoconf-2.69
autoconf_url            := http://ftpmirror.gnu.org/autoconf/$(autoconf).tar.xz

prepare-autoconf-rule:
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/autoconf.git/patch?id=a357718b081f1678748ead5d7cb67c766c930441' | $(PATCH) -d $(autoconf) -p1

configure-autoconf-rule:
	cd $(autoconf) && ./$(configure)

build-autoconf-rule:
	$(MAKE) -C $(autoconf) all

install-autoconf-rule: $(call installed,m4 perl)
	$(MAKE) -C $(autoconf) install
