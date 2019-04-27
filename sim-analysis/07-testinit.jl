using Plots
#using Plots.PlotMeasures

using Pkg
Pkg.activate("../sim-scripts/Poodl")

using Revise
import Poodl
const  pdl  = Poodl

using StatsBase
#inspectdr(legend = false)
Plots.scalefontsizes(1.3)


pa1 = pdl.PoodlParam(n_issues = 5,
                   size_nw = 500,
                   p = 0.9,
                   ρ = 1e-5,
                   propintransigents = 0.0,
                   intranpositions = "random")


pop = pdl.create_initialcond(pa1)


pdl.get_os(pop[1])

pop[1].ideo |> eltype |> fieldnames

pdl.getpropertylist(pop[1], :ideo)

@code_warntype  pdl.pulloiks(pop)

pdl.pulloiks(pop)


stdsn1 = pdl.dist_initstds(pa1, 500)



pa2 = pdl.PoodlParam(n_issues = 10,
                   size_nw = 500,
                   p = 0.9,
                   ρ = 1e-5,
                   propintransigents = 0.0,
                   intranpositions = "random")



stdsn10 = pdl.dist_initstds(pa2, 500)


