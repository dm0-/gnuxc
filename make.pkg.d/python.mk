python                  := python-3.6.4
python_branch           := $(python:p%=P%)
python_key              := 0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D
python_url              := http://www.python.org/ftp/python/$(python:python-%=%)/$(python_branch).tar.xz
python_sig              := $(python_url).asc

export PYTHON = /usr/bin/python3

$(prepare-rule):
	$(call apply,hurd-port)
	$(RM) $(builddir)/configure
# Fix profiling causing recompiles on install.
	$(EDIT) '/^libainstall:/s/[ \t]all[ \t]/ /g' $(builddir)/Makefile.pre.in

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-big-digits \
		--enable-ipv6 \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-shared \
		--with-doc-strings \
		--with-fpectl \
		--with-lto \
		--with-pymalloc \
		--with-system-expat \
		--with-system-ffi \
		--with-threads \
		\
		--without-ensurepip \
		--without-system-libmpdec \
		CPPFLAGS="`$(PKG_CONFIG) --cflags ncursesw`" \
		MACHDEP=gnu ac_sys_system=GNU

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 expat gdbm libffi sqlite tk xz zlib)
	$(MAKE) -C $(builddir) -j1 install
