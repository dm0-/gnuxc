gnugo                   := gnugo-3.8
gnugo_url               := http://ftp.gnu.org/gnu/gnugo/$(gnugo).tar.gz

ifneq ($(host),$(build))
configure-gnugo-native-rule: $(gnugo)/configure
	$(MKDIR) $(gnugo)/native && cd $(gnugo)/native && ../configure \
		AR=ar CC=gcc RANLIB=ranlib
configure-gnugo-rule: $(call configured,gnugo-native)

build-gnugo-native-rule: $(call configured,gnugo)
	$(MAKE) -C $(gnugo)/native/engine   libboard.a libengine.a
	$(MAKE) -C $(gnugo)/native/sgf      libsgf.a
	$(MAKE) -C $(gnugo)/native/utils    libutils.a
	$(MAKE) -C $(gnugo)/native/patterns mkpat joseki mkeyes uncompress_fuseki mkmcpat
	$(MAKE) -C $(gnugo)/engine   libboard.a libengine.a
	$(MAKE) -C $(gnugo)/sgf      libsgf.a
	$(MAKE) -C $(gnugo)/utils    libutils.a
	$(MAKE) -C $(gnugo)/patterns mkpat joseki mkeyes uncompress_fuseki mkmcpat
	$(COPY) $(gnugo)/native/patterns/{mkpat,joseki,mkeyes,uncompress_fuseki,mkmcpat} $(gnugo)/patterns/
build-gnugo-rule: $(call built,gnugo-native)

clean-gnugo-native:
	$(RM) $(timedir)/{configure,build}-gnugo-native-{rule,stamp}
.PHONY clean-gnugo: clean-gnugo-native
endif

configure-gnugo-rule:
	cd $(gnugo) && ./$(configure) \
		--enable-color \
		--enable-socket-support \
		--with-curses \
		--with-readline

build-gnugo-rule:
	$(MAKE) -C $(gnugo) all

install-gnugo-rule: $(call installed,readline)
	$(MAKE) -C $(gnugo) install
