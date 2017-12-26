tzdb                    := tzdb-2017c
tzdb_key                := 7E3792A9D8ACF7D633BC1588ED97E90E62AA7E34
tzdb_url                := http://www.iana.org/time-zones/repository/releases/$(tzdb).tar.lz
tzdb_sig                := $(tzdb_url).asc

$(build-rule) $(install-rule): private override configuration = \
	TOPDIR=/usr \
	ETCDIR='$$(TOPDIR)'/sbin \
	MANDIR='$$(TOPDIR)'/share/man \
	TZDIR='$$(TOPDIR)'/share/zoneinfo \
	TZDOBJS=zdump.o \
	AR='$(AR)' \
	cc='$(CC)' \
	CFLAGS='$(CFLAGS) -DHAVE_GETTEXT=1 -DHAVE_UTMPX_H=1 -DTHREAD_SAFE=1 -DUSE_LTZ=0' \
	KSHELL='$(BASH)' \
	LDFLAGS='$(LDFLAGS)' \
	RANLIB='$(RANLIB)' \
	$(and $(filter-out $(host),$(build)),zic=./zic.build)

$(prepare-rule):
	$(call apply,build-fixes)

$(build-rule):
ifneq ($(host),$(build))
	$(MAKE) -C $(builddir) clean
	$(MAKE) -C $(builddir) zic $(configuration) AR=gcc-ar cc=gcc CFLAGS='$(CFLAGS_FOR_BUILD)' LDFLAGS='$(LDFLAGS_FOR_BUILD)' RANLIB=gcc-ranlib
	$(MOVE) $(builddir)/zic $(builddir)/zic.build
	$(MAKE) -C $(builddir) clean
endif
	$(MAKE) -C $(builddir) ALL $(configuration)

$(install-rule): $$(call installed,glibc)
# The INSTALL target includes a conflicting date command.
	$(MAKE) -C $(builddir) install $(configuration)
