;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define color-world-wall-1 (al:make-color-rgb 170 170 170))

(define world-width  20)
(define world-height 12)
(define world-grid
  '#(#( 0 0 0 0 1 1 1 1 1 0 0 1 1 1 0 0 0 0 0 0)
     #( 0 0 0 0 1 1 1 1 1 0 0 1 1 1 0 0 0 0 0 0)
     #( 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0)
     #( 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 0 0 0 0 2 2 0 0 0 0 0 0 0 0 0 0)
     #( 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0)
     #( 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 1 0 0 0 0)
     #( 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0)
     #( 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0)
     ))

(define (world-grid-ref x y)
  (cond ((<  x 0) 1)
        ((<  y 0) 1)
        ((>= x world-width ) 1)
        ((>= y world-height) 1)
        (else
          (vector-ref
            (vector-ref world-grid y)
            x))))

(define (world-cell-is-solid-for-player cx cy)
  (case (world-grid-ref cx cy)
    ((0 2) #f)
    (else #t)))

(define (world-point-is-solid-for-particles x y)
  (case (world-grid-ref (floor-quotient (->int x) 16)
                        (floor-quotient (->int y) 16))
    ((0) #f)
    (else #t)))

(define (draw-world-cell cx cy)
  (let ((x (* cx 16))
        (y (* cy 16)))
    ;
    (case (world-grid-ref cx cy)
      ((0) #f)
      ((1) (al:draw-rectangle/fill
             (+ x  0) (+ y  0)
             (+ x 16) (+ y 16)
             color-world-wall-1)
           (al:draw-rectangle
             (+ x  0) (+ y  0)
             (+ x 16) (+ y 16)
             color-black
             2.0))
      ((2) (draw-heart (+ x 8)
                       (+ y 8)
                       8))
      (else
        (al:draw-rectangle/fill
          (+ x  0) (+ y  0)
          (+ x 16) (+ y 16)
          color-black)
        (al:draw-rectangle/fill
          (+ x  0) (+ y  0)
          (+ x  8) (+ y  8)
          color-magic-pink)
        (al:draw-rectangle/fill
          (+ x  8) (+ y  8)
          (+ x 16) (+ y 16)
          color-magic-pink)
        ))))

(define (draw-world)
  (let loop ((x 0)
             (y 0))
    (cond ((>= y world-height) #f)
          ((>= x world-width)
           (loop 0 (+ y 1)))
          (else
            (draw-world-cell x y)
            (loop (+ x 1) y)))))

