readline                := readline-7.0.3
readline_branch         := readline-7.0
readline_key            := 7C0135FB088AAF6C66C650B9BB5869F064EA74AB
readline_url            := http://ftpmirror.gnu.org/readline/$(readline_branch).tar.gz

$(foreach l,1 2 3,$(eval $(call verify-download,00$l.patch,http://ftpmirror.gnu.org/readline/$(readline_branch)-patches/readline70-00$l,,$(readline_key))))

$(prepare-rule):
	: $(foreach l,1 2 3,&& $(PATCH) -d $(builddir) < $(call addon-file,00$l.patch))
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
	$(INSTALL) -Dpm 0644 $(call addon-file,inputrc) $(DESTDIR)/etc/inputrc

# Write inline files.
$(call addon-file,inputrc): | $$(@D)
	$(file >$@,$(contents))
$(prepared): $(call addon-file,inputrc)


# Provide default readline settings to fancy up everything.
override define contents
set blink-matching-paren on
set colored-completion-prefix on
set colored-stats on
set mark-symlinked-directories on
"\e[5~": history-search-backward
"\e[6~": history-search-forward
endef
$(call addon-file,inputrc): private override contents := $(value contents)
