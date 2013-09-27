sed                     := sed-4.2.2
sed_url                 := http://ftp.gnu.org/gnu/sed/$(sed).tar.bz2

export SED = /bin/sed

configure-sed-rule:
	cd $(sed) && ./$(configure) \
		--exec-prefix= \
		\
		--disable-rpath \
		--without-included-regex \
		--without-selinux

build-sed-rule:
	$(MAKE) -C $(sed) all \
		CPPFLAGS=-DPATH_MAX=4096

install-sed-rule: $(call installed,glibc)
	$(MAKE) -C $(sed) install
