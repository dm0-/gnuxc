automake                := automake-1.15.1
automake_sha1           := 45632d466c16ecf18d9c18dc4be883cde59acb59
automake_url            := http://ftpmirror.gnu.org/automake/$(automake).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
