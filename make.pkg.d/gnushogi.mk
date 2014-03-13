gnushogi                := gnushogi-1.4.2
gnushogi_url            := http://ftp.gnu.org/gnu/gnushogi/$(gnushogi).tar.gz

ifneq ($(host),$(build))
configure-gnushogi-native-rule: $(gnushogi)/configure
	$(MKDIR) $(gnushogi)/native && cd $(gnushogi)/native && ../configure \
		CC=gcc
configure-gnushogi-rule: $(call configured,gnushogi-native)

build-gnushogi-native-rule: $(call configured,gnushogi)
	$(MAKE) -C $(gnushogi)/native bbk

	$(MAKE) -C $(gnushogi)/cross pat2inc
	$(MOVE) $(gnushogi)/cross/gnushogi/pat2inc{,.host}
	$(COPY) $(gnushogi)/{native,cross}/gnushogi/pat2inc

	$(MAKE) -C $(gnushogi)/cross gnushogi_compile \
		LCURSES="`$(NCURSES_CONFIG) --libs`" \
		LIBDIR='/var/cache/gnushogi'
	$(MOVE) $(gnushogi)/cross/gnushogi/gnushogi{,.host}
	$(COPY) $(gnushogi)/{native,cross}/gnushogi/gnushogi

	$(MAKE) -C $(gnushogi)/cross bbk
	$(MOVE) $(gnushogi)/cross/gnushogi/pat2inc{.host,}
	$(MOVE) $(gnushogi)/cross/gnushogi/gnushogi{.host,}
build-gnushogi-rule: $(call built,gnushogi-native)

clean-gnushogi-native:
	$(RM) $(timedir)/{configure,build}-gnushogi-native-{rule,stamp}
.PHONY clean-gnushogi: clean-gnushogi-native
endif

prepare-gnushogi-rule:
	$(EDIT) 's/termcap/tinfo/g' $(gnushogi)/configure{.ac,}
# Do not accept non-zero error codes.
	$(EDIT) 's/^.-cd \([^ ]*\) && .(MAKE)/\t$$(MAKE) -C \1/' $(gnushogi)/Makefile.in

configure-gnushogi-rule:
	$(MKDIR) $(gnushogi)/cross && cd $(gnushogi)/cross && ../$(configure) \
		--with-curses \
		CFLAGS="$(CFLAGS) -D_GNU_SOURCE `$(NCURSES_CONFIG) --cflags`"

build-gnushogi-rule:
	$(MAKE) -C $(gnushogi)/cross all \
		LCURSES="`$(NCURSES_CONFIG) --libs`" \
		LIBDIR='/var/cache/gnushogi'

install-gnushogi-rule: $(call installed,ncurses)
	$(MAKE) -C $(gnushogi)/cross install \
		prefix='$$(DESTDIR)/usr' \
		INFODIR='$$(prefix)/share/info' \
		LIBDIR='$$(DESTDIR)/var/cache/gnushogi' \
		MANDIR='$$(prefix)/share/man/man6'
