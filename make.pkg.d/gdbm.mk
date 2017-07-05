gdbm                    := gdbm-1.13
gdbm_sha1               := 7f2a8301497bbcac91808b011ca533380914fd21
gdbm_url                := http://ftpmirror.gnu.org/gdbm/$(gdbm).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-debug \
		--enable-libgdbm-compat \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
