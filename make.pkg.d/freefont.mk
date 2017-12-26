freefont                := freefont-20120503
freefont_key            := A0156C139D2DAA3B352E42CD506361DBA36FDD52
freefont_url            := http://ftpmirror.gnu.org/freefont/$(subst -,-otf-,$(freefont)).tar.gz

ifeq ($(host),$(build))
FREEFONTDIR = /usr/share/fonts/freefont
else
FREEFONTDIR = /usr/share/fonts/gnu-free
endif

$(install-rule):
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/fonts/freefont
	$(INSTALL) -pm 0644 -t $(DESTDIR)/usr/share/fonts/freefont $(builddir)/*.otf
