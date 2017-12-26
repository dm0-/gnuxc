automake                := automake-1.15.1
automake_key            := F2A38D7EEB2B66405761070D0ADEE10094604D37
automake_url            := http://ftpmirror.gnu.org/automake/$(automake).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
