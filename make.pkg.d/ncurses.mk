ncurses                 := ncurses-5.9-20140308
ncurses_url             := ftp://invisible-island.net/ncurses/current/$(ncurses).tgz

ifeq ($(host),$(build))
export NCURSES_CONFIG   = ncurses5-config
export NCURSESW_CONFIG  = ncursesw6-config
export NCURSEST_CONFIG  = ncursest6-config
export NCURSESTW_CONFIG = ncursestw6-config
else
export NCURSES_CONFIG   = $(host)-ncurses5-config
export NCURSESW_CONFIG  = $(host)-ncursesw6-config
export NCURSEST_CONFIG  = $(host)-ncursest6-config
export NCURSESTW_CONFIG = $(host)-ncursestw6-config
endif

ncurses_configuration := --exec-prefix= \
	\
	--disable-relink \
	--disable-rpath \
	--disable-rpath-hack \
	--enable-assertions \
	--enable-colorfgbg \
	--enable-overwrite \
	--enable-pc-files --with-pkg-config-libdir='/usr/lib/pkgconfig' \
	--enable-warnings \
	--with-debug \
	--with-shared --with-cxx-shared \
	--with-termlib \
	--with-ticlib \
	--without-dlsym \
	\
	--without-gpm

configure-ncurses-classic-rule: $(ncurses)/configure
	$(MKDIR) $(ncurses)/classic && cd $(ncurses)/classic && ../$(configure) $(ncurses_configuration) \
		--includedir='$${prefix}/include/ncurses'
configure-ncurses-pthread-rule: $(ncurses)/configure
	$(MKDIR) $(ncurses)/pthread && cd $(ncurses)/pthread && ../$(configure) $(ncurses_configuration) \
		--includedir='$${prefix}/include/ncursest' \
		--with-pthread
configure-ncurses-widec-rule: $(ncurses)/configure
	$(MKDIR) $(ncurses)/widec && cd $(ncurses)/widec && ../$(configure) $(ncurses_configuration) \
		--includedir='$${prefix}/include/ncursesw' \
		--enable-ext-colors \
		--enable-widec
configure-ncurses-widec+pthread-rule: $(ncurses)/configure
	$(MKDIR) $(ncurses)/widec+pthread && cd $(ncurses)/widec+pthread && ../$(configure) $(ncurses_configuration) \
		--includedir='$${prefix}/include/ncursestw' \
		--enable-ext-colors \
		--enable-widec \
		--with-pthread

configure-ncurses-rule: configure := $(configure:--docdir%=)
configure-ncurses-rule: configure := $(configure:--localedir%=)
configure-ncurses-rule: $(call configured,ncurses-classic ncurses-pthread ncurses-widec ncurses-widec+pthread)

build-ncurses-classic-rule: $(call configured,ncurses)
	$(MAKE) -C $(ncurses)/classic libs
build-ncurses-pthread-rule: $(call configured,ncurses)
	$(MAKE) -C $(ncurses)/pthread libs
build-ncurses-widec-rule: $(call configured,ncurses)
	$(MAKE) -C $(ncurses)/widec libs
build-ncurses-widec+pthread-rule: $(call configured,ncurses)
	$(MAKE) -C $(ncurses)/widec+pthread all

build-ncurses-rule: $(call built,ncurses-classic ncurses-pthread ncurses-widec ncurses-widec+pthread)

install-ncurses-rule: $(call installed,libpthread)
	$(MAKE) -C $(ncurses)/classic       install.libs
	$(MAKE) -C $(ncurses)/pthread       install.libs
	$(MAKE) -C $(ncurses)/widec         install.libs
	$(MAKE) -C $(ncurses)/widec+pthread install

clean-ncurses-variants:
	$(RM) $(timedir)/{build,configure}-ncurses-{classic,pthread,widec,widec+pthread}-{rule,stamp}
.PHONY clean-ncurses: clean-ncurses-variants
