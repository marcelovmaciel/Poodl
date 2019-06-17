using Pkg
Pkg.activate("../sim-scripts/Poodl")

using Revise
import Poodl
const  pdl  = Poodl

using Plots
gr(legend = false)
Plots.scalefontsizes(1.3)
using LaTeXStrings



tseries1 = [(σ = 0.1, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 1, propintransigents = 0.0),
            (σ = 0.02, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 1, propintransigents = 0.0),
            (σ = 0.1, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 2, propintransigents = 0.0),
            (σ = 0.02, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 2, propintransigents = 0.0)]


tseries2 = [(σ = 0.1, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 5, propintransigents = 0.0),
            (σ = 0.02, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 5, propintransigents = 0.0),
            (σ = 0.04, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 5, propintransigents = 0.0)]

tseries3 = [(σ = 0.1, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 5, propintransigents = 0.0),
            (σ = 0.02, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 5, propintransigents = 0.0),
            (σ = 0.06, p★calculator = pdl.calculatep★★★, ρ = 0.05, n_issues = 5, propintransigents = 0.0)]

tseries4 = [(σ = 0.1, p★calculator = pdl.calculatep★★★, ρ = 1e-5, n_issues = 5, propintransigents = 0.0),
            (σ = 0.1, p★calculator = pdl.calculatep★, ρ = 1e-5, n_issues = 5, propintransigents = 0.0),
            (σ = 0.1, p★calculator = pdl.calculatep★, ρ = 1e-5, n_issues = 10, propintransigents = 0.0),
            (σ = 0.1, p★calculator = pdl.calculatep★★★, ρ = 1e-5, n_issues = 10, propintransigents = 0.0),]

tseries5 = [(σ = 0.02, p★calculator = pdl.calculatep★★★, ρ = 1e-5, n_issues = 5, propintransigents = 0.0),
            (σ = 0.02, p★calculator = pdl.calculatep★, ρ = 1e-5, n_issues = 5, propintransigents = 0.0)]


tseries6 = [(σ = 0.06, p★calculator = pdl.calculatep★★★, ρ = 1e-5, n_issues = 1, propintransigents = 0.0),
            (σ = 0.06, p★calculator = pdl.calculatep★★★, ρ = 1e-5, n_issues = 5, propintransigents = 0.0),
            (σ = 0.06, p★calculator = pdl.calculatep★★★, ρ = 1e-5, n_issues = 10, propintransigents = 0.0)]


poodlparamgen(foo) = map(y-> pdl.PoodlParam(n_issues = y.n_issues,
                                           σ = y.σ,
                                           size_nw = 500,
                                           time = 500_000,
                                           p = 0.9,
                                           ρ = y.ρ,
                                           propintransigents = y.propintransigents,
                                           intranpositions = "random",
                                           p★calculator = y.p★calculator), foo)


function poodlparamgen_forts3(foo)
    map(y-> pdl.PoodlParam(n_issues = y.n_issues,
                          σ = y.σ,
                          size_nw = 500,
                          time = 500_000,
                          p = 0.9,
                          ρ = (sqrt(y.n_issues) * y.ρ),
                          propintransigents = y.propintransigents,
                          intranpositions = "random",
                          p★calculator = y.p★calculator), foo)
end


ts1params = poodlparamgen(tseries1)
ts2params = poodlparamgen(tseries2)
ts3params = poodlparamgen_forts3(tseries3)
ts4params = poodlparamgen(tseries4)
ts5params = poodlparamgen(tseries5)
ts6params = poodlparamgen(tseries6)

function pstartitle(p::Function)
    if p == pdl.calculatep★
        "p*"
    elseif p == pdl.calculatep★★
        "p**"
    else
        "p***"
    end
end

map(foobar -> pdl.mkdirs("img/statearray-stuff/$(foobar)/"), ["tseries1", "tseries2", "tseries3"])

pdl.mkdirs("img/statearray-stuff/tseries4")
pdl.mkdirs("img/statearray-stuff/tseries5")
pdl.mkdirs("img/statearray-stuff/tseries6")

function runandsaveplot(pa, whichts)
    
    
    if pa.n_issues > 1

        simresult1 = pdl.statesmatrix(pa, pullfn = pdl.pullidealpoints)
        fig1 = plot(show = false, xlabel = "iterations",
                    ylabel = "mean opinion values",
                    title = (pstartitle(pa.p★calculator) *
                             "  ; n = $(pa.n_issues) ; sigma = $(pa.σ) "),
                    dpi = 200)

        pdl.Meter.@showprogress 1 "Plotting " for i in 1:pa.size_nw
            plot!(fig1, simresult1[:,i], linealpha = 0.2)
        end

        if pa.propintransigents == 0
            png("img/statearray-stuff/$(whichts)/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.propintransigents)intrans" * pa.intranpositions )
        
        else
            png("img/statearray-stuff/$(whichts)/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.intranpositions)$(pa.propintransigents)intrans" * pa.intranpositions )
            
        end

        fig1 = 0
        simresult1 = 0      

        simresult2 = pdl.statesmatrix(pa, pullfn = pdl.pullostds)
        fig2 = plot(show = false, xlabel = "iterations",
                    ylabel = "standard deviation of opinion values",
                    title = (pstartitle(pa.p★calculator) *
                             "  ; n = $(pa.n_issues) ; sigma = $(pa.σ) "),
                    dpi = 200)


        pdl.Meter.@showprogress 1 "Plotting " for i in 1:pa.size_nw
            plot!(fig2, simresult2[:,i], linealpha = 0.2)
        end
        
        if pa.propintransigents == 0
            png("img/statearray-stuff/$(whichts)/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.propintransigents)intrans" * pa.intranpositions * "-std")
        
        else
            png("img/statearray-stuff/$(whichts)/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.intranpositions)$(pa.propintransigents)intrans" * pa.intranpositions * "-std")
            
        end
        fig2 = 0
        simresult2 = 0      
    else
        simresult1 = pdl.statesmatrix(pa, pullfn = pdl.pullidealpoints)
        fig1 = plot(show = false, xlabel = "iterations",
                    ylabel = "mean opinion values",
                    title = (pstartitle(pa.p★calculator) *
                             "  ; n = $(pa.n_issues) ; sigma = $(pa.σ) "),
                    dpi = 200)


        pdl.Meter.@showprogress 1 "Plotting " for i in 1:pa.size_nw
            plot!(fig1, simresult1[:,i], linealpha = 0.2)
    end

        if pa.propintransigents == 0
            png("img/statearray-stuff/$(whichts)/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.propintransigents)intrans" * pa.intranpositions )
        
        else
            png("img/statearray-stuff/$(whichts)/$(pa.p★calculator)n$(pa.n_issues)-rho$(pa.ρ)-sigma$(pa.σ)-$(pa.intranpositions)$(pa.propintransigents)intrans" * pa.intranpositions)
            
        end
        fig1 = 0
        simresult1 = 0
    end
end



function sweepandplot(params, whichts)
    for (index,value) in enumerate(params)
        runandsaveplot(value, whichts)
        println("plot $(index) saved")
    end
end


sweepandplot(ts1params,  "tseries1")
sweepandplot(ts2params, "tseries2")
sweepandplot(ts3params, "tseries3")
sweepandplot(ts4params, "tseries4")
sweepandplot(ts5params, "tseries5")
sweepandplot(ts6params, "tseries6")
