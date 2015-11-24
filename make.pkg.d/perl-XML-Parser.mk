perl-XML-Parser         := perl-XML-Parser-2.44
perl-XML-Parser_branch  := $(perl-XML-Parser:perl-%=%)
perl-XML-Parser_url     := http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/$(perl-XML-Parser_branch).tar.gz

ifeq ($(host),$(build))
$(configure-rule):
	cd $(builddir) && $(PERL) Makefile.PL INSTALLDIRS=vendor verbose

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,expat perl)
	$(MAKE) -C $(builddir) install
else
$(install-rule): $$(call installed,expat perl)
endif
