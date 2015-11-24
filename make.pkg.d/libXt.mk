libXt                   := libXt-1.1.5
libXt_url               := http://xorg.freedesktop.org/releases/individual/lib/$(libXt).tar.bz2

$(prepare-rule):
	$(EDIT) '/^app/{s,@appdefaultdir@,$${datarootdir}/X11/app-defaults,g;N;s/\(.*\)\n\(.*\)/\2\n\1/}' $(builddir)/xt.pc.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--enable-xkb \
		--with-glib \
		--with-perl

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,libSM libX11)
	$(MAKE) -C $(builddir) install
