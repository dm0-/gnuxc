flac                    := flac-1.3.2
flac_sha1               := 2bdbb56b128a780a5d998e230f2f4f6eb98f33ee
flac_url                := http://downloads.xiph.org/releases/flac/$(flac).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-oggtest \
		--disable-rpath \
		--disable-werror \
		--enable-altivec \
		--enable-asm-optimizations \
		--enable-cpplibs \
		--enable-debug \
		--enable-ogg \
		--enable-sse \
		--enable-stack-smash-protection \
		--enable-static \
		--with-ogg=$(sysroot)/usr \
		\
		--disable-xmms-plugin

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libogg)
	$(MAKE) -C $(builddir) install
