xshogi                  := xshogi-1.4.2
xshogi_url              := http://ftpmirror.gnu.org/gnushogi/$(xshogi).tar.gz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--with-x

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,font-adobe-100dpi gnushogi libXaw)
	$(MAKE) -C $(builddir) install
