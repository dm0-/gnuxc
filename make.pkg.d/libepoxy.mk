libepoxy                := libepoxy-1.3.1
libepoxy_url            := http://github.com/anholt/$(subst -,/releases/download/v,$(libepoxy))/$(libepoxy).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-static \
		\
		--disable-strict-compilation

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,mesa)
	$(MAKE) -C $(builddir) install