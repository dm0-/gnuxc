lzip                    := lzip-1.19
lzip_sha1               := 6a64443e3e310c0c28ca6579aeea7a38ef7ab7e1
lzip_url                := http://download.savannah.gnu.org/releases/lzip/$(lzip).tar.lz

$(configure-rule):
	cd $(builddir) && ./$(configure) \
		CXX='$(CXX)' \
		CPPFLAGS='$(CPPFLAGS)' \
		CXXFLAGS='$(CXXFLAGS)' \
		LDFLAGS='$(LDFLAGS)'

$(build-rule):
	$(MAKE) -C $(builddir) all

$(install-rule): $$(call installed,gcc)
	$(MAKE) -C $(builddir) install
