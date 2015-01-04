xz                      := xz-5.2.0
xz_url                  := http://tukaani.org/xz/$(xz).tar.xz

configure-xz-rule:
	cd $(xz) && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-symbol-versions

build-xz-rule:
	$(MAKE) -C $(xz) all

install-xz-rule: $(call installed,coreutils)
	$(MAKE) -C $(xz) install
