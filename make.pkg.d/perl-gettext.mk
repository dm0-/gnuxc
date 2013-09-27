perl-gettext            := perl-gettext-1.05
perl-gettext_branch     := gettext-1.05
perl-gettext_url        := http://search.cpan.org/CPAN/authors/id/P/PV/PVANDRY/$(perl-gettext_branch).tar.gz

ifneq ($(host),$(build))
install-perl-gettext-rule: $(call installed,perl)
else
configure-perl-gettext-rule:
	cd $(perl-gettext) && $(PERL) Makefile.PL

build-perl-gettext-rule:
	$(MAKE) -C $(perl-gettext) all

install-perl-gettext-rule: $(call installed,perl)
	$(MAKE) -C $(perl-gettext) install
endif
