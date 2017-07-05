libevent                := libevent-2.1.8
libevent_branch         := $(libevent)-stable
libevent_sha1           := 2a1b8bb7a262d3fd0ed6a080a20991a6eed675ec
libevent_url            := http://github.com/libevent/libevent/releases/download/$(libevent_branch:libevent-%=release-%)/$(libevent_branch).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--disable-silent-rules \
		--enable-clock-gettime \
		--enable-debug-mode \
		--enable-function-sections \
		--enable-thread-support \
		\
		--disable-gcc-warnings

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
