gc                      := gc-7.6.2
gc_sha1                 := 55fc1fe8e0d81acdf6cc29455b151ab74c77c4f2
gc_url                  := http://github.com/ivmai/bdwgc/releases/download/v$(gc:gc-%=%)/$(gc).tar.gz

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
	$(INSTALL) -Dpm 0644 $(builddir)/doc/gc.man $(DESTDIR)/usr/share/man/man3/gc.3
