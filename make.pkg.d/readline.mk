readline                := readline-7.0.3
readline_branch         := readline-7.0
readline_sha1           := d9095fa14a812495052357e1d678b3f2ac635463
readline_url            := http://ftpmirror.gnu.org/readline/$(readline_branch).tar.gz

$(eval $(call verify-download,$(foreach l,1 2 3,http://ftpmirror.gnu.org/readline/$(readline_branch)-patches/readline70-00$l),46f60a7eb7008a05d2eefa9ffde3118f899327e1,fixes.patch))

$(prepare-rule):
	$(PATCH) -d $(builddir) < $(call addon-file,fixes.patch)
	$(call apply,shlib)

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-multibyte \
		--with-curses

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,ncurses)
	$(MAKE) -C $(builddir) install \
		DESTDIR='$(DESTDIR)'
