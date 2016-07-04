gnushogi                := gnushogi-1.5pre-5bb0b5
gnushogi_branch         := master
gnushogi_sha1           := 5bb0b5b2f6953b3250e965c7ecaf108215751a74
gnushogi_url            := git://git.sv.gnu.org/gnushogi.git

ifneq ($(host),$(build))
$(call configure-rule,native): $(builddir)/configure
	$(MKDIR) $(builddir)/native && cd $(builddir)/native && $(native) ../configure
$(configured): $(call configured,native)

$(call build-rule,native): $(call configured,native)
	$(MAKE) -C $(builddir)/native/gnushogi -j1 gnushogi_bootstrap
	$(MKDIR) $(builddir)/hurd/gnushogi
	$(LINK) $(builddir)/{native,hurd}/gnushogi/gnushogi-pattern.inc
	$(LINK) $(builddir)/{native,hurd}/gnushogi/gnuminishogi-pattern.inc
$(build-rule): $(call built,native)
endif

$(prepare-rule):
	$(EDIT) 's/termcap/tinfo/g' $(builddir)/configure.ac

$(configure-rule):
	$(MKDIR) $(builddir)/hurd && cd $(builddir)/hurd && ../$(configure) \
		--libdir='$${datadir}' \
		--with-curses \
		CFLAGS="$(CFLAGS) -D_GNU_SOURCE `$(NCURSES_CONFIG) --cflags`"

$(build-rule):
	$(MAKE) -C $(builddir)/hurd all

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir)/hurd install
	$(SYMLINK) gnushogi.6 $(DESTDIR)/usr/share/man/man6/gnuminishogi.6
