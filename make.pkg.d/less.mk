less                    := less-487
less_key                := AE27252BD6846E7D6EAE1DD6F153A7C833235259
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
	$(INSTALL) -Dpm 0644 $(call addon-file,profile.sh) $(DESTDIR)/etc/profile.d/less.sh

# Write inline files.
$(call addon-file,profile.sh): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,profile.sh)


# Provide a bash profile setting to choose the default "less" options.
$(call addon-file,profile.sh): private override contents := LESS=-cQR ; export LESS
