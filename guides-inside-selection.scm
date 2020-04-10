(define (draw-v-guide img x step max) 
  (if (<= x (+ max 1))
      (begin
          (gimp-image-add-vguide img x)
          (draw-v-guide img (+ x step) step max)
      )
  )
)

(define (draw-h-guide img y step max) 
  (if (<= y (+ max 1))
      (begin
          (gimp-image-add-hguide img y)
          (draw-h-guide img (+ y step) step max)
      )
  )
)

(define (script-fu-guides-inside-selection img drawable factor-v factor-h)
  (let* (
      ;(img-width (car (gimp-image-width img)))
      ;(img-height (car (gimp-image-height img)))
      (boundaries (gimp-selection-bounds img))
      (selection (car boundaries))
      (x1 (cadr boundaries))
      (y1 (caddr boundaries))
      (x2 (cadr (cddr boundaries)))
      (y2 (caddr (cddr boundaries)))
      (width (- x2 x1))
      (height (- y2 y1))
      (step-v (/ width factor-v))
      (step-h (/ height factor-h))
  )

  (gimp-context-push)
  (gimp-image-undo-enable img)
  (gimp-image-undo-group-start img)

  (draw-v-guide img x1 step-v x2)
  (draw-h-guide img y1 step-h y2)

  (gimp-image-undo-group-end img)

  (gimp-displays-flush)
  (gimp-context-pop)
  )
) 

(script-fu-register "script-fu-guides-inside-selection"
  "Guides inside selection..."
  "Create guides inside a selection"
  "Mauro  Cavendish"
  "Mauro Bisiani 2020"
  "2020/04/09"
  "*"
  SF-IMAGE "Input Image"    0
  SF-DRAWABLE "Input Layer" 0
  SF-ADJUSTMENT  "Vertical Step" '(2 2 10 1 1 0 0)
  SF-ADJUSTMENT  "Horizontal Step" '(2 2 10 1 1 0 0)
)

(script-fu-menu-register "script-fu-guides-inside-selection"
  "<Image>/Image/Guides"
)