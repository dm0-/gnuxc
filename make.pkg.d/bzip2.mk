bzip2                   := bzip2-1.0.6
bzip2_url               := http://www.bzip.org/$(bzip2:bzip2-%=%)/$(bzip2).tar.gz

$(build-rule):
	$(MAKE) -C $(builddir) libbz2.a bzip2recover \
		AR='$(AR)' CC='$(CC)' RANLIB='$(RANLIB)' \
		CFLAGS='$(CFLAGS)' LDFLAGS='$(LDFLAGS)' \
		PREFIX=/usr
	$(MAKE) -C $(builddir) -f Makefile-libbz2_so all \
		CC='$(CC)' \
		CFLAGS='$(CFLAGS)'

$(install-rule): $$(call installed,coreutils)
# The shared library's Makefile has no install section.
	$(INSTALL) -Dpm 755 $(builddir)/bzip2-shared $(DESTDIR)/usr/bin/bzip2
	$(INSTALL) -Dpm 644 $(builddir)/bzip2.1 $(DESTDIR)/usr/share/man/man1/bzip2.1
	$(INSTALL) -Dpm 755 $(builddir)/libbz2.so.$(bzip2:bzip2-%=%) $(DESTDIR)/lib/libbz2.so.$(bzip2:bzip2-%=%)
	$(SYMLINK) libbz2.so.$(bzip2:bzip2-%=%) $(DESTDIR)/lib/libbz2.so.1.0
# The main Makefile's install section shouldn't be used.
	$(INSTALL) -pm 755 -t $(DESTDIR)/usr/bin            $(builddir)/bz{grep,more,diff,ip2recover}
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/man/man1 $(builddir)/bz{grep,more,diff}.1
	$(INSTALL) -Dpm 644 $(builddir)/libbz2.a $(DESTDIR)/usr/lib/libbz2.a
	$(SYMLINK) ../../lib/libbz2.so.1.0       $(DESTDIR)/usr/lib/libbz2.so
	$(INSTALL) -Dpm 644 $(builddir)/bzlib.h  $(DESTDIR)/usr/include/bzlib.h
	$(SYMLINK) bzip2  $(DESTDIR)/usr/bin/bunzip2
	$(SYMLINK) bzip2  $(DESTDIR)/usr/bin/bzcat
	$(SYMLINK) bzgrep $(DESTDIR)/usr/bin/bzegrep
	$(SYMLINK) bzgrep $(DESTDIR)/usr/bin/bzfgrep
	$(SYMLINK) bzmore $(DESTDIR)/usr/bin/bzless
	$(SYMLINK) bzdiff $(DESTDIR)/usr/bin/bzcmp
	$(SYMLINK) bzip2.1  $(DESTDIR)/usr/share/man/man1/bzip2recover.1
	$(SYMLINK) bzip2.1  $(DESTDIR)/usr/share/man/man1/bunzip2.1
	$(SYMLINK) bzip2.1  $(DESTDIR)/usr/share/man/man1/bzcat.1
	$(SYMLINK) bzgrep.1 $(DESTDIR)/usr/share/man/man1/bzegrep.1
	$(SYMLINK) bzgrep.1 $(DESTDIR)/usr/share/man/man1/bzfgrep.1
	$(SYMLINK) bzmore.1 $(DESTDIR)/usr/share/man/man1/bzless.1
	$(SYMLINK) bzdiff.1 $(DESTDIR)/usr/share/man/man1/bzcmp.1
