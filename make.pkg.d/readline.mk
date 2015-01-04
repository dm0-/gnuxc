readline                := readline-6.3.8
readline_branch         := readline-6.3
readline_url            := http://ftpmirror.gnu.org/readline/$(readline_branch).tar.gz

prepare-readline-rule:
	for n in {001..008} ; do \
		$(DOWNLOAD) "http://ftpmirror.gnu.org/readline/$(readline_branch)-patches/readline63-$$n" | \
		$(PATCH) -d $(readline) ; \
	done
	$(PATCH) -d $(readline) < $(patchdir)/$(readline)-shlib.patch

configure-readline-rule:
	cd $(readline) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-multibyte

build-readline-rule:
	$(MAKE) -C $(readline) all

install-readline-rule: $(call installed,ncurses)
	$(MAKE) -C $(readline) install \
		DESTDIR='$(DESTDIR)'
