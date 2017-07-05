(define default-runlevel 3)

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

;; Reconnect to the console if its ports were lost.
(sigaction SIGLOST
  (lambda (sig)
    (let ((console (open-fdes "/dev/console" O_WRONLY)))
      (dup2 1 console)
      (dup2 2 console))))

;; Begin regular system initialization.
(use-modules (shepherd comm) (shepherd system))
(umask #o0022)
(system* "/sbin/tmpfiles" "--boot" "--create" "--remove")
(if (member "-f" boot-cmdline)
  (display "Fast boot requested; skipping file system checks\n")
  (case (status:exit-val (system* "/sbin/fsck" "--preen" "--writable"))
    ((0 1) #f) ; Success, or modified with no action necessary
    ((2 3)        (display "File system restart is required\n") (reboot))
    ((4 5 8 9)    (display "File system could not be fixed\n") (go-to-shell))
    ((12)         (display "Interrupted fsck, completed\n")    (go-to-shell))
    ((20 130 131) (display "Interrupted fsck, aborted\n")      (go-to-shell))
    (else         (display "Unknown fsck status\n")            (go-to-shell))))
(start-logging "/var/log/shepherd.log")

;; Load package service definitions.
(if (file-exists? "/etc/shepherd.d/.")
  (let ((pkgdir (opendir "/etc/shepherd.d")))
    (do ((file (readdir pkgdir) (readdir pkgdir))) ((eof-object? file))
      (if (and (string-suffix? ".scm" file) (> (string-length file) 4))
        (catch #t
          (lambda ()
            (register-services (load (string-append "/etc/shepherd.d/" file))))
          (lambda (key . args)
            (display (string-append "Bad service file: " file "\n"))))))
    (closedir pkgdir)))

;; Read a list of service symbols to start from file names in a directory.
(define (dir-scm-symbols path)
  (if (file-exists? (string-append path "/."))
    (let ((rcdir (opendir path)) (symbols '()))
      (do ((file (readdir rcdir) (readdir rcdir))) ((eof-object? file))
        (if (and (string-suffix? ".scm" file) (> (string-length file) 4))
          (set! symbols
            (cons (string->symbol (string-drop-right file 4)) symbols))))
      (closedir rcdir)
      symbols)
    '()))

;; Pretend to support boot-time runlevels, and start the desired services.
(for-each start
  (case
    (string->number
      (car
        (last-pair
          (filter
            (lambda (x) (member x '("0" "1" "2" "3" "4" "5" "6")))
            (cons (number->string default-runlevel) boot-cmdline)))))
    ((0) (power-off))
    ((1) (cons 'runttys (dir-scm-symbols "/etc/rc1.d")))
    ((2) (cons 'runttys (dir-scm-symbols "/etc/rc2.d")))
    ((3) (cons 'console (dir-scm-symbols "/etc/rc3.d")))
    ((4) (cons 'console (dir-scm-symbols "/etc/rc4.d")))
    ((5) (cons 'xdm     (dir-scm-symbols "/etc/rc5.d")))
    ((6) (reboot))
    (else (display "Could not determine runlevel\n") (go-to-shell))))
