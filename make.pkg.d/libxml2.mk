libxml2                 := libxml2-2.9.7
libxml2_key             := C74415BA7C9C7F78F02E1DC34606B8A5DE95BC1F
libxml2_url             := ftp://xmlsoft.org/libxml2/$(libxml2).tar.gz
libxml2_sig             := $(libxml2_url).asc

$(prepare-rule):
# Use pkg-config for python configuration.
	$(EDIT) $(builddir)/configure \
		-e '/PYTHON_INCLUDES=`/s,`.*`,`$(PKG_CONFIG) --cflags python3`,' \
		-e '/PYTHON_LIBS=`/s,`.*`,`$(PKG_CONFIG) --libs python3`,' \
		-e '/PYTHON_SITE_PACKAGES=`/s,`.*`,`$(PKG_CONFIG) --variable=libdir python3`/python`$(PKG_CONFIG) --modversion python3`/site-packages,' \
		-e '/PYTHON_VERSION=`/s,`.*`,`$(PKG_CONFIG) --modversion python3`,'
	$(EDIT) 's/-I..PYTHON_INCLUDES./$$(PYTHON_INCLUDES)/' $(builddir)/python/Makefile.in
# Use the correct icu-config script.
	$(EDIT) '/^ *ICU_CONFIG=/s,=.*,=$(ICU_CONFIG),' $(builddir)/configure

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-fexceptions \
		--with-history \
		--with-icu \
		--with-lzma \
		--with-python \
		--with-readline \
		--with-thread-alloc \
		--with-zlib \
		\
		$(if $(DEBUG),--with-mem-debug,--without-mem-debug) \
		$(if $(DEBUG),--with-run-debug,--without-run-debug)

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,icu4c readline xz zlib)
	$(MAKE) -C $(builddir) install \
		DOC_MODULE=libxml2 \
		HTML_DIR='$$(datarootdir)/doc/$$(DOC_MODULE)/html' \
		docsdir='$$(datarootdir)/doc/$$(DOC_MODULE)/python' \
		exampledir='$$(docsdir)/examples'
