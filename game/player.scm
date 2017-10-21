;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define color-player (al:make-color-rgb 225 225 255))

(define player-movement-speed 3)
(define (player-tick-movement!)
  (let ((old-x player-x)
        (old-y player-y)
        (new-x player-x)
        (new-y player-y))

    ;; Player directions
    (when (memv 'move-left inputs-new)
      (unless (memv 'move-right inputs-new)
        (set! new-x (- new-x player-movement-speed))))
    (when (memv 'move-right inputs-new)
      (unless (memv 'move-left inputs-new)
        (set! new-x (+ new-x player-movement-speed))))
    (when (memv 'move-up inputs-new)
      (unless (memv 'move-down inputs-new)
        (set! new-y (- new-y player-movement-speed))))
    (when (memv 'move-down inputs-new)
      (unless (memv 'move-up inputs-new)
        (set! new-y (+ new-y player-movement-speed))))

    ;; Physics checks
    (call-with-values
      (lambda ()
        (collide-box-with-world
          old-x old-y
          new-x new-y
          -7 -7 7 7))
      (lambda (x y)
        (set! new-x    x)
        (set! new-y    y)
        (set! player-x x)
        (set! player-y y)))

    ;; Actually fire stuff
    (let* ((fire-delta-x    (- input-mouse-x player-x))
           (fire-delta-y    (- input-mouse-y player-y))

           ;; Normalise
           (fire-delta-len  (sqrt
                              (+ (* fire-delta-x fire-delta-x)
                                 (* fire-delta-y fire-delta-y))))
           (fire-delta-ilen (/ (max 0.00001 fire-delta-len)))
           (fire-dir-x      (* fire-delta-x fire-delta-ilen))
           (fire-dir-y      (* fire-delta-y fire-delta-ilen)))
      ;
      (when (memv 'fire inputs-new)
        (unless (memv 'fire inputs-old)
          (do ((i -2 (+ i 1)))
            ((> i 2))
            (let* ((angle      (* 5 (+ i (* (- (random 100) 50) 1/100)) pi 1/180))
                   (speed      (+ 6 (* (random 20) 1/20)))
                   (radius     (+ 3 (* (random 20) 1/10)))
                   (velocity-x (+ (* fire-dir-x speed  1 (cos angle))
                                  (* fire-dir-y speed  1 (sin angle))))
                   (velocity-y (+ (* fire-dir-y speed  1 (cos angle))
                                  (* fire-dir-x speed -1 (sin angle)))))
              (add-basic-particle!
                60
                player-x player-y 
                radius color-white
                (* velocity-x 0.7)
                (* velocity-y 0.7))
              (add-basic-particle!
                60
                player-x player-y 
                radius color-white
                velocity-x velocity-y)))))
      )

    ;
    ))


(define (draw-player x y)
  ;; Main player graphic
  (al:draw-rectangle
    (+ x -7)
    (+ y -7)
    (+ x  7)
    (+ y  7)
    color-black
    2.0)
  (al:draw-rectangle/fill
    (+ x -7)
    (+ y -7)
    (+ x  7)
    (+ y  7)
    color-player)

  ;; Firing direction
  (let* ((fire-delta-x    (- input-mouse-x player-x))
         (fire-delta-y    (- input-mouse-y player-y))

         ;; Normalise
         (fire-delta-len  (sqrt
                            (+ (* fire-delta-x fire-delta-x)
                               (* fire-delta-y fire-delta-y))))
         (fire-delta-ilen (/ (max 0.00001 fire-delta-len)))
         (fire-dir-x      (* fire-delta-x fire-delta-ilen))
         (fire-dir-y      (* fire-delta-y fire-delta-ilen))
         (color-firing-arrow (al:make-color-rgb   0   0   0)))

    ;; Draw it
    (al:draw-line
      (+ player-x (*  19 fire-dir-x) (*   0 fire-dir-y))
      (+ player-y (*  19 fire-dir-y) (*   0 fire-dir-x))
      (+ player-x (*  33 fire-dir-x) (*   0 fire-dir-y))
      (+ player-y (*  33 fire-dir-y) (*   0 fire-dir-x))
      color-firing-arrow
      2.0)
    (al:draw-line
      (+ player-x (*  27 fire-dir-x) (*  10 fire-dir-y))
      (+ player-y (*  27 fire-dir-y) (* -10 fire-dir-x))
      (+ player-x (*  33 fire-dir-x) (*  -1 fire-dir-y))
      (+ player-y (*  33 fire-dir-y) (*   1 fire-dir-x))
      color-firing-arrow
      2.0)
    (al:draw-line
      (+ player-x (*  27 fire-dir-x) (* -10 fire-dir-y))
      (+ player-y (*  27 fire-dir-y) (*  10 fire-dir-x))
      (+ player-x (*  33 fire-dir-x) (*   1 fire-dir-y))
      (+ player-y (*  33 fire-dir-y) (*  -1 fire-dir-x))
      color-firing-arrow
      2.0)
    ;
    ))

