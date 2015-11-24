unifont                 := unifont-8.0.01
unifont_url             := http://ftpmirror.gnu.org/unifont/$(unifont)/$(unifont).bdf.gz

$(prepare-rule):
	$(DOWNLOAD) '$(unifont_url)' | gzip -d > $(builddir)/unifont.bdf

$(install-rule):
	$(INSTALL) -Dpm 644 $(builddir)/unifont.bdf $(DESTDIR)/usr/share/fonts/unifont/unifont.bdf
