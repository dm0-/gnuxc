xz                      := xz-5.2.3
xz_key                  := 3690C240CE51B4670D30AD1C38EE757D69184620
xz_url                  := http://tukaani.org/xz/$(xz).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-symbol-versions

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,coreutils)
	$(MAKE) -C $(builddir) install
