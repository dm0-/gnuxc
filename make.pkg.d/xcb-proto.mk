xcb-proto               := xcb-proto-1.12
xcb-proto_sha1          := e93da374ecef9359370edc0160bcb8b2a2f7d9f6
xcb-proto_url           := http://xcb.freedesktop.org/dist/$(xcb-proto).tar.bz2

$(eval $(call verify-download,http://cgit.freedesktop.org/xcb/proto/patch/?id=ea7a3ac6c658164690e0febb55f4467cb9e0bcac,dc41248cafa4d0c8d230aff3fa0dfb19f6a9b502,fix-tabs.patch))
$(eval $(call verify-download,http://cgit.freedesktop.org/xcb/proto/patch/?id=bea5e1c85bdc0950913790364e18228f20395a3d,80368d488e9d551e2b185028de00cfb2d02aafdf,fix-print.patch))

$(prepare-rule):
# Drop tabs in favor of spaces.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-tabs.patch)
# Add parentheses around print function parameters.
	$(PATCH) -d $(builddir) -p1 < $(call addon-file,fix-print.patch)

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
