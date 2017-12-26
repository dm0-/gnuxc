libXt                   := libXt-1.1.5
libXt_key               := 4A193C06D35E7C670FA4EF0BA2FB9E081F2D130E
libXt_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXt).tar.bz2

$(prepare-rule):
	$(EDIT) '/^app/{s,@appdefaultdir@,$${datarootdir}/X11/app-defaults,g;N;s/\(.*\)\n\(.*\)/\2\n\1/}' $(builddir)/xt.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xkb \
		--with-glib \
		--with-perl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libSM libX11)
	$(MAKE) -C $(builddir) install
