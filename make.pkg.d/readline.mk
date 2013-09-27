readline                := readline-6.2.4
readline_branch         := readline-6.2
readline_url            := http://ftp.gnu.org/gnu/readline/$(readline_branch).tar.gz

prepare-readline-rule:
	for n in {001..004} ; do \
		$(DOWNLOAD) http://ftp.gnu.org/gnu/readline/$(readline_branch)-patches/readline62-$$n | \
		$(PATCH) -d $(readline) ; \
	done
	$(PATCH) -d $(readline) < $(patchdir)/$(readline)-environment.patch
	$(PATCH) -d $(readline) -p1 < $(patchdir)/$(readline)-shlib.patch

configure-readline-rule:
	cd $(readline) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-multibyte

build-readline-rule:
	$(MAKE) -C $(readline) all

install-readline-rule: $(call installed,ncurses)
	$(MAKE) -C $(readline) install
