xshogi                  := xshogi-1.4.2
xshogi_url              := http://ftpmirror.gnu.org/gnushogi/$(xshogi).tar.gz

configure-xshogi-rule:
	cd $(xshogi) && ./$(configure) \
		--with-x

build-xshogi-rule:
	$(MAKE) -C $(xshogi) all

install-xshogi-rule: $(call installed,font-adobe-100dpi gnushogi libXaw)
	$(MAKE) -C $(xshogi) install
