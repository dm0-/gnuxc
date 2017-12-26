adwaita-icon-theme      := adwaita-icon-theme-3.26.1
adwaita-icon-theme_sha1 := c59a9dcb5f80a31cc90efbb964a52e12710113a7
adwaita-icon-theme_url  := http://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.26/$(adwaita-icon-theme).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule):
	$(MAKE) -C $(builddir) install
