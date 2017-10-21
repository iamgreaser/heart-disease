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


(define (tick-world-cell! cx cy)
  (let* ((cell (world-grid-ref cx cy)))
    (case cell
      ((2) ; Heart
       (when (= (random 5) 0)
         (begin
           (add-basic-env-particle!
             20
             (+ (* cx 16) 8)
             (+ (* cy 16) 8)
             (+ 3 (random 3))
             (rgba->color 255 128 128 128)
             (* 1 1/50 (- (random 101) 50))
             (* 1 1/50 (- (random 101) 50)))
           ;
           )))
       (else #f))))

(define (tick-world!)
  (let loop ((x 0)
             (y 0))
    (cond ((>= y world-height) #f)
          ((>= x world-width)
           (loop 0 (+ y 1)))
          (else
            (tick-world-cell! x y)
            (loop (+ x 1) y)))))

(define (collide-with-world
          old-x old-y
          new-x new-y
          bx-min by-min
          bx-max by-max)

  ;; Do each side first
  (let* ((old-cx-med (floor-quotient old-x 16))
         (old-cy-med (floor-quotient old-y 16))
         (old-cx-min (floor-quotient (+ old-x bx-min) 16))
         (old-cy-min (floor-quotient (+ old-y by-min) 16))
         (old-cx-max (floor-quotient (+ old-x bx-max) 16))
         (old-cy-max (floor-quotient (+ old-y by-max) 16))
         (new-cx-min (floor-quotient (+ new-x bx-min) 16))
         (new-cy-min (floor-quotient (+ new-y by-min) 16))
         (new-cx-max (floor-quotient (+ new-x bx-max) 16))
         (new-cy-max (floor-quotient (+ new-y by-max) 16)))

    ;; Skip if the cells are the same
    (unless (and (= old-cx-min new-cx-min)
                 (= old-cy-min new-cy-min)
                 (= old-cx-max new-cx-max)
                 (= old-cy-max new-cy-max))
      ;; Check the whole box
      ;; Do X and Y separately first
      ;; FIXME: needs a raycast
      (let loop ((cx new-cx-min)
                 (cy old-cy-min))
        (cond ((> cy old-cy-max) #f)
              ((> cx new-cx-max)
               (loop new-cx-min (+ cy 1)))
              ((and (>= cx old-cx-min)
                    (>= cy old-cy-min)
                    (<= cx old-cx-max)
                    (<= cy old-cy-max))
               (loop (+ cx 1) cy))
              ((world-cell-is-solid-for-player cx cy)
               (set! new-x
                 (cond ((> cx old-cx-med) (+ (* cx 16) -8))
                       ((< cx old-cx-med) (+ (* cx 16)  23))
                       (else new-x)))
               (loop (+ cx 1) cy))
              (else
                (loop (+ cx 1) cy))))
      (let loop ((cx old-cx-min)
                 (cy new-cy-min))
        (cond ((> cy new-cy-max) #f)
              ((> cx old-cx-max)
               (loop old-cx-min (+ cy 1)))
              ((and (>= cx old-cx-min)
                    (>= cy old-cy-min)
                    (<= cx old-cx-max)
                    (<= cy old-cy-max))
               (loop (+ cx 1) cy))
              ((world-cell-is-solid-for-player cx cy)
               (set! new-y
                 (cond ((> cy old-cy-med) (+ (* cy 16) -8))
                       ((< cy old-cy-med) (+ (* cy 16)  23))
                       (else new-y)))
               (loop (+ cx 1) cy))
              (else
                (loop (+ cx 1) cy)))))

    ;; Now do diagonals
    (unless (and (= old-cx-min new-cx-min)
                 (= old-cy-min new-cy-min)
                 (= old-cx-max new-cx-max)
                 (= old-cy-max new-cy-max))
      (set! new-cx-min (floor-quotient (+ new-x bx-min) 16))
      (set! new-cy-min (floor-quotient (+ new-y by-min) 16))
      (set! new-cx-max (floor-quotient (+ new-x bx-max) 16))
      (set! new-cy-max (floor-quotient (+ new-y by-max) 16))
      (let loop ((cx new-cx-min)
                 (cy new-cy-min))
        (cond ((> cy new-cy-max) #f)
              ((> cx new-cx-max)
               (loop new-cx-min (+ cy 1)))
              ((and (>= cx old-cx-min)
                    (>= cy old-cy-min)
                    (<= cx old-cx-max)
                    (<= cy old-cy-max))
               (loop (+ cx 1) cy))
              ((world-cell-is-solid-for-player cx cy)
               (set! new-x
                 (cond ((> cx old-cx-med) (+ (* cx 16) -8))
                       ((< cx old-cx-med) (+ (* cx 16)  23))
                       (else new-x)))
               (set! new-y
                 (cond ((> cy old-cy-med) (+ (* cy 16) -8))
                       ((< cy old-cy-med) (+ (* cy 16)  23))
                       (else new-y)))
               (loop (+ cx 1) cy))
              (else
                (loop (+ cx 1) cy)))))
    (values new-x new-y)))

