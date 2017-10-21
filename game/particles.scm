;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define (add-particle! particle)
  (set! particle-list
    (cons particle particle-list)))

(define (add-basic-particle!
          timeout
          x y radius color
          dx dy)
  (add-particle!
    `(basic ,timeout
            ,x ,y ,radius ,color
            ,dx ,dy)))


(define (tick-basic-particle!
          args
          x y radius color dx dy)
  (set-car!      args  (+ x dx))
  (set-car! (cdr args) (+ y dy))
  (cond ((world-point-is-solid-for-particles x y) #f)
        (else args)))


(define (tick-particle! particle)
  (let ((type       (car  particle))
        (timeout    (cadr particle))
        (args       (cddr particle)))
    (begin
      ;; Advance timeout
      (set!     timeout        (- timeout 1))
      (set-car! (cdr particle)    timeout)
      (cond ((< timeout 0) #f)
            ((eq? type 'basic)
             (begin
               (set! args
                 (apply tick-basic-particle!
                      (cons args args)))
               (if args
                 (begin
                   (set-cdr! (cdr particle) args)
                   particle)
                 #f)))
            (else
              (error
                (string-append
                  "invalid particle type: "
                  (->string type))))))))


(define (tick-particles!)
  (set! particle-list
    (let loop ((p particle-list))
      (if (null? p)
        '()
        (let ((result (tick-particle! (car p))))
          (if result
            (cons result (loop (cdr p)))
            (loop (cdr p))))))))


(define (draw-particle x y radius color . extra)
  (al:draw-circle/fill
    x y radius color))

(define (draw-particles)
  (do ((p particle-list (cdr p)))
    ((null? p))
    (apply draw-particle (cddr (car p)))))

