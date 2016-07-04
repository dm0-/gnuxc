perl-Locale-gettext     := perl-Locale-gettext-1.07
perl-Locale-gettext_branch := $(perl-Locale-gettext:perl-%=%)
perl-Locale-gettext_sha1 := a23d0b35269c8db49418fa8585a8dbbed6b8fefa
perl-Locale-gettext_url := http://cpan.metacpan.org/authors/id/P/PV/PVANDRY/$(perl-Locale-gettext_branch).tar.gz

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
