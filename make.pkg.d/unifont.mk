unifont                 := unifont-7.0.06
unifont_url             := http://ftpmirror.gnu.org/unifont/$(unifont)/$(unifont).bdf.gz

prepare-unifont-rule:
	$(DOWNLOAD) '$(unifont_url)' | gzip -d > $(unifont)/unifont.bdf

install-unifont-rule:
	$(INSTALL) -Dpm 644 $(unifont)/unifont.bdf $(DESTDIR)/usr/share/fonts/unifont/unifont.bdf
