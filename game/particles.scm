;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define (add-particle! particle)
  (set! particle-list
    (cons particle particle-list)))

(define (add-basic-particle!
          timeout
          x y radius color
          dx dy)
  (add-particle!
    `(basic ,timeout
            ,x ,y ,radius ,color
            ,dx ,dy (die-on-world))))

(define (add-basic-particle*!
          timeout
          x y radius color
          dx dy attribs)
  (add-particle!
    `(basic ,timeout
            ,x ,y ,radius ,color
            ,dx ,dy ,attribs)))

(define (add-basic-env-particle!
          timeout
          x y radius color
          dx dy)
  (add-particle!
    `(basic ,timeout
            ,x ,y ,radius ,color
            ,dx ,dy ())))


(define (tick-basic-env-particle!
          args
          x y radius color dx dy
          attribs)
  (set-car!      args  (+ x dx))
  (set-car! (cdr args) (+ y dy))
  args)


(define (tick-basic-particle!
          args
          old-x old-y radius color dx dy
          attribs)
  (let* ((new-x (+ old-x dx))
         (new-y (+ old-y dy)))
    ;
    (dynamic-wind
      (lambda () #f)
      (lambda ()
        (call/cc
          (lambda (ret)
            (when (member 'die-on-world attribs)
              (when (world-point-is-solid-for-particles new-x new-y)
                (ret #f)))
            (when (member 'collide-with-world attribs)
              (when (world-point-is-solid-for-particles new-x new-y)
                (let ((speed-mul (* -1/1000 (random 100))))
                  (begin
                    (set! new-x old-x)
                    (set! new-y old-y)
                    (set-car!      (cddddr args)  (* dx speed-mul))
                    (set-car! (cdr (cddddr args)) (* dy speed-mul))))))
            (when (member 'kills-enemies attribs)
              (begin
                (for-each-mob-at-of
                  (lambda (args attribs new-x new-y . extra)
                    (set-car! args (cons 'dead attribs))
                    (do ((i 5 (- i 1)))
                      ((<= i 0))
                      (add-basic-particle*!
                        (+ 60 (random 30))
                        new-x new-y (+ 1 (random 3))
                        (al:make-color-rgb
                          (+ (random 128) 64)
                          (+ (random 128) 64)
                          0)
                        (+ dx (* 0.2 (* (random 41) 1/10) -2))
                        (+ dy (* 0.2 (* (random 41) 1/10) -2))
                        '(collide-with-world)))
                    (ret #f))
                  new-x new-y
                  (+ 7 radius)
                  'enemy-1)))
            args)))
      (lambda ()
        (set-car!      args  new-x)
        (set-car! (cdr args) new-y)))))

(define (tick-particle-with! fn particle args)
  (begin
    (set! args
      (apply fn (cons args args)))
    (if args
      (begin
        (set-cdr! (cdr particle) args)
        particle)
      #f)))

(define (tick-particle! particle)
  (let ((type       (car  particle))
        (timeout    (cadr particle))
        (args       (cddr particle)))
    (begin
      ;; Advance timeout
      (set!     timeout        (- timeout 1))
      (set-car! (cdr particle)    timeout)
      (cond ((< timeout 0) #f)
            ((eq? type 'basic)
             (tick-particle-with!
               tick-basic-particle!
               particle args))
            (else
              (error
                (string-append
                  "invalid particle type: "
                  (->string type))))))))


(define (tick-particles!)
  (let ((old-particle-list particle-list))
    (set! particle-list '())
    (set! particle-list
      (let loop ((p old-particle-list))
        (if (null? p)
          particle-list
          (let ((result (tick-particle! (car p))))
            (if result
              (cons result (loop (cdr p)))
              (loop (cdr p)))))))))


(define (draw-particle x y radius color . extra)
  (when (and (>= x (- camera-x radius))
             (>= y (- camera-y radius))
             (<= x (+ camera-x logical-width     radius))
             (<= y (+ camera-y logical-height -8 radius)))
    (al:draw-circle/fill
      x y radius color)))

(define (draw-particles)
  (do ((p particle-list (cdr p)))
    ((null? p))
    (apply draw-particle (cddr (car p)))))

