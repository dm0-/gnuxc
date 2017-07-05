libsndfile              := libsndfile-1.0.28
libsndfile_sha1         := 85aa967e19f6b9bf975601d79669025e5f8bc77d
libsndfile_url          := http://www.mega-nerd.com/libsndfile/files/$(libsndfile).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--disable-werror \
		--enable-cpu-clip \
		--enable-external-libs \
		--enable-experimental \
		--enable-gcc-{opt,pipe} \
		--enable-sqlite \
		--enable-stack-smash-protection \
		\
		--disable-alsa \
		--disable-octave

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,flac libvorbis speex sqlite)
	$(MAKE) -C $(builddir) install
