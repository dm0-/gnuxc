less                    := less-451
less_url                := http://ftp.gnu.org/gnu/less/$(less).tar.gz

prepare-less-rule:
	$(PATCH) -d $(less) < $(patchdir)/$(less)-environment.patch

configure-less-rule:
	cd $(less) && ./$(configure) \
		--exec-prefix= \
		\
		--with-regex=pcre \
		--with-secure

build-less-rule:
	$(MAKE) -C $(less) all

install-less-rule: $(call installed,pcre)
	$(MAKE) -C $(less) install
