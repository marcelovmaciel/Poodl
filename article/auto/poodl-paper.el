(TeX-add-style-hook
 "poodl-paper"
 (lambda ()
   (setq TeX-command-extra-options
         "-shell-escape")
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("babel" "american") ("inputenc" "latin1")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "babel"
    "inputenc"
    "graphicx")
   (LaTeX-add-bibliographies
    "poodl-refs"))
 :latex)

