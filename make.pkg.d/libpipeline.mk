libpipeline             := libpipeline-1.4.1
libpipeline_url         := http://download.savannah.gnu.org/releases/libpipeline/$(libpipeline).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-socketpair-pipe \
		--enable-static \
		--enable-threads=posix

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
