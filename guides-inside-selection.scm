(define (draw-v-guide img x step max) 
  (if (< x max)
      (begin
          (gimp-image-add-vguide img x)
          (draw-v-guide img (+ x step) step max)
      )
  )
)

(define (draw-h-guide img y step max) 
  (if (< y max)
      (begin
          (gimp-image-add-hguide img y)
          (draw-h-guide img (+ y step) step max)
      )
  )
)

(define (script-fu-guides-inside-selection img drawable factor)
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
      (wstep (/ width factor))
      (hstep (/ height factor))
  )

  (gimp-context-push)
  (gimp-image-undo-enable img)
  (gimp-image-undo-group-start img)

  (draw-v-guide img x1 wstep x2)
  (draw-h-guide img y1 hstep y2)

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
  SF-ADJUSTMENT  "Split factor" '(2 2 10 1 1 0 0)
)

(script-fu-menu-register "script-fu-guides-inside-selection"
  "<Image>/Image/Guides"
)