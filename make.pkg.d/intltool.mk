intltool                := intltool-0.51.0
intltool_key            := 9EBD001680E8C8F9FAC61A9BE1A701D4C9DE75B5
intltool_url            := http://launchpad.net/intltool/trunk/$(intltool:intltool-%=%)/+download/$(intltool).tar.gz
intltool_sig            := $(intltool_url).asc

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl-XML-Parser)
	$(MAKE) -C $(builddir) install
