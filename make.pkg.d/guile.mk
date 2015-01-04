guile                   := guile-2.0.11
guile_url               := http://ftpmirror.gnu.org/guile/$(guile).tar.xz

export GUILE = /usr/bin/guile
ifeq ($(host),$(build))
export GUILE_CONFIG = guile-config
else
export GUILE_CONFIG = $(host)-guile-config
endif

prepare-guile-rule:
# Fix readline startup when HOME is undefined.
	$(DOWNLOAD) 'http://git.savannah.gnu.org/cgit/guile.git/patch?id=3a3316e200ac49f0e8e9004c233747efd9f54a04' | $(PATCH) -d $(guile) -p1
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(guile)/build-aux/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(guile)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(guile)/configure

configure-guile-rule:
	cd $(guile) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-debug-malloc \
		--enable-guile-debug \
		--with-threads \
		--without-included-regex \
		ac_cv_libunistring=yes # Our libunistring is too new for configure.

build-guile-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(guile)/meta guile-config PKG_CONFIG=/usr/bin/pkg-config
endif
	$(MAKE) -C $(guile) all

install-guile-rule: $(call installed,gc libffi libtool libunistring readline)
	$(MAKE) -C $(guile) install
	$(INSTALL) -Dpm 644 $(guile)/guile-user $(DESTDIR)/etc/skel/.guile

# Provide default user settings for Guile.
$(guile)/guile-user: | $(guile)
	$(ECHO) -e '(use-modules (ice-9 readline))\n(activate-readline)' > $@
$(call prepared,guile): $(guile)/guile-user
