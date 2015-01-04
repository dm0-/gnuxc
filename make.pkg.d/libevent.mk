libevent                := libevent-2.0.21
libevent_branch         := libevent-2.0.21-stable
libevent_url            := http://prdownloads.sourceforge.net/levent/$(libevent_branch).tar.gz

configure-libevent-rule:
	cd $(libevent) && ./$(configure) \
		--enable-debug-mode \
		--enable-function-sections \
		--enable-gcc-warnings \
		--enable-thread-support

build-libevent-rule:
	$(MAKE) -C $(libevent) all

install-libevent-rule: $(call installed,glibc)
	$(MAKE) -C $(libevent) install
