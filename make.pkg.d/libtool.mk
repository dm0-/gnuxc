libtool                 := libtool-2.4.2
libtool_url             := http://ftp.gnu.org/gnu/libtool/$(libtool).tar.xz

configure-libtool-rule:
	cd $(libtool) && ./$(configure) \
		--enable-ltdl-install \
		ac_cv_path_SED='$(SED)'

build-libtool-rule:
	$(MAKE) -C $(libtool) all

install-libtool-rule: $(call installed,sed tar)
	$(MAKE) -C $(libtool) install
