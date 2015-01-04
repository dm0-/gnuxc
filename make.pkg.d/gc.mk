gc                      := gc-7.4.2
gc_url                  := http://www.hboehm.info/gc/gc_source/$(gc).tar.gz

prepare-gc-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(gc)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(gc)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(gc)/configure

configure-gc-rule:
	cd $(gc) && ./$(configure) \
		--enable-cplusplus \
		--enable-gc-assertions \
		--enable-gc-debug \
		--enable-large-config \
		--enable-parallel-mark \
		--enable-threads=posix \
		--with-libatomic-ops \
		\
		--disable-gcj-support \
		--disable-handle-fork \
		--disable-sigrt-signals

build-gc-rule:
	$(MAKE) -C $(gc) all

install-gc-rule: $(call installed,libatomic_ops)
	$(MAKE) -C $(gc) install \
		pkgdatadir='$$(docdir)'
	$(INSTALL) -Dpm 644 $(gc)/doc/gc.man $(DESTDIR)/usr/share/man/man3/gc.3
