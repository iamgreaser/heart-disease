;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define (->int n)
  (inexact->exact (floor n)))

(define (floor-quotient n d)
  (let ((n (->int n)))
    (quotient (- n (modulo n d)) d)))

(define (ceil-quotient n d)
  (+ (floor/ n d)
     (if (= (modulo n d) 0)
       0
       1)))

