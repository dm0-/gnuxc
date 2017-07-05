ed                      := ed-1.14.2
ed_sha1                 := 3e8aa331ffbc929884107ff3f8fbd76d01252277
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
