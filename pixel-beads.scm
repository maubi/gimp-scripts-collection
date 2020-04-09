(define (script-fu-pixel-beads img drawable factor indexed)
  (let* (
      (img-width (car (gimp-image-width img)))
      (img-height (car (gimp-image-height img)))
      (img-type (car (gimp-image-base-type img)))
  )

  (gimp-context-push)
  (gimp-image-undo-enable img)
  (gimp-image-undo-group-start img)

  (gimp-context-set-interpolation 0) ; interpolation: NONE

  ; scale down and then restore to original
  (gimp-image-scale img (/ img-width factor) (/ img-height factor))
  (gimp-image-scale img img-width img-height)

  ; optional convert to indexed for non-indexed images
  (if
    (and
        (not (= img-type 2))
        (= indexed 1)
    )
    (gimp-image-convert-indexed img 0 0 256 0 0 ""))

  (gimp-image-undo-group-end img)

  (gimp-displays-flush)
  (gimp-context-pop)
  )
) 

(script-fu-register "script-fu-pixel-beads"
  "Pixel Beads..."
  "Convert image to pixel beads"
  "Mauro Cavendish"
  "Mauro Bisiani 2020"
  "2020/04/09"
  "*"
  SF-IMAGE "Input Image"    0
  SF-DRAWABLE "Input Layer" 0
  SF-ADJUSTMENT  "Downscale Factor" '(10 2 100 1 1 0 0)
  SF-TOGGLE "Convert to 256 colors" 0
)

(script-fu-menu-register "script-fu-pixel-beads"
  "<Image>/Filters/Artistic"
)