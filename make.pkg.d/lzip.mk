lzip                    := lzip-1.16
lzip_url                := http://download.savannah.gnu.org/releases/lzip/$(lzip).tar.lz

configure-lzip-rule:
	cd $(lzip) && ./$(configure) \
		CXX='$(CXX)' \
		CPPFLAGS='$(CPPFLAGS)' \
		CXXFLAGS='$(CXXFLAGS)' \
		LDFLAGS='$(LDFLAGS)'

build-lzip-rule:
	$(MAKE) -C $(lzip) all

install-lzip-rule: $(call installed,gcc)
	$(MAKE) -C $(lzip) install
