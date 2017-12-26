lzip                    := lzip-1.19
lzip_key                := 1D41C14B272A2219A739FA4F8FE99503132D7742
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
