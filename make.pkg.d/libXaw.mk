libXaw                  := libXaw-1.0.13
libXaw_sha1             := 15f891fb88aae966b3064dcc1510790a0ebc75a0
libXaw_url              := http://xorg.freedesktop.org/releases/individual/lib/$(libXaw).tar.bz2

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xaw{6,7}

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libXmu libXpm)
	$(MAKE) -C $(builddir) install
