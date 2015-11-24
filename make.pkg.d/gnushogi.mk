gnushogi                := gnushogi-1.4.2
gnushogi_url            := http://ftpmirror.gnu.org/gnushogi/$(gnushogi).tar.gz

ifneq ($(host),$(build))
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && ../configure \
		CC=gcc
$(configure-rule): $(call configured,native)

$(call build-rule,native): $(configured)
	$(MAKE) -C $(builddir)/native bbk

	$(MAKE) -C $(builddir)/cross pat2inc
	$(MOVE) $(builddir)/cross/gnushogi/pat2inc{,.host}
	$(COPY) $(builddir)/{native,cross}/gnushogi/pat2inc

	$(MAKE) -C $(builddir)/cross gnushogi_compile \
		LCURSES="`$(NCURSES_CONFIG) --libs`" \
		LIBDIR='/var/cache/gnushogi'
	$(MOVE) $(builddir)/cross/gnushogi/gnushogi{,.host}
	$(COPY) $(builddir)/{native,cross}/gnushogi/gnushogi

	$(MAKE) -C $(builddir)/cross bbk
	$(MOVE) $(builddir)/cross/gnushogi/pat2inc{.host,}
	$(MOVE) $(builddir)/cross/gnushogi/gnushogi{.host,}
$(build-rule): $(call built,native)
endif

$(prepare-rule):
	$(EDIT) 's/termcap/tinfo/g' $(builddir)/configure{.ac,}
# Do not accept non-zero error codes.
	$(EDIT) 's/^.-cd \([^ ]*\) && .(MAKE)/\t$$(MAKE) -C \1/' $(builddir)/Makefile.in

$(configure-rule):
	$(MKDIR) $(builddir)/cross && cd $(builddir)/cross && ../$(configure) \
		--with-curses \
		CFLAGS="$(CFLAGS) -D_GNU_SOURCE `$(NCURSES_CONFIG) --cflags`"

$(build-rule):
	$(MAKE) -C $(builddir)/cross all \
		LCURSES="`$(NCURSES_CONFIG) --libs`" \
		LIBDIR='/var/cache/gnushogi'

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir)/cross install \
		prefix='$$(DESTDIR)/usr' \
		INFODIR='$$(prefix)/share/info' \
		LIBDIR='$$(DESTDIR)/var/cache/gnushogi' \
		MANDIR='$$(prefix)/share/man/man6'
