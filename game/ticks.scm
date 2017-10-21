;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define (poll-keys!)
  (set! inputs-old inputs-new)
  (set! inputs-new '())
  (let* ((keys (al:make-keyboard-state)))
    (al:keyboard-state-init! keys)
    (for-each
      (lambda (k)
        (when (al:keyboard-state-key-down? keys (car k))
          (set! inputs-new
            (cons (cadr k)
                  inputs-new))))
      input-key-bindings)))

(define (poll-mouse!)
  (let* ((mouse (al:make-mouse-state)))
    (al:mouse-state-init! mouse)
    (set! input-mouse-x
      (quotient (* logical-width
                   (al:mouse-state-axis mouse 0))
                display-width))
    (set! input-mouse-y
      (quotient (* logical-height
                   (al:mouse-state-axis mouse 1))
                display-height))
    (for-each
      (lambda (k)
        (when (al:mouse-state-button-down mouse (car k))
          (set! inputs-new
            (cons (cadr k)
                  inputs-new))))
      input-mouse-button-bindings)))

(define (handle-input!)
  (poll-keys!)
  (poll-mouse!))

(define (handle-physics!)
  (player-tick-movement!)
  (tick-world!)
  (tick-particles!))


(define (take-screenshot!)
  (let ((fname #f))
    ;
    (set! fname
      (string-append "var/screenshots/"
                     "screenshot-"
                     (number->string (current-seconds))
                     "-"
                     (number->string (current-milliseconds))
                     ".png"))
    (print (string-append "Screenshot filename: "
                          fname))
    (al:bitmap-save
      (al:display-backbuffer al-display)
      fname)))

(define (handle-drawing!)
  (al:transform-identity! (al:current-transform))
  (al:transform-scale! (al:current-transform)
                       (/ display-width  logical-width)
                       (/ display-height logical-height))
  (al:transform-use (al:current-transform))

  (al:clear-to-color
    (al:make-color-rgb  85  85  85))

  ;; World
  (draw-world)

  ;; Player
  (draw-player player-x player-y)

  ;; Particles
  (draw-particles)

  ;; Bottom bar
  (al:draw-rectangle/fill 0 192 logical-width logical-height color-black)
  (do ((i 3 (- i 1)))
    ((<= i 0))
    ;
    (draw-heart (+ 6 (* (- i 1) 10))
                (- logical-height 3)
                5))

  ;; Last moment to screenshot
  (when (memv 'take-screenshot inputs-new)
    (unless (memv 'take-screenshot inputs-old)
      (take-screenshot!)))

  ;; Flip!
  (al:flip-display))

