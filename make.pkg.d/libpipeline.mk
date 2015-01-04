libpipeline             := libpipeline-1.4.0
libpipeline_url         := http://download.savannah.gnu.org/releases/libpipeline/$(libpipeline).tar.gz

configure-libpipeline-rule:
	cd $(libpipeline) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-socketpair-pipe \
		--enable-static \
		--enable-threads=posix

build-libpipeline-rule:
	$(MAKE) -C $(libpipeline) all

install-libpipeline-rule: $(call installed,glibc)
	$(MAKE) -C $(libpipeline) install
