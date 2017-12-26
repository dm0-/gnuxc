zlib                    := zlib-1.2.11
zlib_key                := 5ED46A6721D365587791E2AA783FCD8E58BCAFBA
zlib_url                := http://zlib.net/$(zlib).tar.gz
zlib_sig                := $(zlib_url).asc

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
