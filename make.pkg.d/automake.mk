automake                := automake-1.15
automake_sha1           := c279b35ca6c410809dac8ade143b805fb48b7655
automake_url            := http://ftpmirror.gnu.org/automake/$(automake).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
