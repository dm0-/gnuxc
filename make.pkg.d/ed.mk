ed                      := ed-1.12
ed_url                  := http://ftpmirror.gnu.org/ed/$(ed).tar.lz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		CC='$(CC)' \
		CFLAGS='$(CFLAGS)' \
		CPPFLAGS='$(CPPFLAGS)' \
		LDFLAGS='$(LDFLAGS)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
