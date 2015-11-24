perl-gettext            := perl-gettext-1.07
perl-gettext_branch     := $(perl-gettext:perl-%=Locale-%)
perl-gettext_url        := http://cpan.metacpan.org/authors/id/P/PV/PVANDRY/$(perl-gettext_branch).tar.gz

ifeq ($(host),$(build))
$(configure-rule):
	cd $(builddir) && $(PERL) Makefile.PL INSTALLDIRS=vendor verbose

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,perl)
	$(MAKE) -C $(builddir) install
else
$(install-rule): $$(call installed,perl)
endif
