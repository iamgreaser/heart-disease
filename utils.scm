;; vim: set sts=2 sw=2 et lisp sm syntax= :

(define (->int n)
  (inexact->exact (floor n)))

(define (floor-quotient n d)
  (let ((n (->int n)))
    (quotient (- n (modulo n d)) d)))

(define (ceil-quotient n d)
  (+ (floor/ n d)
     (if (= (modulo n d) 0)
       0
       1)))

;;;
;;; kd tree implementation
;;;
;;; We assume 2D here.
;;;
;;; A generic algorithm could work,
;;; but that's not we need right now,
;;; and it will complicate things for no real benefit.
;;;
;;; Possible kd-nodes:
;;; `(split  ,axis-idx ,median ,left-kd-node ,right-kd-node)
;;; `(bucket ,real-nodes)
;;; `(empty)

(define (kd-tree-new node->space
                     ops)
  (let* ((source (map (lambda (n)
                        (cons (node->space n) n))
                      ops)))

    (kd-tree-split-node-recursive source)))

(define (kd-tree-split-node-recursive source)
  (let ((nodes (length source)))
    (cond ((=  nodes  0) `(empty))
          ((<= nodes 20) `(bucket ,source))
          (else
           (kd-tree-split-node-recursive-force source)))))

(define (kd-tree-split-node-recursive-force source)
  ;(pp source)
  (let* ((x-min (apply min (map (lambda (n) (caar  n)) source)))
         (x-max (apply max (map (lambda (n) (caar  n)) source)))
         (y-min (apply min (map (lambda (n) (cadar n)) source)))
         (y-max (apply max (map (lambda (n) (cadar n)) source)))
         (x-len (- x-max x-min))
         (y-len (- y-max y-min))
         (left-node   '())
         (right-node  '())
         (split-axis   #f)
         (split-ref    #f)
         (split-sorted #f)
         (split-median #f))

    ;; Work out axis to split by
    (cond ((>= x-len y-len) (set! split-axis 0)
                            (set! split-ref
                              (lambda (n)
                                (car  (car n)))))
          (else             (set! split-axis 1)
                            (set! split-ref
                              (lambda (n)
                                (cadr (car n))))))

    ;; Get the median
    (set! split-sorted (sort (map split-ref source) <))
    (set! split-median
      (list-ref split-sorted
                (quotient (length split-sorted) 2)))

    ;; Split list into nodes
    (do ((p source (cdr p)))
      ((null? p))
      (if (>= (split-ref (car p))
              split-median)
        (set! right-node (cons (car p) right-node))
        (set! left-node  (cons (car p) left-node ))))

    ;; Handle nasty edge case:
    ;; If we only have two nodes on exactly the same point,
    ;; left will be empty.
    (when (= (length left-node) 0)
      (set! right-node
        (let loop ((p right-node))
          (cond ((= split-median (split-ref (car p)))
                 (set! left-node (cons (car p) left-node))
                 (cdr p))
                ((null? (cdr p))
                 (set! left-node (cons (car p) left-node))
                 (cdr p))
                (else
                 (cons (car p)
                       (loop (cdr p))))))))

    ;; This should never happen,
    ;; but we can still be prepared for it
    (when (= (length right-node) 0)
      (set! left-node
        (let loop ((p left-node))
          (cond ((= split-median (split-ref (car p)))
                 (set! right-node (cons (car p) right-node))
                 (cdr p))
                ((null? (cdr p))
                 (set! right-node (cons (car p) right-node))
                 (cdr p))
                (else
                 (cons (car p)
                       (loop (cdr p))))))))

    ;; Create split node!
    `(split ,split-axis
            ,split-median
            ,(kd-tree-split-node-recursive left-node)
            ,(kd-tree-split-node-recursive right-node))))

(define (kd-tree-for-each-node-in
          fn
          b-min b-max
          tree)
  (case (car tree)

    ;; split: Work out which splits we might cover
    ((split)
     (let* ((axis   (cadr tree))
            (median (caddr tree))
            (nodes  (cdddr tree))
            (p-min  (list-ref b-min axis))
            (p-max  (list-ref b-max axis)))

       ;; Select possible splits
       (when #t;(<= p-min median)
         (kd-tree-for-each-node-in
           fn b-min b-max (car  nodes)))
       (when #t;(>= p-max median)
         (kd-tree-for-each-node-in
           fn b-min b-max (cadr nodes)))))

    ;; bucket: Do all applicable nodes
    ((bucket)
     (do ((p (cadr tree) (cdr p)))
       ((null? p))
       (fn (cdr (car p)))))

    ;; empty: Do nothing
    ((empty) #f)

    (else (error (string-append
                   "invalid kd node type "
                   (->string (car tree)))))))

