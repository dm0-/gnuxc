xboard                  := xboard-4.7.2
xboard_url              := http://ftp.gnu.org/gnu/xboard/$(xboard).tar.gz

prepare-xboard-rule:
	$(EDIT) 's/ChessProgram fairymax/ChessProgram gnuchess/' $(xboard)/xboard.conf.in

configure-xboard-rule:
# Hurd needs to support /dev/ptmx before grantpt can do anything.
	cd $(xboard) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-ptys ac_cv_func_grantpt=no \
		--enable-sigint \
		--enable-xpm \
		--enable-zippy \
		--with-x \
		--with-Xaw
#		--without-gtk
#		--without-Xaw3d

build-xboard-rule:
	$(MAKE) -C $(xboard) all

install-xboard-rule: $(call installed,font-adobe-100dpi gnuchess librsvg libXaw)
	$(MAKE) -C $(xboard) install
