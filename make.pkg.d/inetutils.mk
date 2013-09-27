inetutils               := inetutils-1.9.1.100
inetutils_url           := http://alpha.gnu.org/gnu/inetutils/$(inetutils).tar.xz

prepare-inetutils-rule:
	$(EDIT) "s,\(LIBNCURSES=\)[^ ]*,\1'`$(NCURSES_CONFIG) --libs`'," $(inetutils)/configure

configure-inetutils-rule:
	cd $(inetutils) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-clients \
		--enable-ipv6 \
		--enable-libls \
		--enable-ncurses \
		--enable-readline \
		--enable-servers \
		--enable-threads=posix \
		--with-idn \
		--without-included-regex \
		\
		--without-pam \
		--without-wrap
#		--disable-authentication \
#		--disable-encryption

build-inetutils-rule:
	$(MAKE) -C $(inetutils) all \
		inetdaemondir='$$(sbindir)'

install-inetutils-rule: $(call installed,libidn readline)
	$(MAKE) -C $(inetutils) install \
		inetdaemondir='$$(sbindir)'
