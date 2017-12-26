perl                    := perl-5.26.1
perl_sha1               := 403bb1804cb41416153d908eea093f2be22a77f6
perl_url                := http://www.cpan.org/src/5.0/$(perl).tar.xz

export PERL = /usr/bin/perl

ifeq ($(host),$(build))
$(configure-rule):
	cd $(builddir) && ./Configure -des \
		-Dprefix=/usr \
		-Darchlib=/usr/lib/perl5 \
		-Dprivlib=/usr/share/perl5 \
		-Dsiteprefix=/usr/local \
		-Dsitearch=/usr/local/lib/perl5 \
		-Dsitelib=/usr/local/share/perl5 \
		-Dvendorprefix=/usr \
		-Dvendorarch=/usr/lib/perl5/vendor_perl \
		-Dvendorlib=/usr/share/perl5/vendor_perl \
		-Dcc='$(CC)' \
		-Doptimize='$(CFLAGS)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gdbm)
	$(MAKE) -C $(builddir) install
else
$(install-rule): $$(call installed,gdbm)
endif
