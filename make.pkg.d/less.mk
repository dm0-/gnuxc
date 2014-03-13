less                    := less-451
less_url                := http://ftp.gnu.org/gnu/less/$(less).tar.gz

prepare-less-rule:
	$(PATCH) -d $(less) < $(patchdir)/$(less)-environment.patch
	$(ECHO) 'LESS=-cQR ; export LESS' > $(less)/less.sh

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
	$(INSTALL) -Dpm 644 $(less)/less.sh $(DESTDIR)/etc/profile.d/less.sh
