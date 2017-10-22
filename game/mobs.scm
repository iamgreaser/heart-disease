;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define (add-mob! mob)
  (set! mob-list
    (cons mob mob-list)))

(define (add-enemy-1-mob!
          timeout
          x y)
  (add-mob!
    `(enemy-1 ,timeout (enemy)
              ,x ,y
              )))

(define (tick-enemy-1-mob!
          args
          attribs
          old-x old-y)
  (let* ((delta-x    (- player-x old-x))
         (delta-y    (- player-y old-y))
         (delta-len  (sqrt (+ (* delta-x delta-x)
                              (* delta-y delta-y))))
         (delta-ilen (/ (max 0.00001 delta-len)))
         (dir-x (* delta-x delta-ilen))
         (dir-y (* delta-y delta-ilen))
         (speed 2.0)
         (target-x (+ old-x (* speed dir-x)))
         (target-y (+ old-y (* speed dir-y)))
         (new-x    target-x)
         (new-y    target-y))

    ;; Collide with world
    (call-with-values
      (lambda ()
        (collide-box-with-world
          old-x old-y
          new-x new-y
          -7 -7 7 7))
      (lambda (x y)
        (set! new-x    x)
        (set! new-y    y)))

    (set-car! (cdr  args)  new-x)
    (set-car! (cddr args) new-y)
    args))


(define (tick-mob-with! fn mob args)
  (begin
    (set! args
      (apply fn (cons args args)))
    (if args
      (begin
        (set-cdr! (cdr mob) args)
        mob)
      #f)))

(define (tick-mob! mob)
  (let ((type       (car  mob))
        (timeout    (cadr mob))
        (args       (cddr mob)))
    (begin
      ;; Advance timeout
      (set!     timeout        (- timeout 1))
      (set-car! (cdr mob)    timeout)
      (cond ((< timeout 0) #f)
            ((memv 'dead (car args)) #f)
            ((eq? type 'enemy-1)
             (tick-mob-with!
               tick-enemy-1-mob!
               mob args))
            (else
              (error
                (string-append
                  "invalid mob type: "
                  (->string type))))))))


(define (tick-mobs!)
  (begin
    (set! mob-list
      (let loop ((p mob-list))
        (if (null? p)
          '()
          (let ((result (tick-mob! (car p))))
            (if result
              (cons result (loop (cdr p)))
              (loop (cdr p)))))))
    '(set! mob-kd-tree
      (kd-tree-new
        (lambda (n)
          (let ((pt (cdddr n)))
            `(,(car  pt)
              ,(cadr pt))))
        mob-list))))


(define (draw-mob type attribs x y . extra)
  (al:draw-triangle/fill
    (+ x -6) (+ y -6)
    (+ x  6) (+ y -6)
    (+ x  0) (+ y  6)
    (al:make-color-rgb  32 190  32))
  (al:draw-triangle
    (+ x -6) (+ y -6)
    (+ x  6) (+ y -6)
    (+ x  0) (+ y  6)
    color-black
    1.0))

(define (draw-mobs)
  (do ((p mob-list (cdr p)))
    ((null? p))
    (apply draw-mob (cdr (car p)))))


;;;
;;; KD-TREE VERSION
;;;
'(define (for-each-mob-at-of fn point-x point-y radius mob-type)
  (let ((radius2 (* radius radius)))
    (let ((fn (lambda (mob)
                (let* ((mob-x   (car (cdddr  mob)))
                       (mob-y   (car (cddddr mob)))
                       (delta-x (- mob-x point-x))
                       (delta-y (- mob-y point-y))
                       (dist2   (+ (* delta-x delta-x)
                                   (* delta-y delta-y))))
                  (when (and (<= dist2 radius2)
                             (eq? mob-type (car mob)))
                    (apply fn (cons (cddr mob)
                                    (cddr mob))))))))
      (kd-tree-for-each-node-in
        fn
        `(,(- radius) ,(- radius))
        `(,(+ radius) ,(+ radius))
        mob-kd-tree)
      ;;(for-each fn mob-list)
      )))

;;;
;;; NAIVE VERSION
;;;
(define (for-each-mob-at-of fn point-x point-y radius mob-type)
  (let ((radius2 (* radius radius)))
    (do ((p mob-list (cdr p)))
      ((null? p))
      (let* ((mob     (car p))
             (mob-x   (car (cdddr  mob)))
             (mob-y   (car (cddddr mob)))
             (delta-x (- mob-x point-x))
             (delta-y (- mob-y point-y))
             (dist2   (+ (* delta-x delta-x)
                         (* delta-y delta-y))))
        (when (and (<= dist2 radius2)
                   (eq? mob-type (car mob)))
          (apply fn (cons (cddr mob)
                          (cddr mob))))))))

