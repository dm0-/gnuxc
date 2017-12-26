emms                    := emms-4.4
emms_key                := 691BF9D0EEC472730726EB7869725A21D60EEC42
emms_url                := http://ftpmirror.gnu.org/emms/$(emms).tar.gz

$(prepare-rule):
	$(call apply,default-pulseaudio)

$(install-rule): $$(call installed,emacs)
	$(INSTALL) -dm 0755 $(DESTDIR)/usr/share/emacs/site-lisp/emms
	$(INSTALL) -pm 0644 -t $(DESTDIR)/usr/share/emacs/site-lisp/emms $(builddir)/lisp/*.el
	$(RM) $(DESTDIR)/usr/share/emacs/site-lisp/emms/emms-{auto,maint}.el
	$(INSTALL) -dm 0755 $(DESTDIR)/etc/skel/.emacs.d/emms
