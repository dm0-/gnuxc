jbigkit                 := jbigkit-2.1
jbigkit_url             := http://www.cl.cam.ac.uk/~mgk25/download/$(jbigkit).tar.gz

prepare-jbigkit-rule:
	$(PATCH) -d $(jbigkit) < $(patchdir)/$(jbigkit)-environment.patch
	$(PATCH) -d $(jbigkit) < $(patchdir)/$(jbigkit)-shlib.patch

build-jbigkit-rule:
	$(MAKE) -C $(jbigkit) all

install-jbigkit-rule: $(call installed,glibc)
	$(INSTALL) -Dpm 755 $(jbigkit)/pbmtools/jbgtopbm   $(DESTDIR)/usr/bin/jbgtopbm
	$(INSTALL) -Dpm 755 $(jbigkit)/pbmtools/jbgtopbm85 $(DESTDIR)/usr/bin/jbgtopbm85
	$(INSTALL) -Dpm 755 $(jbigkit)/pbmtools/pbmtojbg   $(DESTDIR)/usr/bin/pbmtojbg
	$(INSTALL) -Dpm 755 $(jbigkit)/pbmtools/pbmtojbg85 $(DESTDIR)/usr/bin/pbmtojbg85

	$(INSTALL) -Dpm 644 $(jbigkit)/libjbig/jbig.h    $(DESTDIR)/usr/include/jbig.h
	$(INSTALL) -Dpm 644 $(jbigkit)/libjbig/jbig85.h  $(DESTDIR)/usr/include/jbig85.h
	$(INSTALL) -Dpm 644 $(jbigkit)/libjbig/jbig_ar.h $(DESTDIR)/usr/include/jbig_ar.h

	$(INSTALL) -Dpm 755 $(jbigkit)/libjbig/libjbig.so.2.1   $(DESTDIR)/usr/lib/libjbig.so.2.1
	$(INSTALL) -Dpm 755 $(jbigkit)/libjbig/libjbig85.so.2.1 $(DESTDIR)/usr/lib/libjbig85.so.2.1
	$(SYMLINK) libjbig.so.2.1   $(DESTDIR)/usr/lib/libjbig.so
	$(SYMLINK) libjbig85.so.2.1 $(DESTDIR)/usr/lib/libjbig85.so
	$(INSTALL) -Dpm 644 $(jbigkit)/libjbig/libjbig.a   $(DESTDIR)/usr/lib/libjbig.a
	$(INSTALL) -Dpm 644 $(jbigkit)/libjbig/libjbig85.a $(DESTDIR)/usr/lib/libjbig85.a

	$(INSTALL) -Dpm 644 $(jbigkit)/pbmtools/jbgtopbm.1 $(DESTDIR)/usr/share/man/man1/jbgtopbm.1
	$(INSTALL) -Dpm 644 $(jbigkit)/pbmtools/pbmtojbg.1 $(DESTDIR)/usr/share/man/man1/pbmtojbg.1
	$(SYMLINK) jbgtopbm.1 $(DESTDIR)/usr/share/man/man1/jbgtopbm85.1
	$(SYMLINK) pbmtojbg.1 $(DESTDIR)/usr/share/man/man1/pbmtojbg85.1
	$(INSTALL) -Dpm 644 $(jbigkit)/pbmtools/pbm.5 $(DESTDIR)/usr/share/man/man5/pbm.5
	$(INSTALL) -Dpm 644 $(jbigkit)/pbmtools/pgm.5 $(DESTDIR)/usr/share/man/man5/pgm.5
