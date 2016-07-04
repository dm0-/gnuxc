gc                      := gc-7.4.4
gc_sha1                 := 52adf4e7779c0a890ec70d0a41671eefdcc4181a
gc_url                  := http://www.hboehm.info/gc/gc_source/$(gc).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-cplusplus \
		--enable-large-config \
		--enable-parallel-mark \
		--enable-threads=posix \
		--with-libatomic-ops \
		\
		$(if $(DEBUG),--enable-gc-assertions,--disable-gc-assertions) \
		$(if $(DEBUG),--enable-gc-debug,--disable-gc-debug) \
		\
		--disable-gcj-support \
		--disable-handle-fork \
		--disable-sigrt-signals

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libatomic_ops)
	$(MAKE) -C $(builddir) install \
		pkgdatadir='$$(docdir)'
	$(INSTALL) -Dpm 644 $(builddir)/doc/gc.man $(DESTDIR)/usr/share/man/man3/gc.3
