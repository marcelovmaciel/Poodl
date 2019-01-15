
using Plots
#using Plots.PlotMeasures

using Pkg
Pkg.activate("../sim-scripts/Poodl")

using Revise
import Poodl
const  pdl  = Poodl

using StatsBase, CategoricalArrays
inspectdr(legend = false)

out = pdl.multiruns((1,0.02))


meanout(multirunout) = reduce((x,y)->broadcast(+,x,y),multirunout)/length(multirunout)

meanpop = meanout(out)

pa = pdl.PoodlParam(n_issues = 1, σ = 0.01,
                   size_nw = 500,
                   time = 500_000,
                   p = 0.9,
                   ρ = 1e-5,
                   propintransigents = 0.0,
                   intranpositions = "extremes")

#endpop = pdl.simple_run(pa);

#histfit = (meanpop |>
 #          x->(fit(Histogram,x,
  #                 closed = :left)))

#histfit.weights

#plot(histfit)

fig = plot(show = false, xlabel = "iterações",
           ylabel = "valores dos pontos ideais");

pa_to_states = pdl.statesmatrix(pa)

pa_to_states


for i in 1:pa.size_nw
    plot!(fig, pa_to_states[:,i])
end

gui()

