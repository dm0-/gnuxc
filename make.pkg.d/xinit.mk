xinit                   := xinit-1.3.4
xinit_key               := 7C2608F8E5F9E78D7A3F26FF177544B49AF313FB
xinit_url               := http://xorg.freedesktop.org/releases/individual/app/$(xinit).tar.bz2

$(prepare-rule):
# Fix the VT argument.
	$(EDIT) 's/vt\$$/tty$$/' $(builddir)/startx.cpp

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-strict-compilation xorg_cv_cc_flag__{Werror,errwarn}=no \
		--with-xinitdir='$${sysconfdir}/X11/xinit'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,xauth xorg-server)
	$(MAKE) -C $(builddir) install
