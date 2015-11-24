xboard                  := xboard-4.8.0
xboard_url              := http://ftpmirror.gnu.org/xboard/$(xboard).tar.gz

$(prepare-rule):
	$(EDIT) 's/ChessProgram fairymax/ChessProgram gnuchess/' $(builddir)/xboard.conf

$(configure-rule):
# Hurd needs to support /dev/ptmx before grantpt can do anything.
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-ptys ac_cv_func_grantpt=no \
		--enable-sigint \
		--enable-zippy \
		--with-x \
		--with-Xaw \
		\
		--with-gtk # Font rendering is horrible without this.

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,font-adobe-100dpi gnuchess librsvg libXaw)
	$(MAKE) -C $(builddir) install
