adwaita-icon-theme      := adwaita-icon-theme-3.24.0
adwaita-icon-theme_sha1 := 333b2d66efbd22e05585a73e4093a769bbee60e0
adwaita-icon-theme_url  := http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.24/$(adwaita-icon-theme).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
