;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define color-world-wall-1 (al:make-color-rgb 170 170 170))

(define world-grid-template
  '#(#( 0 0 0 h 1 1 1 0 0 0 0 1 1 1 h + + + + + e 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 + 1 1 1 0 0 0 0 1 1 1 0 0 0 0 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 + 1 0 0 0 0 0 0 0 0 1 1 1 1 0 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 + 1 0 0 0 0 0 0 0 0 1 1 1 1 0 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 0 0 0 + + + + 0 0 0 0 0 0 0 0 0 0 0 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 1 1 1 1 1 1 + 0 0 0 0 0 0 0 + + + + + 0 0 0 0 0 0 0 0 0 0 0 e 0 0 e 0 0 e 0 0 0)
     #( 0 0 0 0 0 0 + 0 0 0 0 0 0 0 + 1 0 0 + 0 0 0 0 0 0 0 0 0 0 0 + 0 0 + 0 0 + 0 0 0)
     #( 0 0 0 + + + + 0 0 0 0 1 0 0 + 1 0 0 + 0 0 0 0 0 0 0 0 0 0 0 + + h + h + + 0 0 0)
     #( 0 0 0 + 1 1 1 1 0 0 0 0 0 0 + 1 0 0 + 0 0 0 0 0 0 0 0 0 0 0 e + + + + + e 0 0 0)
     #( 0 0 + + + + h 1 0 0 0 0 0 0 + 1 0 0 + 0 0 0 e 0 0 0 0 0 0 0 0 0 h + h 0 0 0 0 0)
     #( 0 0 + 0 0 0 0 1 0 0 0 0 0 0 h 1 0 0 + + + + + 0 0 0 0 0 0 0 0 0 + + + 0 0 0 0 0)
     #( 1 0 + 1 1 1 1 1 0 0 0 0 0 0 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 e + + e + + e 0 0 0)
     #( 1 0 e 1 9 9 9 1 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 1 1 1 1 9 9 1 1 0 0 0 0 0 0 1 1 0 h + + + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 9 9 9 9 1 e 0 0 0 0 0 0 1 1 0 0 0 0 + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 1 1 1 1 + 0 0 0 0 0 0 1 1 1 1 1 1 + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 h + + + + 0 0 0 0 0 0 1 9 9 9 9 1 + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 1 + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 1 + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 9 1 + 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 + 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 e 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 e e e e e e e e 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 + + + + + + + + 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     #( 9 9 1 0 0 0 0 h 0 0 h 0 0 0 0 0 0 1 9 9 9 9 9 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
     ))

(define (create-world)
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

(define (clone-world in-grid)
  (let* ((grid (make-vector
                 (vector-length
                   in-grid))))
    (do ((y 0 (+ y 1)))
      ((>= y (vector-length grid)) grid)
      (vector-set!
        grid y
        (let* (( in-row (vector-ref
                          in-grid
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

(define world-grid      (create-world))
(define world-grid-next (clone-world world-grid))

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


(define (world-grid-swap!)
  (let ((temp world-grid))
    (set! world-grid      world-grid-next)
    (set! world-grid-next temp)))


(define (world-grid-ref x y)
  (cond ((<  x 0) 9)
        ((<  y 0) 9)
        ((>= y (vector-length world-grid)) 9)
        (else
          (let ((row (vector-ref world-grid y)))
            (if (>= x (vector-length row))
              9
              (vector-ref row x))))))

(define (world-grid-set! x y cell)
  (cond ((<  x 0) #f)
        ((<  y 0) #f)
        ((>= y (vector-length world-grid-next)) #f)
        (else
          (let ((row (vector-ref world-grid-next y)))
            (if (>= x (vector-length row))
              #f
              (begin
                (vector-set! row x cell)
                #t))))))

(define (world-cell-is-solid-for-player cx cy)
  (case (world-grid-ref cx cy)
    ((0 h e e+ + +c +t) #f)
    (else #t)))

(define (world-cell-is-charged cx cy)
  (case (world-grid-ref cx cy)
    ((h e+ +c +t) #t)
    (else #f)))

(define (world-cell-is-fully-charged cx cy)
  (case (world-grid-ref cx cy)
    ((h e+ +c) #t)
    (else #f)))

(define (world-cell-has-charged-neighbours cx cy)
  (or (world-cell-is-charged (- cx 1) cy)
      (world-cell-is-charged (+ cx 1) cy)
      (world-cell-is-charged cx (- cy 1))
      (world-cell-is-charged cx (+ cy 1))))

(define (world-cell-has-fully-charged-neighbours cx cy)
  (or (world-cell-is-fully-charged (- cx 1) cy)
      (world-cell-is-fully-charged (+ cx 1) cy)
      (world-cell-is-fully-charged cx (- cy 1))
      (world-cell-is-fully-charged cx (+ cy 1))))

(define (world-cell-is-wireable cx cy)
  (case (world-grid-ref cx cy)
    ((h e e+ + +c +t) #t)
    (else #f)))

(define (world-point-is-solid-for-particles x y)
  (case (world-grid-ref (floor-quotient (->int x) 16)
                        (floor-quotient (->int y) 16))
    ((0 e e+ + +c +t) #f)
    (else #t)))

(define (draw-world-cell cx cy)
  (let ((x    (* cx 16))
        (y    (* cy 16))
        (cell (world-grid-ref cx cy)))
    ;
    (case cell
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
      ((h) (draw-heart (+ x 8)
                       (+ y 8)
                       8))

      ((+ +c +t)
       (let ((color (if (and (eq? '+ cell)
                             (not (world-cell-has-charged-neighbours cx cy)))
                      color-black
                      color-wire-charged)))
         (when (world-cell-is-wireable (- cx 1) cy)
             (al:draw-line
               (+ x  8) (+ y  8)
               (+ x  0) (+ y  8)
               color 2.0))
           (when (world-cell-is-wireable (+ cx 1) cy)
             (al:draw-line
               (+ x  8) (+ y  8)
               (+ x 16) (+ y  8)
               color 2.0))
           (when (world-cell-is-wireable cx (- cy 1))
             (al:draw-line
               (+ x  8) (+ y  8)
               (+ x  8) (+ y  0)
               color 2.0))
           (when (world-cell-is-wireable cx (+ cy 1))
             (al:draw-line
               (+ x  8) (+ y  8)
               (+ x  8) (+ y 16)
               color 2.0))
           (al:draw-circle/fill
             (+ x 8) (+ y 8)
             1.0 color)))

      ((e) (al:draw-triangle/fill
             (+ x  2) (+ y  2)
             (+ x 14) (+ y  2)
             (+ x  8) (+ y 14)
             color-black))

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


(define (tick-world-cell-wire! cx cy)
  (let* ((cell (world-grid-ref cx cy)))
    (case cell
      ((+) ; Uncharged wire
       (world-grid-set! cx cy cell)
       (when (world-cell-has-fully-charged-neighbours cx cy)
         (world-grid-set! cx cy '+c)))
      ((+c) ; Charged wire
       (world-grid-set! cx cy '+t))
      ((+t) ; Charged wire tail
       (world-grid-set! cx cy '+)))))

(define (tick-world-cell! cx cy)
  (let* ((cell (world-grid-ref cx cy)))
    (world-grid-set! cx cy cell)
    (case cell
      ((h) ; Heart
       (when (and (= (quotient (+ player-x 0) 16) cx)
                  (= (quotient (+ player-y 0) 16) cy))
         (world-grid-set! cx cy 0))
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

      ((e) ; Enemy spawner
       (when (and (world-cell-has-charged-neighbours cx cy)
                  (= (random 10) 0))
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
              (tick-world-cell-wire! x y)
              (loop (+ x 1) y))))

    (world-grid-swap!)))

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

