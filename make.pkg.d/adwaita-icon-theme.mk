adwaita-icon-theme      := adwaita-icon-theme-3.18.0
adwaita-icon-theme_url  := http://ftp.gnome.org/pub/GNOME/sources/adwaita-icon-theme/3.18/$(adwaita-icon-theme).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
