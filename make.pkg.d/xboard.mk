xboard                  := xboard-4.8.0
xboard_url              := http://ftpmirror.gnu.org/xboard/$(xboard).tar.gz

prepare-xboard-rule:
	$(EDIT) 's/ChessProgram fairymax/ChessProgram gnuchess/' $(xboard)/xboard.conf

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
		--with-Xaw \
		--with-gtk

build-xboard-rule:
	$(MAKE) -C $(xboard) all

install-xboard-rule: $(call installed,font-adobe-100dpi gnuchess librsvg libXaw)
	$(MAKE) -C $(xboard) install
