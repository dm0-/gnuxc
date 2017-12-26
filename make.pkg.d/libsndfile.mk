libsndfile              := libsndfile-1.0.28
libsndfile_key          := 6A91A5CF22C24C99A35E013FCFDCF91FB242ACED
libsndfile_url          := http://www.mega-nerd.com/libsndfile/files/$(libsndfile).tar.gz
libsndfile_sig          := $(libsndfile_url).asc

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
