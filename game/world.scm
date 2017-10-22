;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define color-world-wall-1 (al:make-color-rgb 170 170 170))

(define world-grid-template
  '#(#( 0 0 0 2 1 1 1 0 0 0 0 1 1 1 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 1 1 1 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 1 2 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 3 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 3 0 0 0)
     #( 0 0 0 0 0 0 2 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 0 0 0 0 1 0 0 0 0 0 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 1 0 0 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0)
     #( 1 0 3 1 9 9 9 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0)
     #( 1 1 1 1 9 9 1 1 0 0 0 0 0 0 1 1 0 2 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 9 9 9 9 1 3 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 3 0 3 0)
     #( 9 9 1 1 1 1 1 0 0 0 0 0 0 0 1 1 1 1 1 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 9 1 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 3 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 3 3 3 3 3 3 3 3 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     ))

(define (clone-world)
  (let* ((grid (make-vector
                 (vector-length
                   world-grid-template))))
    (do ((y 0 (+ y 1)))
      ((>= y (vector-length grid)) grid)
      (vector-set!
        grid y
        (let* (( in-row (vector-ref
                          world-grid-template
                          y))
               (out-row (make-vector
                          (vector-length
                            in-row))))
          (do ((x 0 (+ x 1)))
            ((>= x (vector-length in-row))
             out-row)
            (vector-set!
              out-row x
              (vector-ref in-row x))))))))

(define world-grid (clone-world))

(define (new-game!)
  (set! player-x 160)
  (set! player-y  10)
  (set! particle-list    '())
  (set! particle-kd-tree '(empty))
  (set! mob-list         '())
  (set! mob-kd-tree      '(empty)))

(define world-width
  (apply max
         (map vector-length
              (vector->list world-grid))))
(define world-height
  (vector-length world-grid))

(define (world-grid-ref x y)
  (cond ((<  x 0) 9)
        ((<  y 0) 9)
        ((>= y (vector-length world-grid)) 9)
        (else
          (let ((row (vector-ref world-grid y)))
            (if (>= x (vector-length row))
              9
              (vector-ref row x))))))

(define (world-cell-is-solid-for-player cx cy)
  (case (world-grid-ref cx cy)
    ((0 2 3) #f)
    (else #t)))

(define (world-point-is-solid-for-particles x y)
  (case (world-grid-ref (floor-quotient (->int x) 16)
                        (floor-quotient (->int y) 16))
    ((0 3) #f)
    (else #t)))

(define (draw-world-cell cx cy)
  (let ((x (* cx 16))
        (y (* cy 16)))
    ;
    (case (world-grid-ref cx cy)
      ((0 3) #f)
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
      ((9) (al:draw-rectangle/fill
             (+ x  0) (+ y  0)
             (+ x 16) (+ y 16)
             color-black))
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
  (let* ((visible-x-min (quotient camera-x 16))
         (visible-y-min (quotient camera-y 16))
         (visible-x-max (quotient (+ camera-x -1 logical-width)
                                  16))
         (visible-y-max (quotient (+ camera-y -1 logical-height -8)
                                  16)))
    ;
    (let loop ((x visible-x-min)
               (y visible-y-min))
      (cond ((> y visible-y-max) #f)
            ((> x visible-x-max)
             (loop visible-x-min (+ y 1)))
            (else
              (draw-world-cell x y)
              (loop (+ x 1) y))))))


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
      ((3) ; Enemy spawner
       (when (= (random 10) 0)
         (begin
           (add-enemy-1-mob!
             180
             (+ (* cx 16) 8)
             (+ (* cy 16) 8))
           (do ((i 3 (- i 1)))
             ((<= i 0))
             (add-basic-env-particle!
               20
               (+ (* cx 16) 8)
               (+ (* cy 16) 8)
               (+ 1 (random 2))
               (rgba->color   0 255 255 192)
               (* 2 1/50 (- (random 101) 50))
               (* 2 1/50 (- (random 101) 50))))
           ;
           )))
      (else #f))))

(define (tick-world!)
  (let* ((visible-x-min (quotient camera-x 16))
         (visible-y-min (quotient camera-y 16))
         (visible-x-max (quotient (+ camera-x -1 logical-width)
                                  16))
         (visible-y-max (quotient (+ camera-y -1 logical-height -8)
                                  16)))
    (let loop ((x visible-x-min)
               (y visible-y-min))
      (cond ((> y visible-y-max) #f)
            ((> x visible-x-max)
             (loop visible-x-min (+ y 1)))
            (else
              (tick-world-cell! x y)
              (loop (+ x 1) y))))))

(define (collide-box-with-world
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
                 (cond ((> cx old-cx-med) (+ (* cx 16) -1 bx-min))
                       ((< cx old-cx-med) (+ (* cx 16) 16 bx-max))
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
                 (cond ((> cy old-cy-med) (+ (* cy 16) -1 by-min))
                       ((< cy old-cy-med) (+ (* cy 16) 16 by-max))
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
                 (cond ((> cx old-cx-med) (+ (* cx 16) -1 bx-min))
                       ((< cx old-cx-med) (+ (* cx 16) 16 bx-max))
                       (else new-x)))
               (set! new-y
                 (cond ((> cy old-cy-med) (+ (* cy 16) -1 by-min))
                       ((< cy old-cy-med) (+ (* cy 16) 16 by-max))
                       (else new-y)))
               (loop (+ cx 1) cy))
              (else
                (loop (+ cx 1) cy)))))
    (values new-x new-y)))

