libevent                := libevent-2.0.22
libevent_branch         := libevent-2.0.22-stable
libevent_url            := http://prdownloads.sourceforge.net/levent/$(libevent_branch).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-debug-mode \
		--enable-function-sections \
		--enable-gcc-warnings \
		--enable-thread-support

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,glibc)
	$(MAKE) -C $(builddir) install
