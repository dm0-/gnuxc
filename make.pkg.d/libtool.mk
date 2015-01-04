libtool                 := libtool-2.4.4
libtool_url             := http://ftpmirror.gnu.org/libtool/$(libtool).tar.xz

configure-libtool-rule:
	cd $(libtool) && ./$(configure) \
		--disable-silent-rules \
		--enable-ltdl-install \
		ac_cv_path_SED='$(SED)'

build-libtool-rule:
	$(MAKE) -C $(libtool) all

install-libtool-rule: $(call installed,sed tar)
	$(MAKE) -C $(libtool) install
