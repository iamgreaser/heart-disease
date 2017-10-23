;; vim: set sts=2 sw=2 et lisp sm syntax= :

(load "utils.scm")

(define input-key-bindings
  `((a move-left)
    (d move-right)
    (w move-up)
    (s move-down)

    (r restart)

    (p pause)
    
    (f12 take-screenshot)))

(define input-mouse-button-bindings
  `((1 fire)))

(load "game/audio.scm")
(load "game/draws.scm")
(load "game/mobs.scm")
(load "game/particles.scm")
(load "game/player.scm")
(load "game/ticks.scm")
(load "game/world.scm")

(define (main-loop)
  (thread-sleep! 1/60)

  (when (member 'restart inputs-new)
    (unless (member 'restart inputs-old)
      (set! restart-flag #t)))
  (when restart-flag
    (new-game!)
    (set! music-rhythm-bass
      (fresh-new-bass-rhythm))
    (set! music-pattern-bass
      (fresh-new-bass-pattern)))

  (handle-input!)
  (when (member 'pause inputs-new)
    (unless (member 'pause inputs-old)
      (set! pause-enabled-flag
        (not pause-enabled-flag))))
  (unless pause-enabled-flag
    (handle-physics!))
  (handle-drawing!)
  (handle-audio!)

  ;(print "hi")
  (cond ((eq? main-thread (current-thread))
         (main-loop))))


(define (main-loop-start)
  (set! main-thread
    (make-thread
      (lambda ()
        (main-loop))
      'main-thread))
  (thread-start! main-thread))

;; Open display if it's not open already
(cond ((not al-display)
       (set! al-display
         (al:make-display display-width
                          display-height))))

;; Set the window title
(al:display-window-title-set!
  al-display
  "Heart Disease")

;; Start main thread if it's not alive
(cond ((not main-thread)
       (main-loop-start))
      ((eq? (thread-state main-thread) 'terminated)
       (main-loop-start))
      ((eq? (thread-state main-thread) 'dead)
       (main-loop-start)))

;; UNCOMMENT WHEN COMPILING
;(thread-join! main-thread)

