gdbm                    := gdbm-1.11
gdbm_url                := http://ftpmirror.gnu.org/gdbm/$(gdbm).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
