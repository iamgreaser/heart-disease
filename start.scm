;; vim: set sts=2 sw=2 et lisp sm syntax= :

(use srfi-1)  ; Extended list functions
(use srfi-4)  ; Foreign pointers
(use srfi-12) ; Exceptions
(use srfi-18) ; Threading
(use lolevel) ; HERE BE DRAGONS

;; Initialise Allegro
(use (prefix allegro al:))
(use extras)
(al:init)
(al:image-addon-install)
(al:keyboard-addon-install)
(al:mouse-addon-install)
(al:audio-addon-install)
(al:reserve-samples 16)

;; Set up reloader functions
(define (!!)
  (load "loadall.scm"))

(define (__)
  (load "deinit.scm")
  (load "init.scm")
  (load "loadall.scm"))

;; Get it started
(load "init.scm")
(load "loadall.scm")

