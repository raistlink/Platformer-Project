;;; Copyright (c) 2012 by Álvaro Castro Castilla
;;; Test for Cairo with OpenGL

(define screen-width 1280)
(define screen-height 752)
(define tile-width 50)
(define tile-height 50)
(define horizontal-tile-cache (+ 2  (/ screen-width tile-width)))
(define vertical-tile-cache (+ 2  (/ screen-height tile-width)))


(define-structure world gamestate)


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
                 (else
                  (SDL_LogVerbose SDL_LOG_CATEGORY_APPLICATION (string-append "Key: " (number->string key)))
                  world))))
        (else
         world))))
   (let ((posx 80.0))
     (lambda (cr time world)
       (println (string-append "time: " (object->string time) " ; world: " (object->string world)))
       ;;(SDL_LogInfo SDL_LOG_CATEGORY_APPLICATION (object->string (SDL_GL_Extension_Supported "GL_EXT_texture_format_BGRA8888")))
       (cairo_set_source_rgba cr 1.0 1.0 1.0 1.0)
       (cairo_rectangle cr 0.0 0.0 500.0 500.0)
       (cairo_fill cr)
       (cairo_arc cr posx 80.0 150.0 0.0 6.28)
       (cairo_set_source_rgba cr 0.0 0.0 1.0 1.0)
       (cairo_fill cr)
       (cairo_select_font_face cr "Sans" CAIRO_FONT_SLANT_NORMAL CAIRO_FONT_WEIGHT_BOLD)
       (cairo_set_source_rgba cr 0.0 0.0 0.0 0.8)
       (cairo_set_font_size cr 16.0)
       (cairo_move_to cr 40.0 40.0)
       (cairo_show_text cr "Scheme Fusion test: Cairo / OpenGL")
       (cairo_fill cr)
       (set! posx (+ 1.0 posx))
       world))
   (make-world
    'splash-screen)))

