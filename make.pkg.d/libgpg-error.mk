libgpg-error            := libgpg-error-1.17
libgpg-error_url        := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$(libgpg-error).tar.bz2

ifneq ($(host),$(build))
prepare-libgpg-error-rule:
# Create a host-dependent header when cross-compiling.
	$(SED) 's/i486-pc-gnu/$(host)/g' \
		< $(libgpg-error)/src/syscfg/lock-obj-pub.i486-pc-gnu.h \
		> $(libgpg-error)/src/syscfg/lock-obj-pub.$(host).h
endif

configure-libgpg-error-rule:
	cd $(libgpg-error) && ./$(configure) \
		--disable-rpath \
		--enable-languages \
		--enable-static \
		--enable-threads=posix

build-libgpg-error-rule:
	$(MAKE) -C $(libgpg-error) all

install-libgpg-error-rule: $(call installed,glibc)
	$(MAKE) -C $(libgpg-error) install
