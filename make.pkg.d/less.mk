less                    := less-451
less_url                := http://ftpmirror.gnu.org/less/$(less).tar.gz

configure-less-rule:
	cd $(less) && ./$(configure) \
		--exec-prefix= \
		\
		--with-regex=pcre \
		--with-secure

build-less-rule:
	$(MAKE) -C $(less) all

install-less-rule: $(call installed,pcre)
	$(MAKE) -C $(less) install \
		DESTDIR='$(DESTDIR)'
	$(INSTALL) -Dpm 644 $(less)/profile.sh $(DESTDIR)/etc/profile.d/less.sh

# Provide a bash profile setting to choose the default "less" options.
$(less)/profile.sh: | $(less)
	$(ECHO) 'LESS=-cQR ; export LESS' > $@
$(call prepared,less): $(less)/profile.sh
