libvorbis               := libvorbis-1.3.5
libvorbis_sha1          := 7b4cdd4a73fadfed457ae40984cb0cc91146b300
libvorbis_url           := http://downloads.xiph.org/releases/vorbis/$(libvorbis).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-docs \
		--disable-examples \
		--disable-oggtest

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libogg)
	$(MAKE) -C $(builddir) install
