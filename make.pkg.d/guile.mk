guile                   := guile-2.0.11
guile_sha1              := ae86544b39048a160f4db1c0653a79b40b6c1ee6
guile_url               := http://ftpmirror.gnu.org/guile/$(guile).tar.xz

$(eval $(call verify-download,http://git.savannah.gnu.org/cgit/guile.git/patch?id=3a3316e200ac49f0e8e9004c233747efd9f54a04,3e6ec6b9f5458dba7a7cbd05974327693fc41ca5,undefined-home.patch))
$(eval $(call verify-download,http://git.savannah.gnu.org/cgit/guile.git/patch?id=ead362f8d144e7d76af4fd127c024c62b74562fb http://git.savannah.gnu.org/cgit/guile.git/patch?id=1be3063bf60fb1b9e540a3d35ecc3f00002ec0fd,cec47a5e6a468250631bd86b5fdc405c741adc15,new-signals.patch))

export GUILE = /usr/bin/guile
ifeq ($(host),$(build))
export GUILE_CONFIG = /usr/bin/guile-config
else
export GUILE_CONFIG = /usr/bin/$(host)-guile-config
endif

$(prepare-rule):
# Fix readline startup when HOME is undefined.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,undefined-home.patch)
# Add new signal definitions.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,new-signals.patch)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-debug-malloc \
		--enable-guile-debug \
		--with-threads \
		--without-included-regex

$(build-rule):
ifneq ($(host),$(build))
	$(MAKE) -C $(builddir)/meta guile-config PKG_CONFIG=/usr/bin/pkg-config
endif
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gc libffi libtool libunistring readline)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,user.scm) $(DESTDIR)/etc/skel/.guile

# Write inline files.
$(call addon-file,user.scm): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,user.scm)


# Provide default user settings for Guile.
override define contents
(use-modules (ice-9 readline))
(activate-readline)
endef
$(call addon-file,user.scm): private override contents := $(value contents)
