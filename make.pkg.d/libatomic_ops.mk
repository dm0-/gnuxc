libatomic_ops           := libatomic_ops-7.6.0
libatomic_ops_sha1      := b7236a3c3d6f3e5da69fe0c7b9508eb814a09825
libatomic_ops_url       := http://www.ivmaisoft.com/_bin/atomic_ops/$(libatomic_ops).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-assertions \
		--enable-atomic-intrinsics \
		--enable-shared

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
