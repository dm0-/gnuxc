libpthread-stubs        := libpthread-stubs-0.4
libpthread-stubs_sha1   := c42503a2ae0067b2238b2f3fefc86656baa4dd8e
libpthread-stubs_url    := http://xcb.freedesktop.org/dist/$(libpthread-stubs).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
