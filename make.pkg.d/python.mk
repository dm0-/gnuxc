python                  := python-3.5.0
python_branch           := $(python:p%=P%)
python_url              := http://www.python.org/ftp/python/$(python:python-%=%)/$(python_branch).tar.xz

export PYTHON = /usr/bin/python3

ifneq ($(host),$(build))
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && env -i CFLAGS='$(CFLAGS)' PATH=/bin \
		../configure --with-pydebug
$(configure-rule): $(call configured,native)

$(call build-rule,native): $(configured)
	$(MAKE) -C $(builddir)/native Parser/pgen python
	$(EDIT) $(builddir)/Makefile \
		-e '/^\t[\t ]*.(PGEN)/s,.(PGEN),$$(CURDIR)/native/Parser/pgen,' \
		-e '/^PYTHON_FOR_BUILD=/s,[^ ]*$$,$$(CURDIR)/native/python,'
$(build-rule): $(call built,native)
endif

$(prepare-rule):
ifneq ($(host),$(build))
	$(EDIT) 's,/usr/include/ncursesw,$(sysroot)&,' $(builddir)/{configure,configure.ac,setup.py}
# Don't regenerate importlib headers.
	$(EDIT) '/: /s, Programs/_freeze_importlib$$,,' $(builddir)/Makefile.pre.in
endif
	$(EDIT) "s/sysconfig.get_config_var('PYTHONFRAMEWORK')/cross_compiling/" $(builddir)/setup.py
	$(EDIT) "1s,.*,#!/usr/bin/env python3," $(builddir)/Lib/cgi.py
	$(EDIT) $(builddir)/configure \
		-e '/cross build not supported/s/^#*/#/' \
		-e 's/MACHDEP="unknown"/MACHDEP=gnu/g'

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-big-digits \
		--enable-ipv6 \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
		--with-doc-strings \
		--with-fpectl \
		--with-pydebug \
		--with-pymalloc \
		--with-signal-module \
		--with-system-expat \
		--with-system-ffi \
		--with-threads \
		--with-tsc \
		\
		--without-ensurepip \
		--without-system-libmpdec

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,bzip2 expat gdbm libffi sqlite tk xz zlib)
	$(MAKE) -C $(builddir) -j1 install
