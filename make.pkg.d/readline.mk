readline                := readline-6.3
readline_url            := http://ftp.gnu.org/gnu/readline/$(readline).tar.gz

prepare-readline-rule:
	$(PATCH) -d $(readline) < $(patchdir)/$(readline)-environment.patch
	$(PATCH) -d $(readline) < $(patchdir)/$(readline)-shlib.patch

configure-readline-rule:
	cd $(readline) && ./$(configure) \
		--exec-prefix= \
		\
		--enable-multibyte bash_cv_wcwidth_broken=no

build-readline-rule:
	$(MAKE) -C $(readline) all

install-readline-rule: $(call installed,ncurses)
	$(MAKE) -C $(readline) install
