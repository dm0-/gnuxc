bzip2                   := bzip2-1.0.6
bzip2_url               := http://www.bzip.org/$(bzip2:bzip2-%=%)/$(bzip2).tar.gz

prepare-bzip2-rule:
	$(PATCH) -d $(bzip2) < $(patchdir)/$(bzip2)-environment.patch
	$(PATCH) -d $(bzip2) < $(patchdir)/$(bzip2)-explicit-test.patch
	$(PATCH) -d $(bzip2) < $(patchdir)/$(bzip2)-standard-paths.patch
	$(PATCH) -d $(bzip2) < $(patchdir)/$(bzip2)-relative-links.patch

build-bzip2-rule:
	$(MAKE) -C $(bzip2) all \
		PREFIX=/usr \
		EPREFIX=
	$(MAKE) -C $(bzip2) -f Makefile-libbz2_so all

install-bzip2-rule: $(call installed,coreutils)
	$(MAKE) -C $(bzip2) install \
		PREFIX=$(DESTDIR)/usr \
		EPREFIX=$(DESTDIR)
	$(INSTALL) -Dpm 755 $(bzip2)/bzip2-shared $(DESTDIR)/bin/bzip2
	$(INSTALL) -Dpm 755 $(bzip2)/libbz2.so.1.0.6 $(DESTDIR)/lib/libbz2.so.1.0.6
	$(SYMLINK) libbz2.so.1.0.6 $(DESTDIR)/lib/libbz2.so.1.0
	$(SYMLINK) libbz2.so.1.0 $(DESTDIR)/lib/libbz2.so
