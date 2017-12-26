libatomic_ops           := libatomic_ops-7.6.2
libatomic_ops_sha1      := ebed1891250cc8e2c952b88fc07e1db2a213f7e2
libatomic_ops_url       := http://github.com/ivmai/libatomic_ops/releases/download/v$(libatomic_ops:libatomic_ops-%=%)/$(libatomic_ops).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-assertions \
		--enable-atomic-intrinsics \
		--enable-shared

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
