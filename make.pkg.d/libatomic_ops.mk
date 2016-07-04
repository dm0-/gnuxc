libatomic_ops           := libatomic_ops-7.4.4
libatomic_ops_sha1      := 426af02f1bb8b91979fa8794e9e0b29e2be1e47e
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
