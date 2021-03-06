gnugo                   := gnugo-3.8
gnugo_key               := 67CCE2F5220D3E03024A175B68E7E09135C3EC3E
gnugo_url               := http://ftpmirror.gnu.org/gnugo/$(gnugo).tar.gz

ifneq ($(host),$(build))
$(call configure-rule,native): private override export CFLAGS_FOR_BUILD := $(CFLAGS_FOR_BUILD) -Wno-error=format-security
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && $(native) ../configure
$(configure-rule): $(call configured,native)

$(call build-rule,native): $(configured)
	$(MAKE) -C $(builddir)/native/engine   libboard.a libengine.a
	$(MAKE) -C $(builddir)/native/sgf      libsgf.a
	$(MAKE) -C $(builddir)/native/utils    libutils.a
	$(MAKE) -C $(builddir)/native/patterns mkpat joseki mkeyes uncompress_fuseki mkmcpat
	$(MAKE) -C $(builddir)/engine   libboard.a libengine.a
	$(MAKE) -C $(builddir)/sgf      libsgf.a
	$(MAKE) -C $(builddir)/utils    libutils.a
	$(MAKE) -C $(builddir)/patterns mkpat joseki mkeyes uncompress_fuseki mkmcpat
	$(COPY) $(builddir)/native/patterns/{mkpat,joseki,mkeyes,uncompress_fuseki,mkmcpat} $(builddir)/patterns/
$(build-rule): $(call built,native)
endif

$(configure-rule): private override export CFLAGS := $(CFLAGS) -Wno-error=format-security
$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--enable-color \
		--enable-socket-support \
		--with-curses \
		--with-readline

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,readline)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 0644 $(builddir)/interface/gnugo.el $(DESTDIR)/usr/share/emacs/site-lisp/gnugo.el
	$(INSTALL) -Dpm 0644 $(builddir)/interface/gnugo-xpms.el $(DESTDIR)/usr/share/emacs/site-lisp/gnugo-xpms.el
	$(INSTALL) -Dpm 0644 $(builddir)/interface/gnugo-big-xpms.el $(DESTDIR)/usr/share/emacs/site-lisp/gnugo-big-xpms.el
	$(INSTALL) -Dpm 0644 $(call addon-file,autoload.el) $(DESTDIR)/usr/share/emacs/site-lisp/site-start.d/gnugo.el

# Write inline files.
$(call addon-file,autoload.el): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,autoload.el)


# Provide an auto-load file for the Emacs mode.
$(call addon-file,autoload.el): private override contents := (autoload 'gnugo "gnugo" "Play GNU Go." t)
