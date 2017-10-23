;; vim: set sts=2 sw=2 et lisp sm syntax= :

;; UNCOMMENT WHEN COMPILING
;(use (prefix allegro al:))

(define (rgba->color r g b a)
  (apply al:make-color-rgba
         (map (lambda (n) (->int (* n a 1/255)))
              `(,r ,g ,b 255))))

(define color-heart (al:make-color-rgb 255  32  64))

(define color-black        (al:make-color-rgb   0   0   0))
(define color-white        (al:make-color-rgb 255 255 255))
(define color-magic-pink   (al:make-color-rgb 255   0 255))
(define color-wire-charged (al:make-color-rgb   0  85 170))

(define (draw-heart x y size)
  ;; Fill
  (al:draw-circle/fill (+ x (* size  1/2))
                       (+ y (* size -1/2))
                       (* size 1/2)
                       color-heart)
  (al:draw-circle/fill (+ x (* size -1/2))
                       (+ y (* size -1/2))
                       (* size 1/2)
                       color-heart)
  (al:draw-triangle/fill (+ x (* size  1/2 (- -1/1 (sqrt 1/2))))
                         (+ y (* size  1/2 (+ -1/1 (sqrt 1/2))))
                         (+ x (* size  1/2 (+  1/1 (sqrt 1/2))))
                         (+ y (* size  1/2 (+ -1/1 (sqrt 1/2))))
                         (+ x (* size  0/1))
                         (+ y (* size  1/1))
                         color-heart)
  (al:draw-triangle/fill (+ x (* size  1/2 (- -1/1 (sqrt 1/2))))
                         (+ y (* size  1/2 (+ -1/1 (sqrt 1/2))))
                         (+ x (* size  1/2 (+  1/1 (sqrt 1/2))))
                         (+ y (* size  1/2 (+ -1/1 (sqrt 1/2))))
                         (+ x (* size  0/1))
                         (+ y (* size -1/2))
                         color-heart)

  ;; Outline
  (al:draw-arc (+ x (* size  1/2))
               (+ y (* size -1/2))
               (* size 1/2)
               (* pi 2  1/8 1.02)
               (* pi 2 -5/8)
               color-black
               2.0)
  (al:draw-arc (+ x (* size -1/2))
               (+ y (* size -1/2))
               (* size 1/2)
               (* pi 2  0/8)
               (* pi 2 -5/8 1.01)
               color-black
               2.0)
  (al:draw-line (+ x (* size  1/2 (- -1/1 (sqrt 1/2))))
                (+ y (* size  1/2 (+ -1/1 (sqrt 1/2))))
                (+ x (* size  0/1))
                (+ y (* size  1/1))
                color-black
                2.0)
  (al:draw-line (+ x (* size  1/2 (+  1/1 (sqrt 1/2))))
                (+ y (* size  1/2 (+ -1/1 (sqrt 1/2))))
                (+ x (* size  0/1))
                (+ y (* size  1/1))
                color-black
                2.0))

