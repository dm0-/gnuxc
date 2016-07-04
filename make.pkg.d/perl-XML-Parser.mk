perl-XML-Parser         := perl-XML-Parser-2.44
perl-XML-Parser_branch  := $(perl-XML-Parser:perl-%=%)
perl-XML-Parser_sha1    := 0ab6b932713ec1f9927a1b1c619b6889a5c12849
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
