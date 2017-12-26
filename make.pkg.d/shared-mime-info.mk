shared-mime-info        := shared-mime-info-1.9
shared-mime-info_sha1   := aae41d8a93c665d25bae704f732fdb1c1551cb5c
shared-mime-info_url    := http://freedesktop.org/~hadess/$(shared-mime-info).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-update-mimedb

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all

$(install-rule): $$(call installed,glib libxml2)
	$(MAKE) -C $(builddir) install
