libgpg-error            := libgpg-error-1.27
libgpg-error_key        := D8692123C4065DEA5E0F3AB5249B39D24F25E3B6 031EC2536E580D8EA286A9F22071B08A33BD3F06
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
