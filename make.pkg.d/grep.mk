grep                    := grep-2.14
grep_url                := http://ftp.gnu.org/gnu/grep/$(grep).tar.xz

configure-grep-rule:
	cd $(grep) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-silent-rules \
		--disable-rpath \
		--enable-threads=posix

build-grep-rule:
	$(MAKE) -C $(grep) all

install-grep-rule: $(call installed,pcre)
	$(MAKE) -C $(grep) install
