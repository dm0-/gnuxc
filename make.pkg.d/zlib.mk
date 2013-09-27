zlib                    := zlib-1.2.8
zlib_url                := http://zlib.net/$(zlib).tar.gz

prepare-zlib-rule:
	$(EDIT) 's/ -L.{sharedlibdir}//g' $(zlib)/zlib.pc.in

ifneq ($(host),$(build))
configure-zlib-rule: export CHOST = $(host)
endif
configure-zlib-rule:
	cd $(zlib) && ./configure \
		--prefix=/usr \
		--eprefix= \
		--libdir='$${prefix}/lib' \
		--sharedlibdir='$${exec_prefix}/lib'

build-zlib-rule:
	$(MAKE) -C $(zlib) all

install-zlib-rule: $(call installed,glibc)
	$(MAKE) -C $(zlib) install
