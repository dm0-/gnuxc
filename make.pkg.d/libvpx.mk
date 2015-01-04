libvpx                  := libvpx-1.3.0
libvpx_branch           := $(subst -,-v,$(libvpx))
libvpx_url              := http://webm.googlecode.com/files/$(libvpx_branch).tar.bz2

configure-libvpx-rule:
	cd $(libvpx) && CROSS='$(host)-' ./configure \
		--target=generic-gnu \
		--prefix=/usr \
		--enable-debug \
		--enable-error-concealment \
		--enable-extra-warnings \
		--enable-install-{bin,lib}s \
		--enable-internal-stats \
		--enable-mem-tracker \
		--enable-pic \
		--enable-{,vp9-}postproc \
		--enable-shared \
		--enable-vp{8,9}

build-libvpx-rule:
	$(MAKE) -C $(libvpx) all V=1

install-libvpx-rule: $(call installed,glibc)
	$(MAKE) -C $(libvpx) install V=1
