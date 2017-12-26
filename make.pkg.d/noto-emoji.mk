noto-emoji              := noto-emoji-20171204
noto-emoji_branch       := noto-emoji-2017-12-04-hamburger-fix
noto-emoji_sha1         := 915836ca964a612499c65cb5573d8ee5aeeb2531
noto-emoji_url          := http://github.com/googlei18n/noto-emoji/archive/$(noto-emoji_branch:noto-emoji-%=v%).tar.gz

$(install-rule):
	$(INSTALL) -Dpm 0644 $(builddir)/fonts/NotoColorEmoji.ttf $(DESTDIR)/usr/share/fonts/noto-emoji/NotoColorEmoji.ttf
	$(INSTALL) -Dpm 0644 $(builddir)/fonts/NotoEmoji-Regular.ttf $(DESTDIR)/usr/share/fonts/noto-emoji/NotoEmoji-Regular.ttf
	$(INSTALL) -Dpm 0644 $(builddir)/fonts/LICENSE $(DESTDIR)/usr/share/doc/noto-emoji/LICENSE
