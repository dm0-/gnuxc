intltool                := intltool-0.51.0
intltool_url            := http://launchpad.net/intltool/trunk/$(intltool:intltool-%=%)/+download/$(intltool).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl-XML-Parser)
	$(MAKE) -C $(builddir) install
