libgpg-error            := libgpg-error-1.23
libgpg-error_sha1       := c6a0c49211955e924593527b32e4b2736cafcda5
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
