zlib                    := zlib-1.2.8
zlib_sha1               := a4d316c404ff54ca545ea71a27af7dbc29817088
zlib_url                := http://zlib.net/$(zlib).tar.gz

$(prepare-rule):
	$(EDIT) 's/ -L.{sharedlibdir}//g' $(builddir)/zlib.pc.in

ifneq ($(host),$(build))
$(configure-rule): private override export CHOST = $(host)
endif
$(configure-rule):
	cd $(builddir) && ./configure \
		--prefix=/usr \
		--eprefix= \
		--libdir='$${prefix}/lib' \
		--sharedlibdir='$${exec_prefix}/lib' \
		--uname=GNU

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
