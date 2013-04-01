;;; Copyright (c) 2012 by Álvaro Castro Castilla
;;; Test for Cairo with OpenGL

(define screen-width 1280.0)
(define screen-height 752.0)
(define tile-width 50.0)
(define tile-height 50.0)
(define horizontal-tile-cache (+ 2  (/ screen-width tile-width)))
(define vertical-tile-cache (+ 2  (/ screen-height tile-width)))


;; Mapa de prueba, lo ideal seria leer estas listas desde archivo, y tener distribuidos de esta manera los niveles.
(define my-map '#(#(1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 1 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
                  #(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(define-structure player posx posy hstate vstate)
(define-structure world gamestate player)

(define (main)
  ((fusion:create-simple-gl-cairo '(width: 1280  height: 752))
   (lambda (event world)
     (println (string-append "event: " (object->string event) " ; world: " (object->string world)))
     (let ((type (SDL_Event-type event)))
       (cond
        ((= type SDL_QUIT)
         'exit)
        ((= type SDL_MOUSEBUTTONDOWN)
         (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION "Button down")
         world)
        ((= type SDL_KEYDOWN)
         (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION "Key down")
         (let* ((kevt (SDL_Event-key event))
                (key (SDL_Keysym-sym
                      (SDL_KeyboardEvent-keysym kevt))))
           (cond ((= key SDLK_ESCAPE)
                  'exit)
                 ((= key SDLK_RETURN)
                  (if (eq? (world-gamestate world) 'splash-screen)
                      (make-world 'game-screen (make-player 150 200 'idle 'idle))
                      (make-world 'splash-screen '())))
                 ((= key SDLK_LEFT)
                  (if (eq? (world-gamestate world) 'game-screen)
                      (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'left (player-vstate (world-player world))))
                      world))
                 ((= key SDLK_RIGHT)
                  (if (eq? (world-gamestate world) 'game-screen)
                      (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'right (player-vstate (world-player world))))
                      world))
                 ((= key SDLK_UP)
                  (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-vstate (world-player world)) 'idle))
                      (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) (player-hstate (world-player world)) 'jump))
                      world))
                 (else
                  (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION (string-append "Key: " (number->string key)))
                  world))))
        ((= type SDL_KEYUP)
         (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION "Key up")
         (let* ((kevt (SDL_Event-key event))
                (key (SDL_Keysym-sym
                      (SDL_KeyboardEvent-keysym kevt))))
           (cond  ((= key SDLK_LEFT)
                   (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-hstate (world-player world)) 'left))
                       (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'idle (player-vstate (world-player world))))
                       world))
                  ((= key SDLK_RIGHT)
                   (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-hstate (world-player world)) 'right))
                       (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'idle (player-vstate (world-player world))))
                       world))
                  ((= key SDLK_UP)
                   (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-vstate (world-player world)) 'jump))
                       (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) (player-hstate (world-player world)) 'falling)) 
                       world))
                  (else
                   (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION (string-append "Key: " (number->string key)))
                   world))))
        (else
         world))))
   (let ((posx 80.0) (jumpcounter 0))
     (lambda (cr time world)
       (println (string-append "time: " (object->string time) " ; world: " (object->string world)))
       (pp (vector-ref (vector-ref my-map 4) 1))
       ;;(SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (object->string (SDL_GL_Extension_Supported "GL_EXT_texture_format_BGRA8888")))
       (case (world-gamestate world)
         ((splash-screen)

          ;;Menu screen, to be implemented
          (cairo_set_source_rgba cr 0.0 0.0 0.0 1.0)
          (cairo_rectangle cr 0.0 0.0 screen-width screen-height)
          (cairo_fill cr)
          (cairo_select_font_face cr "Sans" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
          (cairo_set_source_rgba cr 1.0 1.0 1.0 0.8)
          (cairo_set_font_size cr 80.0)
          (cairo_move_to cr 300.0 400.0)
          (cairo_show_text cr "MENU SCREEN")
          (cairo_fill cr))
         ((game-screen)

          ;;Just testing code.
          (cairo_set_source_rgba cr 0.0 0.0 0.0 1.0)
          (cairo_rectangle cr 0.0 0.0 screen-width screen-height)
          (cairo_fill cr)
          (cairo_select_font_face cr "Sans" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
          (cairo_set_source_rgba cr 1.0 1.0 1.0 0.8)
          (cairo_set_font_size cr 80.0)
          (cairo_move_to cr 200.0 400.0)
          (cairo_show_text cr "Game-Screen Test")
          (cairo_fill cr)

          ;;Drawing the player
          (cairo_set_source_rgba cr 0.0 0.0 1.0 1.0)
          (cairo_rectangle cr (exact->inexact (player-posx (world-player world))) (exact->inexact (player-posy (world-player world))) 50.0 50.0)
          (cairo_fill cr)
          
          ;;Drawing the tiles.
          (cairo_set_source_rgba cr 0.0 1.0 0.0 1.0)
          (let loop ((rest my-map) (counterX 0) (counterY 0))
            (if (and (eq? counterX 29) (eq? counterY 29))
                '()
                (begin 
                  (if (eq? (vector-ref (vector-ref my-map counterY) counterX) 1)
                      (begin
                        (cairo_rectangle cr (exact->inexact (* counterX tile-width)) (exact->inexact (* counterY tile-height)) tile-width tile-height)
                        (cairo_fill cr)))
                  (if (eq? counterX 29)
                      (loop rest (- counterX 29) (+ counterY 1))
                      (loop rest (+ counterX 1) counterY)))))
          
          ;;Collision calculation

          ;;Going Left
          (if (eq? (player-hstate (world-player world)) 'left)
              (begin
                (if (or (eq? (vector-ref (vector-ref my-map (inexact->exact (floor (/ (player-posy (world-player world)) tile-height)))) 
                                         (inexact->exact (floor (/ (- (player-posx (world-player world)) 2) tile-width)))) 1))
                    (player-posx-set! (world-player world) (+ (player-posx (world-player world)) 1))
                    (player-posx-set! (world-player world) (- (player-posx (world-player world)) 5)))))

          ;;Going Right
          (if (eq? (player-hstate (world-player world)) 'right)
              (begin
                (if (eq? (vector-ref (vector-ref my-map (inexact->exact (floor (/ (player-posy (world-player world)) tile-height)))) 
                                     (+ (inexact->exact (floor (/ (player-posx (world-player world)) tile-width))) 1)) 1)
                    (player-posx-set! (world-player world) (- (player-posx (world-player world)) 1))
                    (player-posx-set!  (world-player world) (+ (player-posx (world-player world)) 5)))))
          ;;Falling
          (if (or (eq? (player-vstate (world-player world)) 'idle) (eq? (player-vstate (world-player world)) 'falling))
              (begin
                (if (or (eq? (vector-ref (vector-ref my-map (+ (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))) 1))
                                         (inexact->exact (floor (/ (player-posx (world-player world)) tile-width)))) 1)
                        (eq? (vector-ref (vector-ref my-map (+ (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))) 1))
                                         (+ (inexact->exact (floor (/ (player-posx (world-player world)) tile-width))) 1)) 1))
                    (begin
                      (player-vstate-set! (world-player world) 'idle)
                      (set! jumpcounter 0))
                    (begin
                      (player-posy-set! (world-player world) (+ (player-posy (world-player world)) 10))
                      (player-vstate-set! (world-player world) 'falling)))))
          
          ;;Jumping
          (if (eq? (player-vstate (world-player world)) 'jump)
              (begin
                (if (eq? (vector-ref (vector-ref my-map (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))))
                                     (inexact->exact (floor (/ ( player-posx (world-player world)) tile-width)))) 1)
                    (player-vstate-set! (world-player world) 'falling)
                    (if (> jumpcounter 300)
                        (begin
                          (player-vstate-set! (world-player world) 'falling)
                          (set! jumpcounter 0))
                        (begin
                          (player-posy-set! (world-player world) (- (player-posy (world-player world)) 10))
                          (set! jumpcounter (+ jumpcounter 10)))))))
          ))
       world))
   (make-world
    'splash-screen
    '())))

