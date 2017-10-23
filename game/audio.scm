;; vim: set sts=2 sw=2 et lisp sm syntax= :

;; Configuration
(define music-mix-buffers 4)
(define music-mix-samples 2048)
(define music-mix-freq    24000)
(define music-mix-delay
  (* music-mix-buffers
     music-mix-samples))
(define music-bpm        110)
(define music-tpb        4)

;; Runtime stuff
(define music-offs-secs   0.0)
(define music-subtick     0.0)
(define music-tick       -1)

(define music-funk-phase-ref 0.0)

(define bass-rhythms
  #(;#(4 4 4 4)
    #(4 4 3 3 2)
    #(4 3 3 3 3)
    #(2 2 3 3 3 3)
    #(4 3 2 2 3 2)
    #(4 3 2 3 4)
    ))

(define bass-bites
  '((2 #(#( 0 #f)
         ))
    (3 #(#( 0 #f #f)
         #( 0 #f -2)
         #( 0 12 #f)
         #( 0  5  7)
         ))
    (4 #(#( 0 #f #f #f)
         #( 0 #f  0 #f)
         #( 0 #f 12 #f)
         ))))

(define bass-flourishes
  #(#(                     36
      43 #f 41 #f 39 41 39 34)
    #(                     36
      41 43 41 46 #f 41 46 48)
    ))

(define (fresh-new-bass-rhythm)
  (vector-ref
    bass-rhythms
    (random (vector-length bass-rhythms))))

(define (fresh-new-bass-flourish)
  (vector-ref
    bass-flourishes
    (random (vector-length bass-flourishes))))

(define (get-bass-bite ticks)
  (let* ((bite-selection (cadr (assoc ticks bass-bites)))
         (bite (vector-ref
                 bite-selection
                 (random (vector-length
                           bite-selection)))))
    bite))

(define (fresh-new-bass-pattern)
  (let* ((pattern      (make-vector 64 #f))
         (rhythm       music-rhythm-bass)
         (rhythm-idx   -1)
         (rhythm-rem    0)
         (flourish     (fresh-new-bass-flourish))
         (flourish-len (vector-length flourish)))

    ;; Apply rhythmic part
    (do ((i 0 (+ i 1)))
      ((>= i 64))
      (begin
        (when (= rhythm-rem 0)
          (begin
            ;; Advance pattern
            (set! rhythm-idx
              (modulo (+ rhythm-idx 1)
                      (vector-length rhythm)))
            (set! rhythm-rem
              (vector-ref rhythm rhythm-idx))

            (do ((bite (get-bass-bite rhythm-rem))
                 (j 0 (+ j 1)))
              ((>= j rhythm-rem))
              (when (vector-ref bite j)
                (vector-set! pattern
                             (+ i j)
                             (+ (vector-ref bite j)
                                36))))))
        (set! rhythm-rem (- rhythm-rem 1))))

    ;; Apply flourish
    (do ((i 0 (+ i 1)))
      ((>= i flourish-len))
      (vector-set! pattern
                   (+ i (- 64 flourish-len))
                   (vector-ref flourish i)))

    ;; Return
    pattern))

(define music-rhythm-bass
  (fresh-new-bass-rhythm))
(define music-pattern-bass
  (fresh-new-bass-pattern))
(define music-bass-freq 0.0)
(define music-bass-offs 0.0)
(define music-bass-vol  0.0)
(define music-bass-vol-target  0.0)

;; Restart sound
(al:stop-all-samples)

;; Create music audio stream if we haven't already
(unless al-music-stream
  (set! al-music-stream
    (al:make-audio-stream
      music-mix-buffers ; Buffer count
      music-mix-samples ; Samples
      music-mix-freq    ; Frequency
      'float32          ; Audio depth
      'one              ; Channel configuration
      ))
  (al:audio-stream-attach-to-mixer!
    al-music-stream
    (al:default-mixer)))

(define (note->freq n)
  (* 440.0 (expt 2.0 (/ (- n 70) 12.0))))

(define (ins-bass offs)
  (sin (+ (* tau offs)
          (* tau 0.4 (expt music-bass-vol 10)
            (sin (* 7 tau offs)))
          (* tau 1.9 (expt music-bass-vol 3)
            (sin (* 1 tau offs))))))

(define (music-funk-phase)
  (let* ((sample-ticks  (/ (* music-bpm music-tpb) 60.0))
         (funk-ticks    (/ sample-ticks 4.0)))
    (* (- (/ (current-milliseconds) 1000.0)
          music-funk-phase-ref)
       funk-ticks)))

;; Function to mix audio
(define (tick-music-fragment! frag)
  (let* ((sample-count  (al:audio-stream-length    al-music-stream))
         (mixing-freq   (al:audio-stream-frequency al-music-stream))
         (sec-count     (/ sample-count mixing-freq))
         (sample-ticks  (/ (* music-bpm music-tpb) 60.0 mixing-freq))
         (funk-ticks    (/ sample-ticks 4.0))
         (mixing-buffer (make-f32vector sample-count))
         (bass-decay    (exp (/ -5.0 mixing-freq))))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        ;;
        (do ((i  0 (+ i 1))
             (dt (/ mixing-freq))
             (t  music-offs-secs (+ t dt)))
          ((>= i sample-count) mixing-buffer) 

          (begin
            ;; Update ticks
            (set! music-subtick
              (+ music-subtick sample-ticks))
            (when (>= music-subtick
                      (if (= (modulo music-tick 2) 0)
                        1.1
                        0.9))
              (begin
                (set! music-subtick (- music-subtick 1.0))
                (set! music-tick    (+ music-tick    1))
                (when (= (modulo music-tick 64) 0)
                  (set! music-pattern-bass
                    (fresh-new-bass-pattern)))
                (when (= (modulo music-tick 4) 0)
                  (set! music-funk-phase-ref
                    (/ (current-milliseconds) 1000.0)))
                (let ((bass-pat (vector-ref
                                  music-pattern-bass
                                  (modulo music-tick
                                          (vector-length
                                            music-pattern-bass)))))
                  (when bass-pat
                    (set! music-bass-freq
                      (* (note->freq bass-pat) dt))
                    (set! music-bass-vol-target 1.0)))))

            ;; 
            (set! music-bass-vol-target  (* music-bass-vol-target
                                            bass-decay))
            (set! music-bass-vol         (+ music-bass-vol
                                            (* (- music-bass-vol-target
                                                  music-bass-vol)
                                               0.1)))
            (set! music-bass-offs        (+ music-bass-offs
                                            music-bass-freq))

            ;;
            (f32vector-set! mixing-buffer i
                            (+ (* (ins-bass music-bass-offs)
                                  0.8
                                  music-bass-vol))))))
      (lambda ()
        (set! music-offs-secs (+ music-offs-secs sec-count))
        ))))


(define (tick-music!)
  (let* ((frag (al:audio-stream-fragment al-music-stream)))
    (when frag
      (begin
        (move-memory! 
          (tick-music-fragment! frag)
          frag)
        (al:audio-stream-fragment-set!
          al-music-stream
          frag)))))

(define (handle-audio!)
  (tick-music!))

