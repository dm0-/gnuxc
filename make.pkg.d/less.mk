less                    := less-487
less_sha1               := 8a5c4be2a51f11543793defec7ccb77c525f007e
less_url                := http://ftpmirror.gnu.org/less/$(less).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--with-editor=emacs \
		--with-regex=pcre \
		--with-secure

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,pcre)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
	$(INSTALL) -Dpm 644 $(call addon-file,profile.sh) $(DESTDIR)/etc/profile.d/less.sh

# Write inline files.
$(call addon-file,profile.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,profile.sh)


# Provide a bash profile setting to choose the default "less" options.
$(call addon-file,profile.sh): private override contents := LESS=-cQR ; export LESS
