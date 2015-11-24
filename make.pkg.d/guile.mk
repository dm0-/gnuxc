guile                   := guile-2.0.11
guile_url               := http://ftpmirror.gnu.org/guile/$(guile).tar.xz

export GUILE = /usr/bin/guile
ifeq ($(host),$(build))
export GUILE_CONFIG = guile-config
else
export GUILE_CONFIG = $(host)-guile-config
endif

$(prepare-rule):
# Fix readline startup when HOME is undefined.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/guile.git/patch?id='3a3316e200ac49f0e8e9004c233747efd9f54a04 | $(PATCH) -d $(builddir) -p1
# Add new signal definitions.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/guile.git/patch/?id='{ead362f8d144e7d76af4fd127c024c62b74562fb,1be3063bf60fb1b9e540a3d35ecc3f00002ec0fd} | $(PATCH) -d $(builddir) -p1
	$(call drop-rpath,configure,build-aux/ltmain.sh)

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
