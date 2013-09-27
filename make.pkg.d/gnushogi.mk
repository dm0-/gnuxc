gnushogi                := gnushogi-1.4.0
gnushogi_url            := http://ftp.gnu.org/gnu/gnushogi/$(gnushogi).tar.bz2

ifneq ($(host),$(build))
configure-gnushogi-native-rule: $(gnushogi)/configure
	$(MKDIR) $(gnushogi)/native && cd $(gnushogi)/native && ../configure \
		CC=gcc
	$(LINK) $(gnushogi)/*.h $(gnushogi)/native/
	$(LINK) $(gnushogi)/gnushogi/*.{[ch],inc} $(gnushogi)/native/gnushogi/
configure-gnushogi-rule: $(call configured,gnushogi-native)

build-gnushogi-native-rule: $(call configured,gnushogi)
	$(MAKE) -C $(gnushogi)/native gnushogi_compile
	$(MAKE) -C $(gnushogi) gnushogi_compile LCURSES="`$(NCURSES_CONFIG) --libs`"
	$(MOVE) $(gnushogi)/gnushogi/gnushogi{,.host}
	$(COPY) $(gnushogi){/native,}/gnushogi/gnushogi
	$(MAKE) -C $(gnushogi) gnushogi.bbk
	$(MOVE) $(gnushogi)/gnushogi/gnushogi{.host,}
build-gnushogi-rule: $(call built,gnushogi-native)

clean-gnushogi-native:
	$(RM) $(timedir)/{configure,build}-gnushogi-native-{rule,stamp}
.PHONY clean-gnushogi: clean-gnushogi-native
endif

prepare-gnushogi-rule:
# Do not accept non-zero error codes.
	$(EDIT) 's/^.-cd \([^;]*\); .(MAKE)/\t$$(MAKE) -C \1/' $(gnushogi)/Makefile.in

configure-gnushogi-rule:
	cd $(gnushogi) && ./$(configure) \
		--with-x \
		--with-xshogi \
		CFLAGS="$(CFLAGS) `$(NCURSES_CONFIG) --cflags`"

build-gnushogi-rule:
	$(MAKE) -C $(gnushogi) all \
		LCURSES="`$(NCURSES_CONFIG) --libs`" \
		LIBDIR='/var/cache/gnushogi'

install-gnushogi-rule: $(call installed,font-adobe-100dpi libXaw ncurses)
	$(MAKE) -C $(gnushogi) install \
		prefix='$$(DESTDIR)/usr' \
		INFODIR='$$(prefix)/share/info' \
		LIBDIR='$$(DESTDIR)/var/cache/gnushogi' \
		MANDIR='$$(prefix)/share/man/man6'
