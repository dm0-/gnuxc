freefont                := freefont-20120503
freefont_sha1           := dad7600fa9eed4116c2aaa561228e3879565f7aa
freefont_url            := http://ftpmirror.gnu.org/freefont/$(subst -,-otf-,$(freefont)).tar.gz

ifeq ($(host),$(build))
FREEFONTDIR = /usr/share/fonts/freefont
else
FREEFONTDIR = /usr/share/fonts/gnu-free
endif

$(install-rule):
	$(INSTALL) -dm 755 $(DESTDIR)/usr/share/fonts/freefont
	$(INSTALL) -pm 644 -t $(DESTDIR)/usr/share/fonts/freefont $(builddir)/*.otf
