patch                   := patch-2.7.1
patch_url               := http://ftpmirror.gnu.org/patch/$(patch).tar.xz

configure-patch-rule:
	cd $(patch) && ./$(configure) \
		--disable-silent-rules \
		--enable-gcc-warnings \
		--enable-xattr \
		CPPFLAGS=-DPATH_MAX=4096

build-patch-rule:
	$(MAKE) -C $(patch) all

install-patch-rule: $(call installed,attr)
	$(MAKE) -C $(patch) install
