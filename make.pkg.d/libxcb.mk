libxcb                  := libxcb-1.12
libxcb_sha1             := 2f03490d1c75c8a3f902f74b717af6501773926a
libxcb_url              := http://xcb.freedesktop.org/dist/$(libxcb).tar.bz2

$(eval $(call verify-download,fix-tabs.patch,http://cgit.freedesktop.org/xcb/libxcb/patch/?id=8740a288ca468433141341347aa115b9544891d3,d34514a7c81d1d25e1f945c55bf8a6ff4ded53a3))

$(prepare-rule):
# Drop tabs in favor of spaces.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-tabs.patch)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-composite \
		--enable-damage \
		--enable-dpms \
		--enable-dri2 \
		--enable-dri3 \
		--enable-glx \
		--enable-present \
		--enable-randr \
		--enable-record \
		--enable-render \
		--enable-resource \
		--enable-screensaver \
		--enable-selinux \
		--enable-shape \
		--enable-shm \
		--enable-sync \
		--enable-xevie \
		--enable-xfixes \
		--enable-xfree86-dri \
		--enable-xinerama \
		--enable-xinput \
		--enable-xkb \
		--enable-xprint \
		--enable-xtest \
		--enable-xv \
		--enable-xvmc

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libpthread-stubs libXau xcb-proto)
	$(MAKE) -C $(builddir) install
