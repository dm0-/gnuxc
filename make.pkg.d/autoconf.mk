autoconf                := autoconf-2.69
autoconf_url            := http://ftp.gnu.org/gnu/autoconf/$(autoconf).tar.xz

prepare-autoconf-rule:
	$(PATCH) -d $(autoconf) -p1 < $(patchdir)/$(autoconf)-fix-documentation.patch

configure-autoconf-rule:
	cd $(autoconf) && ./$(configure)

build-autoconf-rule:
	$(MAKE) -C $(autoconf) all

install-autoconf-rule: $(call installed,m4 perl)
	$(MAKE) -C $(autoconf) install
