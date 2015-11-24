libgpg-error            := libgpg-error-1.20
libgpg-error_url        := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$(libgpg-error).tar.bz2

ifneq ($(host),$(build))
$(prepare-rule):
# Create a host-dependent header when cross-compiling.
	test -e $(builddir)/src/syscfg/lock-obj-pub.$(host).h || \
	$(SED) 's/i486-pc-gnu/$(host)/g' \
		< $(builddir)/src/syscfg/lock-obj-pub.i486-pc-gnu.h \
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
