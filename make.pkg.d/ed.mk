ed                      := ed-1.14.2
ed_key                  := 1D41C14B272A2219A739FA4F8FE99503132D7742
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
