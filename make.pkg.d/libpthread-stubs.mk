libpthread-stubs        := libpthread-stubs-0.3
libpthread-stubs_sha1   := 7fc486ad0ec54938f8b781cc374218f50eac8b99
libpthread-stubs_url    := http://xcb.freedesktop.org/dist/$(libpthread-stubs).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
