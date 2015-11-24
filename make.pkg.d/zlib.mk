zlib                    := zlib-1.2.8
zlib_url                := http://zlib.net/$(zlib).tar.gz

$(prepare-rule):
	$(call apply,add-soname)
	$(EDIT) 's/ -L.{sharedlibdir}//g' $(builddir)/zlib.pc.in

ifneq ($(host),$(build))
$(configure-rule): private override export CHOST = $(host)
endif
$(configure-rule):
	cd $(builddir) && ./configure \
		--prefix=/usr \
		--eprefix= \
		--libdir='$${prefix}/lib' \
		--sharedlibdir='$${exec_prefix}/lib'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
