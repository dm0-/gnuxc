perl-gettext            := perl-gettext-1.05
perl-gettext_branch     := gettext-1.05
perl-gettext_url        := http://cpan.metacpan.org/authors/id/P/PV/PVANDRY/$(perl-gettext_branch).tar.gz

ifeq ($(host),$(build))
configure-perl-gettext-rule:
	cd $(perl-gettext) && $(PERL) Makefile.PL verbose

build-perl-gettext-rule:
	$(MAKE) -C $(perl-gettext) all

install-perl-gettext-rule: $(call installed,perl)
	$(MAKE) -C $(perl-gettext) install
else
configure-perl-gettext-rule:
	cd $(perl-gettext) && $(PERL) Makefile.PL verbose \
		INSTALL_BASE=/usr \
		AR='$(AR)' FULL_AR=/usr/bin/'$(AR)' RANLIB='$(RANLIB)' \
		CC='$(CC)' LD='$(CC)' OPTIMIZE=-O2 \
		{CC,CCCDL,CCDL,LD,LDDL}FLAGS='$(CFLAGS) $(LDFLAGS)' \
		OSNAME=gnu OSVERS=0.5

install-perl-gettext-rule: $(call installed,perl)
endif
