freefont                := freefont-20120503
freefont_url            := http://ftpmirror.gnu.org/freefont/$(subst -,-otf-,$(freefont)).tar.gz

ifeq ($(host),$(build))
FREEFONTDIR = /usr/share/fonts/freefont
else
FREEFONTDIR = /usr/share/fonts/gnu-free
endif

install-freefont-rule:
	for font in $(freefont)/*.otf ; \
	do $(INSTALL) -Dpm 644 $$font $(DESTDIR)/usr/share/fonts/freefont/$${font##*/} ; \
	done
