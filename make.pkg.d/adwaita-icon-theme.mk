adwaita-icon-theme      := adwaita-icon-theme-3.21.2
adwaita-icon-theme_sha1 := 52c3d1c6b169c0206af6f304e2601884e9924034
adwaita-icon-theme_url  := http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.21/$(adwaita-icon-theme).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
