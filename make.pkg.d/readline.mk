readline                := readline-6.3.8
readline_branch         := readline-6.3
readline_sha1           := 017b92dc7fd4e636a2b5c9265a77ccc05798c9e1
readline_url            := http://ftpmirror.gnu.org/readline/$(readline_branch).tar.gz

$(eval $(call verify-download,$(foreach l,1 2 3 4 5 6 7 8,http://ftpmirror.gnu.org/readline/$(readline_branch)-patches/readline63-00$l),7d89c1b45d7d15958353102429fa85ad27a45214,fixes.patch))

$(prepare-rule):
	$(PATCH) -d $(builddir) < $(call addon-file,fixes.patch)
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
