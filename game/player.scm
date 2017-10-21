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
    (let* ((old-cx-med (floor-quotient old-x 16))
           (old-cy-med (floor-quotient old-y 16))
           (old-cx-min (floor-quotient (+ old-x -7) 16))
           (old-cy-min (floor-quotient (+ old-y -7) 16))
           (old-cx-max (floor-quotient (+ old-x  7) 16))
           (old-cy-max (floor-quotient (+ old-y  7) 16))
           (new-cx-min (floor-quotient (+ new-x -7) 16))
           (new-cy-min (floor-quotient (+ new-y -7) 16))
           (new-cx-max (floor-quotient (+ new-x  7) 16))
           (new-cy-max (floor-quotient (+ new-y  7) 16)))

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
        (set! new-cx-min (floor-quotient (+ new-x -7) 16))
        (set! new-cy-min (floor-quotient (+ new-y -7) 16))
        (set! new-cx-max (floor-quotient (+ new-x  7) 16))
        (set! new-cy-max (floor-quotient (+ new-y  7) 16))
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

      (set! player-x new-x)
      (set! player-y new-y))

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

