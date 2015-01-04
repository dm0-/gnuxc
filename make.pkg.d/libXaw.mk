libXaw                  := libXaw-1.0.12
libXaw_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXaw).tar.bz2

prepare-libXaw-rule:
# Fix -Wformat-security issues.
	$(DOWNLOAD) 'http://cgit.freedesktop.org/xorg/lib/libXaw/patch?id=ec7d7c303385a6bdb0833a5aaae96be697cca7ab' | $(PATCH) -d $(libXaw) -p1

configure-libXaw-rule:
	cd $(libXaw) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xaw{6,7}

build-libXaw-rule:
	$(MAKE) -C $(libXaw) all

install-libXaw-rule: $(call installed,libXmu libXpm)
	$(MAKE) -C $(libXaw) install
