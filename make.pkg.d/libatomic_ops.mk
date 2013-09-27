libatomic_ops           := libatomic_ops-7.3alpha2
libatomic_ops_url       := http://www.hpl.hp.com/personal/Hans_Boehm/gc/gc_source/$(libatomic_ops).tar.gz

configure-libatomic_ops-rule:
	cd $(libatomic_ops) && ./$(configure) \
		--enable-assertions \
		--enable-shared

build-libatomic_ops-rule:
	$(MAKE) -C $(libatomic_ops) all

install-libatomic_ops-rule: $(call installed,glibc)
	$(MAKE) -C $(libatomic_ops) install \
		pkgdatadir='$$(docdir)'
