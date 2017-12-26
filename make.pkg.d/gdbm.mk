gdbm                    := gdbm-1.13
gdbm_key                := 325F650C4C2B6AD58807327A3602B07F55D0C732
gdbm_url                := http://ftpmirror.gnu.org/gdbm/$(gdbm).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-debug \
		--enable-libgdbm-compat \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
