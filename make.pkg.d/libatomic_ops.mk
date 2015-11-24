libatomic_ops           := libatomic_ops-7.4.2
libatomic_ops_url       := http://www.ivmaisoft.com/_bin/atomic_ops/$(libatomic_ops).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-assertions \
		--enable-shared

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install \
		pkgdatadir='$$(docdir)'
