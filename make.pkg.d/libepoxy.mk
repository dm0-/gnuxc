libepoxy                := libepoxy-1.4.3
libepoxy_sha1           := e29ebdba0d1d4601431639331d2e6f39f180972d
libepoxy_url            := http://ftp.gnome.org/pub/gnome/sources/libepoxy/1.4/$(libepoxy).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-glx \
		--enable-static \
		\
		--disable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mesa)
	$(MAKE) -C $(builddir) install
