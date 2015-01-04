p11-kit                 := p11-kit-0.22.1
p11-kit_url             := http://p11-glue.freedesktop.org/releases/$(p11-kit).tar.gz

prepare-p11-kit-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(p11-kit)/build/litter/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(p11-kit)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(p11-kit)/configure

configure-p11-kit-rule:
	cd $(p11-kit) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-debug=default \
		--enable-trust-module \
		--with-hash-impl=internal \
		--with-libffi \
		--with-libtasn1 \
		\
		--disable-static \
		--disable-strict \
		ac_cv_func_getauxval=no

build-p11-kit-rule:
	$(MAKE) -C $(p11-kit) all

install-p11-kit-rule: $(call installed,libffi libtasn1)
	$(MAKE) -C $(p11-kit) install
