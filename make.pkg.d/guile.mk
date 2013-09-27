guile                   := guile-2.0.9
guile_url               := http://ftp.gnu.org/gnu/guile/$(guile).tar.xz

ifeq ($(host),$(build))
export GUILE_CONFIG = guile-config
else
export GUILE_CONFIG = $(host)-guile-config
endif

prepare-guile-rule:
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
		--without-included-regex

build-guile-rule:
ifneq ($(host),$(build))
	$(MAKE) -C $(guile)/meta guile-config PKG_CONFIG=/usr/bin/pkg-config
endif
	$(MAKE) -C $(guile) all

install-guile-rule: $(call installed,gc libffi libtool libunistring readline)
	$(MAKE) -C $(guile) install
