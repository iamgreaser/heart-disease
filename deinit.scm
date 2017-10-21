;; vim: set sts=2 sw=2 et lisp sm syntax= :

;; Kill main thread
(cond (main-thread
        (let ((old-thread main-thread))
          ;
          (begin
            ;; hide the reference
            (set! main-thread #f)

            ;; this should be long enough to wait
            (thread-join! old-thread 0.5)

            ;; kill it if it isn't dead
            (thread-terminate! old-thread)
            ))))

;; Close the display
(set! al-display #f)

