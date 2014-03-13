libatomic_ops           := libatomic_ops-7.4.0
libatomic_ops_url       := http://www.hboehm.info/gc/gc_source/$(libatomic_ops).tar.gz

configure-libatomic_ops-rule:
	cd $(libatomic_ops) && ./$(configure) \
		--enable-assertions \
		--enable-shared

build-libatomic_ops-rule:
	$(MAKE) -C $(libatomic_ops) all

install-libatomic_ops-rule: $(call installed,glibc)
	$(MAKE) -C $(libatomic_ops) install \
		pkgdatadir='$$(docdir)'
