file                    := file-5.22
file_url                := ftp://ftp.astron.com/pub/file/$(file).tar.gz

ifneq ($(host),$(build))
configure-file-native-rule: $(file)/configure
	$(MKDIR) $(file)/native && cd $(file)/native && ../configure \
		--disable-silent-rules CC=gcc
configure-file-rule: $(call configured,file-native)

build-file-native-rule: $(call configured,file)
	$(MAKE) -C $(file)/native/src file
	$(EDIT) '/^FILE_COMPILE *=/s,=.*,= $(CURDIR)/$(file)/native/src/file,' $(file)/magic/Makefile
build-file-rule: $(call built,file-native)

clean-file-native:
	$(RM) $(timedir)/{configure,build}-file-native-{rule,stamp}
.PHONY clean-file: clean-file-native
endif

configure-file-rule:
	cd $(file) && ./$(configure) \
		--disable-silent-rules \
		--enable-elf \
		--enable-elf-core \
		--enable-fsect-man5 \
		--enable-static \
		--enable-warnings

build-file-rule:
	$(MAKE) -C $(file) all

install-file-rule: $(call installed,python)
	$(MAKE) -C $(file) install
	$(INSTALL) -Dpm 644 $(file)/python/magic.py $(DESTDIR)/usr/lib/python`$(PKG_CONFIG) --modversion python3`/site-packages/magic.py
