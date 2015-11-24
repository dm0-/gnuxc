readline                := readline-6.3.8
readline_branch         := readline-6.3
readline_url            := http://ftpmirror.gnu.org/readline/$(readline_branch).tar.gz

$(prepare-rule):
	$(DOWNLOAD) 'http://ftpmirror.gnu.org/readline/$(readline_branch)-patches/'readline63-{001..008} | $(PATCH) -d $(builddir)
	$(call apply,shlib)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-multibyte

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
