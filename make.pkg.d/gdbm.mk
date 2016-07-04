gdbm                    := gdbm-1.12
gdbm_sha1               := 86513e8871bb376bc014e9e5a2d18a8e0a8ea2f5
gdbm_url                := http://ftpmirror.gnu.org/gdbm/$(gdbm).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-libgdbm-compat

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
