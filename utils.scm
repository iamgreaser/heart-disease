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

(define (kd-tree-new node->space ops)
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
  (let* ((x-min (apply min (map (lambda (n) (list-ref (car n) 0)) source)))
         (x-max (apply max (map (lambda (n) (list-ref (car n) 0)) source)))
         (y-min (apply min (map (lambda (n) (list-ref (car n) 1)) source)))
         (y-max (apply max (map (lambda (n) (list-ref (car n) 1)) source)))

         ;; Find axis to split by
         (x-len        (- x-max x-min))
         (y-len        (- y-max y-min))
         (split-axis   (cond ((>= x-len y-len) 0)
                             (else             1)))
         (split-ref    (lambda (n)
                         (list-ref (car n) split-axis)))

         ;; Sort and split
         (split-sorted (sort source
                             (lambda (a b)
                               (< (split-ref a)
                                  (split-ref b)))))
         (split-centre (quotient (length split-sorted) 2))
         (left-node    (take split-sorted split-centre))
         (right-node   (drop split-sorted split-centre))

         ;; Get median
         (split-median (split-ref (car right-node))))

    '(pp `(,(split-ref (car left-node))
          ,split-median
          ,(split-ref (car right-node))))

    ;; Create split node!
    `(split ,split-axis
            ,split-median
            ,(kd-tree-split-node-recursive left-node)
            ,(kd-tree-split-node-recursive right-node))))


(define (kd-tree-for-each-node-in
          fn b-min b-max tree)
  ;(pp `(,b-min ,b-max))
  (case (car tree)

    ;; split: Work out which splits we might cover
    ((split)
     (let* ((split-axis   (cadr  tree))
            (split-median (caddr tree))
            (nodes        (cdddr tree))
            (left-node    (car  nodes))
            (right-node   (cadr nodes))
            (axial-min    (list-ref b-min split-axis))
            (axial-max    (list-ref b-max split-axis)))

       ;(pp `(,p-min ,p-max ,split-axis ,split-median))
       ;; Select possible splits
       (when (<= axial-min split-median)
         (kd-tree-for-each-node-in
           fn b-min b-max left-node))
       (when (>= axial-max split-median)
         (kd-tree-for-each-node-in
           fn b-min b-max right-node))))

    ;; bucket: Do all applicable nodes
    ((bucket)
     (for-each
       (lambda (n) (fn (cdr n)))
       (cadr tree)))

    ;; empty: Do nothing
    ((empty) #f)

    (else (error (string-append
                   "invalid kd node type "
                   (->string (car tree)))))))

