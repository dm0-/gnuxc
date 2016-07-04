nethack                 := nethack-3.6.0
nethack_sha1            := a94aebcca367954595747ac468d095f12fbf993a
nethack_url             := http://prdownloads.sourceforge.net/nethack/$(subst .,,$(nethack))-src.tgz

$(prepare-rule):
	$(EDIT) '/^#OPTIONS=/aOPTIONS=!autopickup' $(builddir)/sys/unix/sysconf
ifneq ($(host),$(build))
	$(call apply,fix-bitness)

$(call build-rule,native): $(configured)
	$(MAKE) -C $(builddir) spotless
	for util in makedefs tilemap tile2x11 dgn_comp lev_comp dlb ; do \
		$(MAKE) -C $(builddir)/util $$util CC=gcc && \
		$(MOVE) $(builddir)/util/$$util $(builddir)/util/$$util.native || \
		exec false ; done
	$(MAKE) -C $(builddir) spotless
	for util in makedefs tilemap tile2x11 dgn_comp lev_comp dlb ; do \
		$(MAKE) -C $(builddir)/util $$util && \
		$(TOUCH) -r $(builddir)/util/$$util $(builddir)/util/$$util.native && \
		$(MOVE) $(builddir)/util/$$util.native $(builddir)/util/$$util || \
		exec false ; done
$(build-rule): $(call built,native)
endif

$(configure-rule):
	$(SED) < $(call addon-file,gnu.mk) > $(builddir)/sys/unix/hints/gnu \
		-e "s,.(NCURSES_CFLAGS),`$(NCURSESW_CONFIG) --cflags`," \
		-e "s,.(NCURSES_LIBS),`$(NCURSESW_CONFIG) --libs`,"
	cd $(builddir)/sys/unix && $(BASH) setup.sh hints/gnu
	$(EDIT) $(builddir)/Makefile \
		-e '/^.cp src..(GAME) /s,(INSTDIR),(SHELLDIR)/nethack-bin,' \
		-e '/^.cp util.recover /s,(INSTDIR),(SHELLDIR)/nethack-recover,' \
		-e 's,(INSTDIR)/.(GAME),(SHELLDIR)/nethack-bin,' \
		-e 's,(INSTDIR)/recover,(SHELLDIR)/nethack-recover,'
	$(EDIT) $(builddir)/sys/unix/nethack.sh \
		-e 's,^HACK=.*,HACK=/usr/bin/nethack-bin,' \
		-e 's/^cd/test -n "$$NETHACKOPTIONS$$DISPLAY" || NETHACKOPTIONS=windowtype:tty,color\nexport NETHACKOPTIONS\n\n\n&/'

$(build-rule):
	$(MAKE) -C $(builddir) -j1 all \
		COLCMD=cat \
		DESTDIR=
	$(MKFONTDIR) $(builddir)/win/X11
	$(CONVERT) $(builddir)/win/Qt/nhsplash.xpm -background none -gravity Center -extent 192x192 -strip $(builddir)/icon192.png32
	$(CONVERT) $(builddir)/win/Qt/nhsplash.xpm -background none -gravity Center -extent 192x192 -scale 128x128 -strip $(builddir)/icon128.png32
	$(CONVERT) $(builddir)/win/Qt/nhsplash.xpm -background none -gravity Center -extent 192x192 -scale 96x96 -strip $(builddir)/icon96.png32
	$(CONVERT) $(builddir)/win/Qt/nhsplash.xpm -background none -gravity Center -extent 192x192 -scale 64x64 -strip $(builddir)/icon64.png32
	$(CONVERT) $(builddir)/win/Qt/knh.xpm -background none -gravity Center -extent 48x48 -strip $(builddir)/icon48.png32
	$(CONVERT) $(builddir)/win/Qt/knh-mini.xpm -background none -strip $(builddir)/icon16.png32

$(install-rule): $$(call installed,font-adobe-100dpi libXaw)
	$(MAKE) -C $(builddir) install
	$(INSTALL) -Dpm 644 $(call addon-file,tmpfiles.conf) $(DESTDIR)/usr/lib/tmpfiles.d/nethack.conf
	$(INSTALL) -Dpm 644 $(call addon-file,xorg.conf) $(DESTDIR)/etc/X11/xorg.conf.d/nethack.conf
	$(INSTALL) -Dpm 644 $(builddir)/sys/unix/sysconf $(DESTDIR)/etc/nethack.conf
	$(INSTALL) -Dpm 644 $(builddir)/win/X11/fonts.dir $(DESTDIR)/usr/share/fonts/nethack/fonts.dir
	$(INSTALL) -Dpm 644 $(builddir)/win/X11/ibm.bdf $(DESTDIR)/usr/share/fonts/nethack/ibm.bdf
	$(INSTALL) -Dpm 644 $(builddir)/win/X11/nh10.bdf $(DESTDIR)/usr/share/fonts/nethack/nh10.bdf
	$(INSTALL) -Dpm 644 $(builddir)/icon192.png32 $(DESTDIR)/usr/share/icons/hicolor/192x192/apps/nethack.png
	$(INSTALL) -Dpm 644 $(builddir)/icon128.png32 $(DESTDIR)/usr/share/icons/hicolor/128x128/apps/nethack.png
	$(INSTALL) -Dpm 644 $(builddir)/icon96.png32 $(DESTDIR)/usr/share/icons/hicolor/96x96/apps/nethack.png
	$(INSTALL) -Dpm 644 $(builddir)/icon96.png32 $(DESTDIR)/usr/share/icons/hicolor/64x64/apps/nethack.png
	$(INSTALL) -Dpm 644 $(builddir)/icon48.png32 $(DESTDIR)/usr/share/icons/hicolor/48x48/apps/nethack.png
	$(INSTALL) -Dpm 644 $(builddir)/icon16.png32 $(DESTDIR)/usr/share/icons/hicolor/16x16/apps/nethack.png
	$(INSTALL) -Dpm 644 $(builddir)/doc/nethack.6 $(DESTDIR)/usr/share/man/man6/nethack.6
	$(INSTALL) -Dpm 644 $(builddir)/doc/recover.6 $(DESTDIR)/usr/share/man/man6/nethack-recover.6

# Write inline files.
$(call addon-file,gnu.mk tmpfiles.conf xorg.conf): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,gnu.mk tmpfiles.conf xorg.conf)


# Provide build settings for this platform.
override define contents
#-PRE
PREFIX = /usr
HACKDIR = $(PREFIX)/share/$(GAME)
INSTDIR = $(DESTDIR)$(HACKDIR)
SHELLDIR = $(DESTDIR)$(PREFIX)/bin
VARDIR = $(DESTDIR)/var/games/nethack

LINK = $(CC)
CFLAGS += -I../include -DNOTPARMDECL -DSECURE -DDLB -DSYSCF \
	-DHACKDIR=\"$(HACKDIR)\" -DVAR_PLAYGROUND=\"/var/games/nethack\" \
	-DLOCKDIR=\"/var/lock/nethack\" -DSYSCF_FILE=\"/etc/nethack.conf\" \
	-DCOMPRESS=\"/bin/gzip\" -DCOMPRESS_EXTENSION=\".gz\" \
	-DX11_GRAPHICS -DDEFAULT_WINDOW_SYS=\"X11\" -DUSE_XPM \
	$(NCURSES_CFLAGS)
LFLAGS = $(LDFLAGS)

WINSRC = $(WINTTYSRC) $(WINX11SRC)
WINOBJ = $(WINTTYOBJ) $(WINX11OBJ)
WINLIB = $(WINTTYLIB) $(WINX11LIB)

VARDATND = x11tiles NetHack.ad pet_mark.xbm pilemark.xbm rip.xpm

CHOWN = :
CHGRP = :
EXEPERM = 0755
GAMEPERM = $(EXEPERM)
VARDIRPERM = 0755
VARFILEPERM = 0600

#-POST
LEX = flex
YACC = bison -y

WINTTYLIB = $(NCURSES_LIBS)
WINX11LIB += -lXpm
endef
$(call addon-file,gnu.mk): private override contents := $(value contents)


# Provide the configuration to create a lock directory for the game.
$(call addon-file,tmpfiles.conf): private override contents := d /var/lock/nethack 0775 root games


# Provide the X11 configuration to detect the installed fonts.
override define contents
Section "Files"
    FontPath "/usr/share/fonts/nethack"
EndSection
endef
$(call addon-file,xorg.conf): private override contents := $(value contents)
