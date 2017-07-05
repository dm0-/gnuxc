#!/usr/bin/make -f
define UNUSED_CHUNK_SWITCHING_GUILE_BLOCK_COMMENTS_TO_CONFORM_TO_BEST_PRACTICES
!#
#|
endef

# Copyright (C) 2014,2015,2016,2017 David Michael <fedora.dm0@gmail.com>
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

override define CHUNK_O_GUILE
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


;;; Define the empty maps and lists that will be populated by spec file data.

;; Map a spec file name to the file name of the SRPM it creates.
(define spec-to-srpm (make-hash-table))

;; Map a package name to the file name of the SRPM that creates it.
(define name-to-srpm (make-hash-table))

;; Map a spec file name to the list of its build requirements.
(define spec-to-reqs (make-hash-table))

;; List the spec files that can be built while bootstrapping the system.
(define bootstrap-package-specs '())

;; List the spec files to rebuild after bootstrapping (a subset of the above).
(define rebuild-package-specs '())


;;; Define the heavy lifters for building a Make rule from a spec file.

;; Given a spec file name, add its information to the lists and mappings.  The
;; second parameter is a boolean specifying if the spec should be processed as
;; if the complete environment is available (i.e. not in bootstrapping mode).
(define (process-spec spec env)
  (let
    ((srpm #f) (name #f) (version #f) (release #f) (reqs '()) (i #f) (j #f)
      (bootstrap-package #t) (build-twice #f)
      (port
        (open-pipe* OPEN_READ "/usr/bin/rpmspec" "--parse"
          (string-append ; Pretend the RPM macros file was installed.
            "--define=gnuxc_package_header "
            "%{?!bootstrap:BuildRequires:  gnuxc(bootstrapped)}")
          (string-append "--define=_" (if env "without" "with") "_bootstrap 1")
          (string-append specdir "/" spec))))
    (do ((line (read-line port) (read-line port))) ((eof-object? line))
      (cond
        ((string-prefix? "Name:           " line)
          (unless name (set! name (substring line 16))))
        ((string-prefix? "Version:        " line)
          (unless version (set! version (substring line 16))))
        ((string-prefix? "Release:        " line)
          (unless release (set! release (substring line 16))))
        ((or
            (string-prefix? "BuildRequires:  gnuxc(bootstrapped)" line)
            (string-prefix? "BuildRequires:  gnuxc-gcc-c++" line))
          (set! bootstrap-package #f)
          (set! reqs (cons "gnuxc-gcc-c++" reqs)))
        ((string-prefix? "BuildRequires:  gnuxc-" line)
          (set! i (string-index line #\  16))
          (if i
            (set! reqs (cons (substring line 16 i) reqs))
            (set! reqs (cons (substring line 16) reqs))))
        ((string-prefix? "Provides:       gnuxc-bootstrap(" line)
          (set! build-twice #t))
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
    (when bootstrap-package
      (set! bootstrap-package-specs (cons spec bootstrap-package-specs))
      (if build-twice
        (set! rebuild-package-specs (cons spec rebuild-package-specs))))
    (hash-set! spec-to-srpm spec srpm)
    (hash-set! spec-to-reqs spec reqs))
  #f)

;; Given a spec file name, return a Make rule to build its SRPM.  For brevity,
;; the SRPM's prerequisites are other SRPMs.  This satisfies build requirements
;; since the actual RPMs are produced by the same command as the SRPMs.
(define (srpm-rule-from-spec spec)
  (string-append
    (hash-ref spec-to-srpm spec) ": " spec
    (string-join
      (map (lambda (x) (hash-ref name-to-srpm x)) (hash-ref spec-to-reqs spec))
      " " 'prefix)
    "\n"))


;;; Generate the full SRPM dependency tree.
;;;
;;; Since the files in the specs directory are in no particular order, they are
;;; all parsed to configure mappings that can later be used to resolve an
;;; ordered dependency tree.
;;;
;;; When the spec files are parsed, they are forced to use a bootstrapping
;;; configuration.  Most of the packages don't have a bootstrapping version, so
;;; they'll ignore this.  The rest are added to a list of packages needed for
;;; bootstrapping the environment, and they get handled first.
;;;
;;; After the list of bootstrapping package rules are generated, their spec
;;; files are processed again using a complete environment configuration.  This
;;; updates the mappings to use their full version numbers and dependencies, so
;;; the entire dependency tree can be generated.

;; Populate all the package mappings and lists using every relevant spec file.
(let ((dir (opendir specdir)))
  (do ((spec (readdir dir) (readdir dir))) ((eof-object? spec))
    (when (and (string-prefix? "gnuxc-" spec) (string-suffix? ".spec" spec))
      (process-spec spec #f)))
  (closedir dir))

;; Begin writing rules, starting with the packages built during bootstrapping.
(define cookbook
  (string-append
    "# Define rules for packages to be built during bootstrapping.\n"
    (string-concatenate (map srpm-rule-from-spec bootstrap-package-specs))
    (string-join
      (map (lambda (x) (hash-ref spec-to-srpm x)) bootstrap-package-specs)
      " ")
    ": private override bootstrap := 1\n\n"))

;; With bootstrapping done, write rules for the specs that need to be rebuilt.
(set! cookbook
  (string-append
    cookbook
    "# Define the full set of package rules.\n"
    (string-concatenate
      (map-in-order
        (lambda (x) (process-spec x #t) (srpm-rule-from-spec x))
        (sort! ; GCC must be reprocessed first.
          rebuild-package-specs
          (lambda (x y) (string=? x "gnuxc-gcc.spec")))))))

;; Write all of the post-bootstrap package rules.
(set! cookbook
  (hash-fold
    (lambda (spec srpm rules)
      (if (member spec bootstrap-package-specs)
        rules ; Don't add duplicate rules for bootstrapping packages.
        (string-append rules (srpm-rule-from-spec spec))))
    cookbook
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

# Tack a local repository definition onto the DNF configuration.
repo_name := gnuxc-local
dnf_opts := --repofrompath='$(repo_name),$(rpmdir)' \
--enablerepo='$(repo_name)' \
--setopt='$(repo_name).name=gnuxc - Locally built cross-compiler packages' \
--setopt='$(repo_name).includepkgs=gnuxc-*' \
--setopt='$(repo_name).gpgcheck=0' \
--setopt='$(repo_name).metadata_expire=0'

# Delete this definition when DNF works correctly (see above).
dnf_opts := --config=/dev/stdin --enablerepo='$(repo_name)' \
<<< \"`cat /etc/dnf/dnf.conf ; echo '[$(repo_name)]' ; \
echo 'name=gnuxc - Locally built cross-compiler packages' ; \
echo 'baseurl=file://$(rpmdir)' ; echo 'includepkgs=gnuxc-*' ; \
echo gpgcheck=0 ; echo metadata_expire=0`\"

# Define common command options.
dnf-builddep := sudo dnf $(dnf_opts) -y builddep
dnf-install := sudo dnf --disablerepo='*' $(dnf_opts) -y install
createrepo := createrepo_c --no-database --simple-md-filenames

# Provide a default target to install everything needed to build the OS.
install: all
	$(createrepo) '$(rpmdir)'
	$(dnf-install) \
'gnuxc-*-devel' gnuxc-gcc-{gfortran,objc++} gnuxc-mig gnuxc-pkg-config \
'gnuxc-*proto' gnuxc-{libpthread-stubs,spice-protocol,xorg-server,xtrans} \
gnuxc-{bzip2,glibc,libuuid,parted,zlib}-static

# Also provide an easily typed target that only installs the complete GCC.
bootstrap: " (hash-ref name-to-srpm "gnuxc-gcc-c++") "
	$(createrepo) '$(rpmdir)'
	$(dnf-install) gnuxc-gcc-c++

# Work around broken DNF.
override lock = \
until test \"`head -1 '$(rpmdir)/repodata/$1.lock' 2>/dev/null`\" = '$@' ; do \
while test -e '$(rpmdir)/repodata/$1.lock' ; do \
echo 'Waiting for $1 lock in order to make $@ ...' ; sleep 1 ; done ; \
echo '$@' > '$(rpmdir)/repodata/$1.lock' ; sleep 0.1 ; done
override unlock = rm --force '$(rpmdir)/repodata/$1.lock'

# This is the rule that builds every package below.
%.src.rpm: private override bs = \
--define='_$(if $(bootstrap),with,without)_bootstrap 1'
%.src.rpm: private override bootstrap :=
%.src.rpm: private override repomd = $(rpmdir)/repodata/$(basename $(<F))
%.src.rpm:
	-mkdir --parents '$(repomd)' && \
$(createrepo) \
--baseurl='file://$(rpmdir)' --outputdir='$(repomd)' '$(rpmdir)' && \
$(call lock,builddep) ; \
$(dnf-builddep) $(bs) --setopt='$(repo_name).baseurl=file://$(repomd)' '$<' ; \
$(call unlock,builddep) ; \
rm --force --recursive '$(repomd)'
	+rpmbuild --clean -ba '$<' $(bs) \
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
