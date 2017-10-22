;; vim: set sts=2 sw=2 et lisp sm syntax= :

(load "utils.scm")

;; Constants
(define pi 3.141592653589793238462643383279502884197169399) ; that'll be enough
(define logical-width  320)
(define logical-height 200)

(define al-display #f)
(define main-thread #f)

(define inputs-new '())
(define inputs-old '())
(define input-mouse-x 160)
(define input-mouse-y 100)

;; Runtime stuff
(define player-x 160)
(define player-y 100)
(define particle-list    '())
(define particle-kd-tree '(empty))
(define mob-list         '())
(define mob-kd-tree      '(empty))
(define camera-x 0)
(define camera-y 0)
(define pause-enabled-flag #f)

;; Config
(define display-width   960)
(define display-height  600)
