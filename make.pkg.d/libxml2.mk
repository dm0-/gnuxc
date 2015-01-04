libxml2                 := libxml2-2.9.2
libxml2_url             := ftp://xmlsoft.org/libxml2/$(libxml2).tar.gz

prepare-libxml2-rule:
# Seriously disable rpaths.
	$(EDIT) 's/\(need_relink\)=yes/\1=no/' $(libxml2)/ltmain.sh
	$(EDIT) 's/\(hardcode_into_libs\)=yes/\1=no/' $(libxml2)/configure
	$(EDIT) 's/\(hardcode_libdir_flag_spec[A-Za-z_]*\)=.*/\1=-D__LIBTOOL_NEUTERED__/' $(libxml2)/configure
# Use pkg-config for python configuration.
	$(EDIT) $(libxml2)/configure \
		-e '/PYTHON_INCLUDES=`/s,`.*`,`$(PKG_CONFIG) --cflags python3`,' \
		-e '/PYTHON_LIBS=`/s,`.*`,`$(PKG_CONFIG) --libs python3`,' \
		-e '/PYTHON_SITE_PACKAGES=`/s,`.*`,`$(PKG_CONFIG) --variable=libdir python3`/python`$(PKG_CONFIG) --modversion python3`/site-packages,' \
		-e '/PYTHON_VERSION=`/s,`.*`,`$(PKG_CONFIG) --modversion python3`,'
	$(EDIT) 's/-I..PYTHON_INCLUDES./$$(PYTHON_INCLUDES)/' $(libxml2)/python/Makefile.in
# Use the correct icu-config script.
	$(EDIT) '/^ *ICU_CONFIG=/s/=.*/=$(ICU_CONFIG)/' $(libxml2)/configure

configure-libxml2-rule:
	cd $(libxml2) && ./$(configure) \
		--disable-silent-rules \
		--with-fexceptions \
		--with-history \
		--with-icu \
		--with-lzma \
		--with-mem-debug \
		--with-python PYTHON='$(PYTHON)' \
		--with-run-debug \
		--with-thread-alloc \
		--with-zlib

build-libxml2-rule:
	$(MAKE) -C $(libxml2) all

install-libxml2-rule: $(call installed,icu4c python readline xz zlib)
	$(MAKE) -C $(libxml2) install \
		DOC_MODULE=libxml2 \
		HTML_DIR='$$(datarootdir)/doc/$$(DOC_MODULE)/html' \
		docsdir='$$(datarootdir)/doc/$$(DOC_MODULE)/python' \
		exampledir='$$(docsdir)/examples'
