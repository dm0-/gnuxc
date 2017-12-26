libevent                := libevent-2.1.8
libevent_branch         := $(libevent)-stable
libevent_key            := 9E3AC83A27974B84D1B3401DB86086848EF8686D
libevent_url            := http://github.com/libevent/libevent/releases/download/$(libevent_branch:libevent-%=release-%)/$(libevent_branch).tar.gz
libevent_sig            := $(libevent_url).asc

$(configure-rule):
	cd $(builddir) && ./$(configure) \
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
