#!/usr/bin/make -f
define UNUSED_CHUNK_SWITCHING_GUILE_BLOCK_COMMENTS_TO_CONFORM_TO_BEST_PRACTICES
!#
#|
endef

# Copyright (C) 2014 David Michael <fedora.dm0@gmail.com>
#
# This file is part of gnuxc.
#
# gnuxc is free software: you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# gnuxc is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along with
# gnuxc.  If not, see <http://www.gnu.org/licenses/>.

define CHUNK_O_GUILE
|#

;;; This script converts RPM spec build requirements into Make prerequisites to
;;; automatically build every package in a valid order.  When using parallel
;;; jobs to build multiple packages simultaneously, the job server is shared
;;; with every Make command in RPM build scripts to maximize CPU cores' usage.

;; Import open-pipe and read-line for RPM command interaction.
(use-modules (ice-9 popen))
(use-modules (ice-9 rdelim))

;; Return the output string obtained by RPM evaluating the input string.
(define (rpm-eval string)
  (let ((line "") (port (open-pipe* OPEN_READ "/usr/bin/rpm" "-E" string)))
    (set! line (read-line port))
    (close-pipe port)
    line))

;; Determine the directory to search for spec files.
(define specdir (rpm-eval "%_specdir"))

;; Map a spec file name to the file name of the SRPM it creates.
(define spec-to-srpm (make-hash-table 1000))

;; Map a package name to the file name of the SRPM that creates it.
(define name-to-srpm (make-hash-table 1000))

;; Map a spec file name to the list of its build requirements.
(define spec-to-reqs (make-hash-table 1000))


;;; Define the heavy lifters for building a Make rule from a spec file.
;;;
;;; This is somewhat fragile in that it manually reads values from parsed spec
;;; file lines.  It is done this way since it only needs to parse all the spec
;;; files once.  Maybe it's worth using `rpmspec --rpms --qf '%{N}' $spec` and
;;; `rpmspec --srpm --qf '%{N}-%{V}-%{R}.src.rpm\n[%{REQUIRES}\n]' $spec` to
;;; get subpackages, SRPMs, and build requirements more robustly (and slowly).

;; Populate the above mappings with information from the given spec file.
(define (process-spec spec env)
  (let
    ((srpm #f) (name #f) (version #f) (release #f) (reqs '()) (i #f) (j #f)
      (port
        (open-pipe* OPEN_READ "/usr/bin/rpmspec" "--parse"
          (string-append "--define=gnuxc_bootstrapped " (if env "1" "0"))
          (string-append specdir "/" spec))))
    ;; Explicitly require a complete GCC RPM to satisfy gnuxc(bootstrapped).
    (if (and env (not (string=? spec "gnuxc-gcc.spec")))
      (set! reqs '("gnuxc-gcc-c++")))
    (do ((line (read-line port) (read-line port))) ((eof-object? line))
      (cond
        ((string-prefix? "Name:           " line)
          (unless name (set! name (substring line 16))))
        ((string-prefix? "Version:        " line)
          (unless version (set! version (substring line 16))))
        ((string-prefix? "Release:        " line)
          (unless release (set! release (substring line 16))))
        ((string-prefix? "BuildRequires:  gnuxc-" line)
          (set! i (string-index line #\  16))
          (if i
            (set! reqs (cons (substring line 16 i) reqs))
            (set! reqs (cons (substring line 16) reqs))))
        ((string-prefix? "Provides:       gnuxc-" line)
          (set! i (string-index line #\  16))
          (if i
            (hash-set! name-to-srpm (substring line 16 i) srpm)
            (hash-set! name-to-srpm (substring line 16) srpm)))
        ((or (string=? line "%files") (string-prefix? "%files " line))
          ;; Remove " -f fileslist" from the %files line.
          (set! i (string-contains line " -f "))
          (when i (set! j (string-index line #\  (+ i 4)))
            (set! line
              (if j (string-replace line "" i j) (string-replace line "" i))))
          ;; Construct subpackage names for each theoretically possible case.
          (cond
            ((string-prefix? "%files -n " line)
              (hash-set! name-to-srpm (substring line 10) srpm))
            ((string-prefix? "%files " line)
              (hash-set! name-to-srpm
                (string-append name "-" (substring line 7)) srpm))
            ((string=? line "%files")
              (hash-set! name-to-srpm name srpm)))))
      (if (and (not srpm) name version release)
        (set! srpm (string-append name "-" version "-" release ".src.rpm"))))
    (close-pipe port)
    (hash-set! spec-to-srpm spec srpm)
    (hash-set! spec-to-reqs spec reqs))
  #f)

;; For the given spec file, return a rule to make its SRPM from the maps above.
(define (srpm-rule-from-spec spec)
  (string-append (hash-ref spec-to-srpm spec) ": " spec
    ;; The prerequisites are SRPMs, since the SRPM and RPMs are built together.
    (string-join
      (map (lambda (x) (hash-ref name-to-srpm x)) (hash-ref spec-to-reqs spec))
      " " 'prefix)
    "\n"))


;;; Generate the full SRPM dependency tree.
;;;
;;; Since the spec files are unordered, they are all processed to populate the
;;; mappings defined above so that build requirements can be resolved to SRPM
;;; file names.  Then, it maps the list of specs to Make rules.
;;;
;;; Bootstrap packages are handled first to provide a complete compiler for
;;; everything else.  They are then removed from the full package list.  Some
;;; of these packages use an environment variable to select build settings.

;; These packages must be built and installed first.
(define bootstrap
  '("filesystem" "pkg-config" "binutils" "gcc" "gnumach" "mig" "hurd" "glibc"))

;; This subset of the above packages needs to be rebuilt after bootstrapping.
(define bootstrap-subpackages '("binutils" "gcc" "hurd"))

;; Write rules for the bootstrap packages.  (Their list is already in order.)
(define cookbook
  (string-append "# Define targets for bootstrapping the environment.\n"
    (string-concatenate
      (map-in-order (lambda (x) (process-spec x #f) (srpm-rule-from-spec x))
        (map (lambda (x) (string-append "gnuxc-" x ".spec")) bootstrap)))))

;; For the packages that are built twice, build the lesser versions first.
(set! cookbook
  (string-append cookbook
    "\n# Force these SRPMs to be built in a bootstrapping configuration.\n"
    (string-join
      (map
        (lambda (x) (hash-ref spec-to-srpm (string-append "gnuxc-" x ".spec")))
        bootstrap-subpackages)
      " ")
    ": export gnuxc_bootstrapped = 0\n"))

;; Process every spec file (excluding bootstrap) as if there is a complete GCC.
(let ((dir (opendir specdir)))
  (do ((spec (readdir dir) (readdir dir))) ((eof-object? spec))
    (when (and (string-prefix? "gnuxc-" spec) (string-suffix? ".spec" spec))
      (unless (member (substring (string-drop-right spec 5) 6) bootstrap)
        (process-spec spec #t))))
  (closedir dir))

;; Write the complete GCC rule, and upgrade from bootstrap to full packages.
(process-spec "gnuxc-gcc.spec" #t)
(set! cookbook
  (string-append cookbook 
    "\n# Make the complete GCC so we can start building everything for real.\n"
    (srpm-rule-from-spec "gnuxc-gcc.spec")))
(map
  (lambda (x) (process-spec (string-append "gnuxc-" x ".spec") #t))
  (delete "gcc" bootstrap-subpackages))

;; For the packages that are built twice, force the complete versions now.
(set! cookbook
  (string-append cookbook
    "\n# Force these SRPMs to be built completely.\n"
    (string-join
      (map
        (lambda (x) (hash-ref spec-to-srpm (string-append "gnuxc-" x ".spec")))
        bootstrap-subpackages)
      " ")
    ": export gnuxc_bootstrapped = 1\n"))

;; Write all post-bootstrap package rules (except GCC, which is already out).
(map (lambda (x) (delete! x bootstrap)) (delete "gcc" bootstrap-subpackages))
(set! cookbook
  (hash-fold
    (lambda (spec srpm rules)
      (if (member (substring (string-drop-right spec 5) 6) bootstrap)
        rules
        (string-append rules (srpm-rule-from-spec spec))))
    (string-append cookbook "\n# Define the real list of packages.\n")
    spec-to-srpm))


;;; Execute or output a regular Make file, depending on the calling program.

((if (defined? 'gmk-eval) gmk-eval display) (string-append "#!/usr/bin/make -f

# Define the RPM build directories as variables for the caller to override.
rpmdir := $(shell rpm -E %_rpmdir)
specdir := " specdir "
srpmdir := $(shell rpm -E %_srcrpmdir)

# Locate prerequisites in the RPM build environment.
vpath %.src.rpm $(srpmdir)
vpath %.spec $(specdir)

# Tack a local repository definition onto the yum configuration.
repo_name := rpmbuild
repo_opts := --config=/dev/stdin --enablerepo='$(repo_name)' \
<<< \"`cat /etc/yum.conf ; echo '[$(repo_name)]' ; \
echo 'name=Local Custom Packages' ; echo 'baseurl=file://$(rpmdir)' ; \
echo gpgcheck=0 ; echo metadata_expire=0`\"

# Define common command options.
sudo := sudo gnuxc_bootstrapped=$$gnuxc_bootstrapped
yum-builddep := $(sudo) yum-builddep $(repo_opts) -y
yum-install := $(sudo) yum --disablerepo='*' $(repo_opts) -y install
createrepo := createrepo --no-database --simple-md-filenames

# Provide a default target to install everything needed to build the OS.
install: all
	$(createrepo) '$(rpmdir)'
	$(yum-install) \
'gnuxc-*-devel' 'gnuxc-*proto' gnuxc-{libpthread-stubs,spice-protocol} \
gnuxc-gcc-{gfortran,objc++} gnuxc-mig gnuxc-pkg-config \
gnuxc-{bzip2,glibc,libuuid,parted,zlib}-static

# Also provide an easily typed target that only installs the complete GCC.
bootstrap: " (hash-ref name-to-srpm "gnuxc-gcc-c++") "
	$(createrepo) '$(rpmdir)'
	$(yum-install) gnuxc-gcc-c++

# This is the rule that builds every package below.
%.src.rpm: repomd = $(rpmdir)/repodata/$(basename $(<F))
%.src.rpm:
	-mkdir --parents '$(repomd)' && \
$(createrepo) --baseurl '$(rpmdir)' --outputdir '$(repomd)' '$(rpmdir)' && \
$(yum-builddep) --setopt='$(repo_name).baseurl=file://$(repomd)' '$<' && \
rm --force --recursive '$(repomd)'
	+rpmbuild --clean -ba '$<' \
--define='_disable_source_fetch 0' \
--define='_smp_mflags -m'

" cookbook "
# Provide a generic target requiring every SRPM to build all packages.
" (hash-fold (lambda (k v l) (string-append l " " v)) "all:" spec-to-srpm) "

# These targets should never be skipped if a like-named file exists.
.PHONY: all bootstrap install"))

#f

#|
endef
specdir := $(shell rpm -E %_specdir)
$(guile #| $(subst %_specdir,$(specdir),$(value CHUNK_O_GUILE)) |#)
# |#
