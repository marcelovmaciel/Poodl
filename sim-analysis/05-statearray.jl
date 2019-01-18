using Pkg
Pkg.activate("../sim-scripts/Poodl")

using Revise
import Poodl
const  pdl  = Poodl


using Plots
#using StatsBase
gr(legend = false)
Plots.scalefontsizes(1.3)



using Base: product
using Lazy: lazymap, @lazy


#=

testar σ 0.02 0.04 0.06  e 0.1

testar n_issues 1,5,10

testar p★, p★★, p★★★

=#

# Array{Float}, Array{Int}, Array{Function} -> Array{pdl.Param}
function poodlparamsgen()
    σs = @lazy [0.02, 0.04, 0.06,  0.1]

    n_issues = @lazy [1, 5, 10]

    pstars = @lazy [pdl.calculatep★,
                    pdl.calculatep★★,
                    pdl.calculatep★★★]

    params = lazymap(x-> (σ = x[1], n_issues = x[2], p★calculator = x[3]),
                     (@lazy product(σs, n_issues, pstars)))

    lazymap(y-> pdl.PoodlParam(n_issues = y.n_issues,
                          σ = y.σ,
                          size_nw = 500,
                          time = 500_000,
                          p = 0.9,
                          ρ = 0.05,
                          propintransigents = 0.0,
                          p★calculator = y.p★calculator), params)
end


#emptyplots(paramslist) = lazymap(x -> plot(show = false, xlabel = "iterations",
 #                                  ylabel = "mean opinion values",
  #                                 title = "n = $(x.n_issues) ; sigma = $(x.σ)",
   #                                dpi = 200), paramslist)


params = poodlparamsgen()

collect(params) |> typeof


pdl.statesmatrix(pdl.PoodlParam())


function runandsaveplot(pa)
    simresult = pdl.statesmatrix(pa)
    fig = plot(show = false, xlabel = "iterations",
                                   ylabel = "mean opinion values",
                                   title = "n = $(pa.n_issues) ; sigma = $(pa.σ)",
                                   dpi = 200)


    pdl.Meter.@showprogress 1 "Plotting " for i in 1:pa.size_nw
        plot!(fig, simresult[:,i])
    end

    if pa.propintransigents == 0
        png("img/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.propintransigents)intrans")
        
    else
        png("img/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.intranpositions)$(pa.propintransigents)intrans")
  
    end
    fig = 0
    simresult = 0      
end


#foo = zip(params, lesplots) |> collect 


function sweepandplot(params)
    for (index,value) in enumerate(params)
        runandsaveplot(value)
        println("plot $(index) saved")
    end
end



sweepandplot(params)





