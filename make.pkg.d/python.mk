python                  := python-3.4.2
python_branch           := $(python:p%=P%)
python_url              := http://www.python.org/ftp/python/$(python:python-%=%)/$(python_branch).tar.xz

export PYTHON = /usr/bin/python3

ifneq ($(host),$(build))
configure-python-native-rule: $(python)/configure
	$(MKDIR) $(python)/native && cd $(python)/native && ../configure \
		--with-pydebug AR=ar CC=gcc RANLIB=ranlib
configure-python-rule: $(call configured,python-native)

build-python-native-rule: $(call configured,python)
	$(MAKE) -C $(python)/native python
	$(EDIT) '/^PYTHON_FOR_BUILD=/s,[^ ]*$$,$(CURDIR)/$(python)/native/python,' $(python)/Makefile
build-python-rule: $(call built,python-native)

clean-python-native:
	$(RM) $(timedir)/{configure,build}-python-native-{rule,stamp}
.PHONY clean-python: clean-python-native
endif

prepare-python-rule:
ifneq ($(host),$(build))
	$(EDIT) 's,/usr/include/ncursesw,$(sysroot)&,' $(python)/{configure,configure.ac,setup.py}
endif
	$(EDIT) "s/sysconfig.get_config_var('PYTHONFRAMEWORK')/cross_compiling/" $(python)/setup.py
	$(EDIT) "1s,.*,#!/usr/bin/env python3," $(python)/Lib/cgi.py
	$(EDIT) \
		-e '/cross build not supported/s/^#*/#/' \
		-e 's/MACHDEP="unknown"/MACHDEP=gnu/g' \
		$(python)/configure

configure-python-rule:
	cd $(python) && ./$(configure) \
		--enable-big-digits \
		--enable-ipv6 \
		--enable-loadable-sqlite-extensions \
		--enable-shared \
		--with-doc-strings \
		--with-fpectl \
		--with-pydebug \
		--with-pymalloc \
		--with-signal-module \
		--with-system-ffi \
		--with-threads \
		--with-tsc \
		\
		--without-ensurepip \
		--without-system-expat \
		--without-system-libmpdec

build-python-rule:
	$(MAKE) -C $(python) all

install-python-rule: $(call installed,bzip2 gdbm libffi sqlite xz zlib)
	$(MAKE) -C $(python) -j1 install
