(TeX-add-style-hook
 "poodl-paper"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("xcolor" "table" "xcdraw") ("babel" "american") ("inputenc" "latin1") ("biblatex" "backend=biber")))
   (TeX-run-style-hooks
    "latex2e"
    "article"
    "art10"
    "xcolor"
    "babel"
    "inputenc"
    "graphicx"
    "booktabs"
    "float"
    "subcaption"
    "indentfirst"
    "biblatex")
   (LaTeX-add-labels
    "eq:oupdate"
    "eq:pstar"
    "fig:std"
    "fig:oik"
    "fig:sobol"
    "fig:scatters"
    "fig:tseries1"
    "fig:tseries2"
    "fig:tseries3"
    "fig:tseries4"
    "fig:tseries5"
    "fig:tseries6")
   (LaTeX-add-bibliographies))
 :latex)

