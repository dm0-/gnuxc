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
(start-logging "/var/log/shepherd.log")

;; Load package service definitions.
(if (file-exists? "/etc/shepherd.d/.")
  (let ((pkgdir (opendir "/etc/shepherd.d")))
    (do ((file (readdir pkgdir) (readdir pkgdir))) ((eof-object? file))
      (if (string-suffix? ".scm" file)
        (catch #t
          (lambda ()
            (register-services (load (string-append "/etc/shepherd.d/" file))))
          (lambda (key . args)
            (display (string-append "Bad service file: " file "\n"))))))
    (closedir pkgdir)))

;; Pretend to support boot-time runlevels, and start the desired services.
(define default-runlevel 3)
(for-each start
  (case
    (string->number
      (car
        (last-pair
          (filter
            (lambda (x) (member x '("1" "2" "3" "4" "5" "6")))
            (cons (number->string default-runlevel) boot-cmdline)))))
    ((1 2) '(runttys swap))
    ((3 4) '(console swap))
    ((5)   '(xdm     swap))
    ((6)   (reboot))
    (else  (display "Could not determine runlevel\n") (go-to-shell))))
