libvpx                  := libvpx-1.6.1
libvpx_sha1             := a8bd0596915489d3bd8eded98d408ab8705e2f5d
libvpx_url              := http://storage.googleapis.com/downloads.webmproject.org/releases/webm/$(libvpx).tar.bz2

$(configure-rule):
	cd $(builddir) && CROSS='$(host)-' ./configure \
		--target=generic-gnu \
		--prefix=/usr \
		--enable-debug \
		--enable-error-concealment \
		--enable-extra-warnings \
		--enable-internal-stats \
		--enable-multi-res-encoding \
		--enable-onthefly-bitpacking \
		--enable-pic \
		--enable-{,vp9-}{postproc,temporal-denoising} \
		--enable-shared \
		--enable-vp{8,9} \
		--enable-vp9-highbitdepth \
		--enable-webm-io \
		\
		--disable-libyuv \
		--disable-unit-tests

$(build-rule):
	$(MAKE) -C $(builddir) all V=1

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install V=1
