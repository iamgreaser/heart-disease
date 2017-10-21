;; vim: set sts=2 sw=2 et lisp sm syntax= :

(load "utils.scm")

(define input-key-bindings
  `((a move-left)
    (d move-right)
    (w move-up)
    (s move-down)
    
    (f12 take-screenshot)))

(define input-mouse-button-bindings
  `((1 fire)))

(load "game/draws.scm")
(load "game/particles.scm")
(load "game/player.scm")
(load "game/ticks.scm")
(load "game/world.scm")

(define (main-loop)
  (thread-sleep! 1/60)

  (handle-input!)
  (handle-physics!)
  (handle-drawing!)

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

;; Start main thread if it's not alive
(cond ((not main-thread)
       (main-loop-start))
      ((eq? (thread-state main-thread) 'terminated)
       (main-loop-start))
      ((eq? (thread-state main-thread) 'dead)
       (main-loop-start)))

