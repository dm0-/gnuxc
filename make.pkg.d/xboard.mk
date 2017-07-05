xboard                  := xboard-4.8.0-6f6a93
xboard_branch           := gtk3
xboard_sha1             := 6f6a9373ce9ac622b1ca0ff0b78d05a887058f32
xboard_url              := git://git.sv.gnu.org/xboard.git

$(prepare-rule):
# Play normal GNU Chess by default, and use PulseAudio for sound.
	$(EDIT) $(builddir)/xboard.conf \
		-e 's/ChessProgram fairymax/ChessProgram gnuchess/' \
		-e '/^-soundProgram /s/ .*/ "paplay"/'

$(configure-rule):
# Hurd needs to support /dev/ptmx before grantpt can do anything.
	cd $(builddir) && ./$(configure) \
		--disable-rpath \
		--disable-silent-rules \
		--enable-ptys ac_cv_func_grantpt=no \
		--enable-sigint \
		--enable-zippy \
		--with-x \
		--with-gtk

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gnuchess gtk+ librsvg pulseaudio)
	$(MAKE) -C $(builddir) install
