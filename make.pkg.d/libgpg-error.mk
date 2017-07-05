libgpg-error            := libgpg-error-1.27
libgpg-error_sha1       := a428758999ff573e62d06892e3d2c0b0f335787c
libgpg-error_url        := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$(libgpg-error).tar.bz2

ifeq ($(host),$(build))
export GPG_ERROR_CONFIG = /usr/bin/gpg-error-config
else
export GPG_ERROR_CONFIG = /usr/bin/$(host)-gpg-error-config
endif

ifneq ($(host),$(build))
$(prepare-rule):
# Create a host-dependent header when cross-compiling.
	test -e $(builddir)/src/syscfg/lock-obj-pub.$(host).h || \
	$(SED) 's/i686-pc-gnu/$(host)/g' \
		< $(builddir)/src/syscfg/lock-obj-pub.i686-pc-gnu.h \
		> $(builddir)/src/syscfg/lock-obj-pub.$(host).h
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-languages \
		--enable-static \
		--enable-threads=posix

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
