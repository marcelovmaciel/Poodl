using Pkg
Pkg.activate("../sim-scripts/Poodl")

using Revise
import Poodl
const  pdl  = Poodl


using Plots
using StatsBase
gr(legend = false)
Plots.scalefontsizes(1.3)




#testar σ 0.02 0.04 0.06  e 0.1

pa = pdl.PoodlParam(n_issues = 1,
                    σ = 0.14,
                    size_nw = 500,
                    time = 500_000,
                    p = 0.9,
                    ρ = 0.05,
                    propintransigents = 0.0,
                    intranpositions = "random")

fig = plot(show = false, xlabel = "iterations",
           ylabel = "mean opinion values",
           title = "n = $(pa.n_issues) ; sigma = $(pa.σ)",
           dpi = 200)

pa_to_states = pdl.statesmatrix(pa)
 


pdl.Meter.@showprogress 1 "Plotting " for i in 1:pa.size_nw
    plot!(fig, pa_to_states[:,i])
end


if pa.propintransigents > 0.0
    png("img/n$(pa.n_issues)-rho$(pa.ρ)-$(pa.intranpositions)$(pa.propintransigents)intrans")
else
    png("img/n$(pa.n_issues)-rho$(pa.ρ)-$(pa.propintransigents)intrans")
end

println("done")

