git                     := git-2.6.3
git_url                 := http://www.kernel.org/pub/software/scm/git/$(git).tar.xz

$(build-rule) $(install-rule): private override configuration = V=1 \
	prefix=/usr \
	gitwebdir=/var/www/git \
	\
	AR='$(AR)' \
	CC='$(CC)' \
	CFLAGS='$(CFLAGS)' \
	LDFLAGS='$(LDFLAGS)' \
	PERL_PATH='$(PERL)' \
	PYTHON_PATH='$(PYTHON)' \
	STRIP= \
	TCL_PATH='$(TCLSH)' \
	TCLTK_PATH='$(WISH)' \
	\
	DEFAULT_EDITOR=emacs \
	DEFAULT_PAGER=less \
	GNU_ROFF=YesPlease \
	HAVE_CLOCK_GETTIME=YesPlease \
	HAVE_CLOCK_MONOTONIC=YesPlease \
	HAVE_DEV_TTY=YesPlease \
	NO_CURL=YesPlease \
	NO_OPENSSL=YesPlease \
	NO_PERL_MAKEMAKER=YesPlease \
	USE_LIBPCRE=YesPlease \
	$(if $(filter-out $(host),$(build)),UNAME_M=i686-AT386 UNAME_O=GNU UNAME_R=0.7 UNAME_S=GNU UNAME_V='GNU-Mach 1.6/Hurd-0.7')

$(prepare-rule):
# Bypass asciidoc requirement for man pages.
	$(DOWNLOAD) $(git_url:$(git).tar.xz=$(git:git-%=git-manpages-%).tar.xz) | $(TAR) -JC $(builddir)/Documentation -x
# Correct the non-MakeMaker Perl installation path.
	$(EDIT) '/^instdir_SQ *=/s,=.*,= $$(prefix)/share/perl5/vendor_perl,' $(builddir)/perl/Makefile

$(build-rule):
	$(MAKE) -C $(builddir) all $(configuration)

$(install-rule): $$(call installed,less pcre python tk) # perl-Error perl-TermReadKey
	$(MAKE) -C $(builddir) install $(configuration)
# Bypass asciidoc requirement for man pages.
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/man/man{1,5,7}
	$(INSTALL) -pm 644 $(builddir)/Documentation/man1/* $(DESTDIR)/usr/share/man/man1/
	$(INSTALL) -pm 644 $(builddir)/Documentation/man5/* $(DESTDIR)/usr/share/man/man5/
	$(INSTALL) -pm 644 $(builddir)/Documentation/man7/* $(DESTDIR)/usr/share/man/man7/
