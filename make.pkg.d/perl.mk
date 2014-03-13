perl                    := perl-5.18.2
perl_url                := http://www.cpan.org/src/5.0/$(perl).tar.bz2

export PERL = /usr/bin/perl

prepare-perl-rule:
	$(SYMLINK) configure.gnu $(perl)/configure

ifneq ($(host),$(build))
install-perl-rule: $(call installed,gdbm)
else
configure-perl-rule:
	cd $(perl) && ./configure \
		--prefix=/usr

build-perl-rule:
	$(MAKE) -C $(perl) all

install-perl-rule: $(call installed,gdbm)
	$(MAKE) -C $(perl) install
endif
