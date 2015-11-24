libtool                 := libtool-2.4.6
libtool_url             := http://ftpmirror.gnu.org/libtool/$(libtool).tar.xz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-ltdl-install \
		ac_cv_path_SED='$(SED)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,sed tar)
	$(MAKE) -C $(builddir) install
