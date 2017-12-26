git                     := git-2.15.1
git_sha1                := 0ff2d0c64621f92e15759b2ca07838858bef8ff0
git_url                 := http://www.kernel.org/pub/software/scm/git/$(git).tar.xz

$(eval $(call verify-download,manpages.tar.xz,$(git_url:$(git).tar.xz=$(git:git-%=git-manpages-%).tar.xz),d891d57fdd2e9303a49c838ea9265e2e1ff9a6e9))

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
	SANE_TEXT_GREP=-a \
	USE_LIBPCRE2=YesPlease \
	$(if $(filter-out $(host),$(build)),UNAME_M=i686-AT386 UNAME_O=GNU UNAME_R=0.9 UNAME_S=GNU UNAME_V='GNU-Mach 1.8/Hurd-0.9')

$(prepare-rule):
# Bypass asciidoc requirement for man pages.
	$(TAR) -C $(builddir)/Documentation -xJf $(call addon-file,manpages.tar.xz)
# Correct the non-MakeMaker Perl installation path.
	$(EDIT) '/^instdir_SQ *=/s,=.*,= $$(prefix)/share/perl5/vendor_perl,' $(builddir)/perl/Makefile

$(build-rule):
	$(MAKE) -C $(builddir) all $(configuration)

$(install-rule): $$(call installed,less pcre2 python tk)
	$(MAKE) -C $(builddir) install $(configuration)
	$(INSTALL) -Dpm 0644 $(call addon-file,git-daemon.scm) $(DESTDIR)/etc/shepherd.d/git-daemon.scm
	$(INSTALL) -Dpm 0644 $(call addon-file,syslog.conf) $(DESTDIR)/etc/syslog.d/git-daemon.conf
	$(INSTALL) -dm 0755 $(DESTDIR)/var/lib/git
	$(INSTALL) -Dm 0600 /dev/null $(DESTDIR)/var/log/syslog/git-daemon.log
# Bypass asciidoc requirement for man pages.
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/man/man{1,5,7}
	$(INSTALL) -pm 0644 $(builddir)/Documentation/man1/* $(DESTDIR)/usr/share/man/man1/
	$(INSTALL) -pm 0644 $(builddir)/Documentation/man5/* $(DESTDIR)/usr/share/man/man5/
	$(INSTALL) -pm 0644 $(builddir)/Documentation/man7/* $(DESTDIR)/usr/share/man/man7/

# Write inline files.
$(call addon-file,git-daemon.scm syslog.conf): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,git-daemon.scm syslog.conf)


# Provide a syslog configuration to log "git-daemon" tagged messages.
override define contents
! git-daemon
*.*					/var/log/syslog/git-daemon.log
endef
$(call addon-file,syslog.conf): private override contents := $(value contents)


# Provide a system service definition for "git-daemon".
override define contents
(define git-daemon-command
  '("/usr/bin/git" "daemon"
    "--base-path=/var/lib/git"
;   "--export-all"  ; Don't require git-daemon-export-ok files in repos.
    "--pid-file=/run/git-daemon.pid"
    "--reuseaddr"
    "--syslog"
    "--verbose"))
(make <service>
  #:docstring "The git-daemon service controls the daemon serving git:// URLs."
  #:provides '(git-daemon git)
  #:requires '(syslogd)
  #:start (make-forkexec-constructor git-daemon-command)
  #:stop (make-kill-destructor))
endef
$(call addon-file,git-daemon.scm): private override contents := $(value contents)
