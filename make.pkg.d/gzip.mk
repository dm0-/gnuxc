gzip                    := gzip-1.8
gzip_key                := 155D3FC500C834486D1EEA677FD9FCCB000BEEEE
gzip_url                := http://ftpmirror.gnu.org/gzip/$(gzip).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--enable-gcc-warnings gl_cv_warn_c__Werror=no \
		--enable-threads=posix

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,coreutils)
	$(MAKE) -C $(builddir) install
