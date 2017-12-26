libpipeline             := libpipeline-1.5.0
libpipeline_key         := AC0A4FF12611B6FCCF01C111393587D97D86500B
libpipeline_url         := http://download.savannah.gnu.org/releases/libpipeline/$(libpipeline).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--enable-socketpair-pipe \
		--enable-static \
		--enable-threads=posix

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
