file                    := file-5.28
file_sha1               := 1b789a93bea54da3119d98986468cd90b1e571bf
file_url                := ftp://ftp.astron.com/pub/file/$(file).tar.gz

ifneq ($(host),$(build))
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && $(native) ../configure \
		--disable-shared \
		--disable-silent-rules \
		--enable-static
$(configure-rule): $(call configured,native)

$(call build-rule,native): $(configured)
	$(MAKE) -C $(builddir)/native/src magic.h
	$(MAKE) -C $(builddir)/native/src file
	$(EDIT) '/^FILE_COMPILE *=/s,=.*,= $(CURDIR)/$(builddir)/native/src/file,' $(builddir)/magic/Makefile
$(build-rule): $(call built,native)
endif

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-elf \
		--enable-elf-core \
		--enable-fsect-man5 \
		--enable-static \
		--enable-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,python)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(builddir)/python/magic.py $(DESTDIR)/usr/lib/python`$(PKG_CONFIG) --modversion python3`/site-packages/magic.py
