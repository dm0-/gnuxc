unifont                 := unifont-9.0.01
unifont_sha1            := df289330b6df0230bdc44af2332c519466017f7c
unifont_url             := http://ftpmirror.gnu.org/unifont/$(unifont)/$(unifont).bdf.gz

$(eval $(call verify-download,$(unifont_url),$(unifont_sha1),unifont.bdf.gz))

$(prepare-rule):
	gzip -cd $(call addon-file,unifont.bdf.gz) > $(builddir)/unifont.bdf

$(install-rule):
	$(INSTALL) -Dpm 644 $(builddir)/unifont.bdf $(DESTDIR)/usr/share/fonts/unifont/unifont.bdf
