%bcond_without debug

%?gnuxc_package_header
%global debug_package %{nil}

%global rustlibdir %{_prefix}/lib/rustlib

%global __elf_exclude_path ^%{rustlibdir}/%{gnuxc_target}/
%global __libsymlink_exclude_path ^%{rustlibdir}/%{gnuxc_target}/

Name:           gnuxc-rust
Version:        1.22.1
Release:        1%{?dist}
Summary:        Cross-compiler version of %{gnuxc_name} for the GNU system

License:        (ASL 2.0 or MIT) and (BSD and ISC and MIT)
URL:            http://www.rust-lang.org/
Source0:        http://static.rust-lang.org/dist/rustc-%{version}-src.tar.gz

Patch101:       %{gnuxc_name}-%{version}-hurd-port.patch

BuildRequires:  cargo
BuildRequires:  rust = %{version}

%description
%{summary}.

%package std-static
Summary:        Cross-compiled base libraries needed for building Rust projects
Requires:       rust = %{version}

%description std-static
%{summary}.


%prep
%autosetup -n rustc-%{version}-src -p0

# Generate a target JSON file based on the closest built-in Linux target.
RUSTC_BOOTSTRAP=1 rustc -Z unstable-options \
    --print=target-spec-json \
    --target=%{gnuxc_arch}-unknown-linux-gnu |
sed > %{gnuxc_target}.json \
    -e 's/unknown/%{gnuxc_vendor}/' \
    -e 's/linux\(-gnu\)\?/%{gnuxc_os}/' \
    -e '/is-builtin/d'

# Configure cargo to find the vendored crates and cross-compiler programs.
cat << EOF > config
[source.vendor]
directory = "$PWD/src/vendor"
[source.crates-io]
replace-with = "vendor"
local-registry = "/nonexistent"
[target.%{gnuxc_target}]
ar = "%{gnuxc_ar}"
linker = "%{gnuxc_cc}"
EOF

%build
%gnuxc_env
export CARGO_HOME=$PWD
export CARGO_TARGET_DIR=$PWD/target
export RUST_TARGET_PATH=$PWD
export RUSTC_BOOTSTRAP=1
export RUSTFLAGS="\
-L $PWD/target/%{gnuxc_target}/release/deps \
-Z force-unstable-if-unmarked"

cargo build --target=%{gnuxc_target} -v \
    --manifest-path src/libstd/Cargo.toml -p std \
%if %{with debug}
    --lib --features panic-unwind
%else
    --lib --release --features panic-unwind
%endif

%install
install -dm 0755 %{buildroot}%{rustlibdir}/%{gnuxc_target}
install -pm 0644 %{gnuxc_target}.json \
    %{buildroot}%{rustlibdir}/%{gnuxc_target}/%{gnuxc_target}.json

install -dm 0755 %{buildroot}%{rustlibdir}/%{gnuxc_target}/lib
install -pm 0644 -t %{buildroot}%{rustlibdir}/%{gnuxc_target}/lib \
%if %{with debug}
    target/%{gnuxc_target}/debug/deps/*.rlib
%else
    target/%{gnuxc_target}/release/deps/*.rlib
%endif


%files std-static
%{rustlibdir}/%{gnuxc_target}
%doc CONTRIBUTING.md README.md RELEASES.md
%license COPYRIGHT LICENSE-APACHE LICENSE-MIT
