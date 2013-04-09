;;; Copyright (c) 2012 by Álvaro Castro Castilla
;;; Test for Cairo with OpenGL

(define screen-width 1280.0)
(define screen-height 752.0)
(define tile-width 25.0)
(define tile-height 25.0)

(define horizontal-tile-cache (+ 2  (/ screen-width tile-width)))
(define vertical-tile-cache (+ 2  (/ screen-height tile-width)))

;; Mapa de prueba, lo ideal seria leer estas listas desde archivo, y tener distribuidos de esta manera los niveles.
(define my-map '#(#(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 2)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 1 1 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(define level2 '#(#(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 1 1 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 1 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1)
                  #(1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1)))

(define levellist (cons my-map (cons level2 '())))
(define level+ (cons 28 (cons 3 '())))
(define level- (cons 3 (cons 28 '())))

(define-structure player posx posy hstate vstate)
(define-structure enemy posx posy)
(define-structure world gamestate player enemy)

(define (getlevel llist lcounter)
  (let loop ((rest llist) (counter 0))
    (if (eq? counter lcounter)
        (car rest)
        (loop (cdr rest) (+ counter 1)))))

(define (last nlist)
  (let loop ((rest nlist))
    (if (null? (cdr rest))
        (car rest)
        (loop (cdr rest)))))

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
                      (make-world 'game-screen (make-player (* tile-width 2) (* tile-width 28) 'idle 'idle) (make-enemy (- 0 tile-width) (- 0 tile-height)))
                      (make-world 'splash-screen '())))
                 ((= key SDLK_LEFT)
                  (if (eq? (world-gamestate world) 'game-screen)
                      (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'left (player-vstate (world-player world))) (world-enemy world))
                      world))
                 ((= key SDLK_RIGHT)
                  (if (eq? (world-gamestate world) 'game-screen)
                      (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'right (player-vstate (world-player world))) (world-enemy world))
                      world))
                 ((= key SDLK_UP)
                  (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-vstate (world-player world)) 'idle))
                      (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) (player-hstate (world-player world)) 'jump) (world-enemy world))
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
                       (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'idle (player-vstate (world-player world))) (world-enemy world))
                       world))
                  ((= key SDLK_RIGHT)
                   (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-hstate (world-player world)) 'right))
                       (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) 'idle (player-vstate (world-player world))) (world-enemy world))
                       world))
                  ((= key SDLK_UP)
                   (if (and (eq? (world-gamestate world) 'game-screen) (eq? (player-vstate (world-player world)) 'jump))
                       (make-world (world-gamestate world) (make-player (player-posx (world-player world)) (player-posy (world-player world)) (player-hstate (world-player world)) 'falling) (world-enemy world)) 
                       world))
                  (else
                   (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION (string-append "Key: " (number->string key)))
                   world))))
        (else
         world))))
   (let ((posx 80.0) (jumpcounter 0) (levelcounter 0) (enemyX '(0)) (enemyY '(0)) (enemycounter 0))
     (lambda (cr time world)
       ;;(println (getlevel levellist levelcounter))
       ;;(pp enemyX)
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

          ;;Drawing the player
          (cairo_set_source_rgba cr 0.0 0.0 1.0 1.0)
          (cairo_rectangle cr (exact->inexact (player-posx (world-player world))) (exact->inexact (player-posy (world-player world))) tile-width tile-height)
          (cairo_fill cr)

          ;;Drawing the enemy
          (cairo_set_source_rgba cr 1.0 0.0 1.0 1.0)
          (cairo_rectangle cr (exact->inexact (enemy-posx (world-enemy world))) (exact->inexact (enemy-posy (world-enemy world))) tile-width tile-height)
          (cairo_fill cr)
          
          ;;Drawing the tiles.
          (cairo_set_source_rgba cr 0.0 1.0 0.0 1.0)
          (let loop ((rest (getlevel levellist levelcounter)) (counterX 0) (counterY 0))
            (if (and (eq? counterX 50) (eq? counterY 29))
                (begin
                  (cairo_rectangle cr (exact->inexact (* counterX tile-width)) (exact->inexact (* counterY tile-height)) tile-width tile-height)
                  (cairo_fill cr))
                (begin 
                  (if (eq? (vector-ref (vector-ref rest counterY) counterX) 1)
                      (begin
                        (cairo_rectangle cr (exact->inexact (* counterX tile-width)) (exact->inexact (* counterY tile-height)) tile-width tile-height)
                        (cairo_fill cr)))
                  (if (eq? counterX 50)
                      (loop rest (- counterX 50) (+ counterY 1))
                      (loop rest (+ counterX 1) counterY)))))
          
          ;;Collision calculation

          ;;Going Left
          (if (eq? (player-hstate (world-player world)) 'left)
              (begin
                (if (or (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (player-posy (world-player world)) tile-height)))) 
                                         (inexact->exact (floor (/ (- (player-posx (world-player world)) (/ tile-width 25)) tile-width)))) 1)
                        (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (+ (- tile-height (/ tile-height 16.666)) (player-posy (world-player world))) tile-height)))) 
                                         (inexact->exact (floor (/ (- (player-posx (world-player world)) (/ tile-width 25)) tile-width)))) 1) )
                    (player-posx-set! (world-player world) (+ (player-posx (world-player world)) 0))
                    (player-posx-set! (world-player world) (- (player-posx (world-player world)) (/ tile-width 10))))))

          ;;Going Right
          (if (eq? (player-hstate (world-player world)) 'right)
              (begin
                (if (or (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (player-posy (world-player world)) tile-height)))) 
                                         (inexact->exact (floor  (/  (+ (+ tile-width (/ tile-width 10)) (player-posx (world-player world))) tile-width)))) 1)
                        (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (+ (- tile-height (/ tile-height 16.666)) (player-posy (world-player world))) tile-height)))) 
                                         (inexact->exact (floor  (/  (+ (+ tile-width (/ tile-width 10)) (player-posx (world-player world))) tile-width)))) 1))
                    (player-posx-set! (world-player world) (- (player-posx (world-player world)) 0))
                    (player-posx-set! (world-player world) (+ (player-posx (world-player world)) (/ tile-width 10))))))


          ;;Falling
          (if (or (eq? (player-vstate (world-player world)) 'idle) (eq? (player-vstate (world-player world)) 'falling))
              (begin
                (if (or (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (+ (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))) 1))
                                         (inexact->exact (floor (/ (player-posx (world-player world)) tile-width)))) 1)
                        (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (+ (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))) 1))
                                         (inexact->exact (floor (/ (+ tile-width (player-posx (world-player world))) tile-width)))) 1))
                    (begin
                      (player-vstate-set! (world-player world) 'idle)
                      (set! jumpcounter 0))
                    (begin
                      (player-posy-set! (world-player world) (+ (player-posy (world-player world)) (/ tile-height 5)))
                      (player-vstate-set! (world-player world) 'falling)))))
          
          ;;Jumping
          (if (eq? (player-vstate (world-player world)) 'jump)
              (begin
                (if (or (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))))
                                         (inexact->exact (floor (/ ( player-posx (world-player world)) tile-width)))) 1)
                        (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (player-posy (world-player world)) tile-height))))
                                         (inexact->exact (floor (/ (+ tile-width (player-posx (world-player world))) tile-width)))) 1) 
                        )
                    (player-vstate-set! (world-player world) 'falling)
                    (if (> jumpcounter (* tile-width 6))
                        (begin
                          (player-vstate-set! (world-player world) 'falling)
                          (set! jumpcounter 0))
                        (begin
                          (player-posy-set! (world-player world) (- (player-posy (world-player world)) (/ tile-width 5)))
                          (set! jumpcounter (+ jumpcounter (/ tile-width 5))))))))


          ;;Enemy Calculations
          (if (not (and (eq? (player-posx (world-player world)) (last enemyX))
                       (eq? (player-posy (world-player world)) (last enemyY))))
              (begin
                (set! enemyX (append enemyX (list (player-posx (world-player world)))))
                (set! enemyY (append enemyY (list (player-posy (world-player world)))))))

          (if (eq? enemycounter 0)
              (set! enemycounter time))

          (if (> (- time enemycounter) 1500)
              (begin
                (enemy-posx-set! (world-enemy world) (car enemyX))
                (enemy-posy-set! (world-enemy world) (car enemyY))
                (set! enemyX (cdr enemyX))
                (set! enemyY (cdr enemyY))))

          ;;Game calculations

          ;; Level Complete
          (if (eq? (player-hstate (world-player world)) 'right)
              (begin
                (if (or (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (player-posy (world-player world)) tile-height)))) 
                                         (inexact->exact (floor  (/  (+ (+ tile-width (/ tile-width 10)) (player-posx (world-player world))) tile-width)))) 2)
                        (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (+ (- tile-height (/ tile-height 16.666)) (player-posy (world-player world))) tile-height)))) 
                                         (inexact->exact (floor  (/  (+ (+ tile-width (/ tile-width 10)) (player-posx (world-player world))) tile-width)))) 2))
                    (begin
                      (set! levelcounter (+ levelcounter 1))
                      (player-posy-set! (world-player world) (* tile-width (getlevel level+ levelcounter)))
                      (player-posx-set! (world-player world) (* tile-width 2))
                      (enemy-posx-set! (world-enemy world) (- 0 tile-width))
                      (enemy-posy-set! (world-enemy world) (- 0 tile-width))
                      (set! enemyX '(0))
                      (set! enemyY '(0))
                      (set! enemycounter 0)))))

          ;; Level Back
           (if (eq? (player-hstate (world-player world)) 'left)
              (begin
                (if (or (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (player-posy (world-player world)) tile-height)))) 
                                         (inexact->exact (floor (/ (- (player-posx (world-player world)) (/ tile-width 25)) tile-width)))) 3)
                        (eq? (vector-ref (vector-ref (getlevel levellist levelcounter) (inexact->exact (floor (/ (+ (- tile-height (/ tile-height 16.666)) (player-posy (world-player world))) tile-height)))) 
                                         (inexact->exact (floor (/ (- (player-posx (world-player world)) (/ tile-width 25)) tile-width)))) 3) )
                    (begin
                      (set! levelcounter (- levelcounter 1))
                      (player-posy-set! (world-player world) (* tile-width (getlevel level- levelcounter)))
                      (player-posx-set! (world-player world) (* tile-width 49))
                      (enemy-posx-set! (world-enemy world) (- 0 tile-width))
                      (enemy-posy-set! (world-enemy world) (- 0 tile-width))
                      (set! enemyX '(0))
                      (set! enemyY '(0))
                      (set! enemycounter 0)))))
          
          ))
       world))
   (make-world
    'splash-screen
    '()
    '())))

