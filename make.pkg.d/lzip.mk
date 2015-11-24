lzip                    := lzip-1.17
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
