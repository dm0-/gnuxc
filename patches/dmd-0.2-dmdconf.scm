;; This procedure gives the user a shell when we need to abort.
(define (go-to-shell)
  (execle "/bin/bash" '("TERM=mach-gnu-color") "-bash"))

;; Read bootloader command line arguments into a list.
(unless (file-exists? "/proc/cmdline") (go-to-shell))
(use-modules (ice-9 rdelim))
(define boot-cmdline
  (string-tokenize (call-with-input-file "/proc/cmdline" read-line)))

;; For single-user mode, replace this process with a shell immediately.
(when (member "-s" boot-cmdline)
  (display "Single-user mode requested; dropping to a shell prompt\n")
  (go-to-shell))

;; Begin regular system initialization.
(use-modules (dmd comm) (dmd system))
(system* "/sbin/tmpfiles" "--boot")
(if (member "-f" boot-cmdline)
  (display "Fast boot requested; skipping file system checks\n")
  (case (status:exit-val (system* "/sbin/fsck" "--preen" "--writable"))
    ((0 1) #f) ; Success, or modified with no action necessary
    ((2 3)        (display "File system restart is required\n") (reboot))
    ((4 5 8 9)    (display "File system could not be fixed\n") (go-to-shell))
    ((12)         (display "Interrupted fsck, completed\n")    (go-to-shell))
    ((20 130 131) (display "Interrupted fsck, aborted\n")      (go-to-shell))
    (else         (display "Unknown fsck status\n")            (go-to-shell))))
(start-logging "/var/log/dmd.log")

;; Load package service definitions.
(if (file-exists? "/etc/dmd.d/.")
  (let ((pkgdir (opendir "/etc/dmd.d")))
    (do ((entry (readdir pkgdir) (readdir pkgdir))) ((eof-object? entry))
      (if (string-suffix? ".scm" entry)
        (register-services (load (string-append "/etc/dmd.d/" entry)))))
    (closedir pkgdir)))

;; Start the desired services.
(for-each start '(console swap))
