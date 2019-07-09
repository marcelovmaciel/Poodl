using Pkg
Pkg.activate("../sim-scripts/Poodl")

using Revise
import Poodl
const  pdl  = Poodl

using Plots
gr(legend = false)
Plots.scalefontsizes(1.3)
using LaTeXStrings

using Base: product
using Lazy: lazymap, @lazy




σs = [ 0.02  0.1 ]
n_issues = [2]
pstars = [pdl.calculatep★★★]

#[pdl.calculatep★, pdl.calculatep★★,
          
ρs = [0.05]

#initialrho = 0.05
#pintran = 0.0

pintrans = [0.0]
intranpositions = ["random"]

(prod ∘  (x -> length.(x) ) )([σs, n_issues,pstars, ρs, pintrans, intranpositions])

# Array{Float}, Array{Int}, Array{Function} -> Array{pdl.Param}

function poodlparamsgen(σs, n_issues, pstars, ρs, pintrans, intranpositions)

    params = lazymap(x-> (σ = x[1], n_issues = x[2], p★calculator = x[3],
                         ρ = x[4], propintransigents = x[5], intranpositions = x[6]),
                     (@lazy product(σs, n_issues, pstars,
                                    ρs, pintrans, intranpositions)))

    lazymap(y-> pdl.PoodlParam(n_issues = y.n_issues,
                              σ = y.σ,
                              size_nw = 500,
                              time = 500_000,
                              p = 0.9,
                              ρ = y.ρ,
                              propintransigents = y.propintransigents,
                              intranpositions = y.intranpositions,
                              p★calculator = y.p★calculator), params)
end


function pstartitle(p::Function)
    if p == pdl.calculatep★
        "p*"
    elseif p == pdl.calculatep★★
        "p**"
    else
        "p***"
    end
end



function poodlparamsgen(σs, n_issues, pstars, initialrho, pintran)
 
    foo  = lazymap(x-> (σ = x[1], n_issues = x[2], p★calculator = x[3]),
                     (@lazy product(σs, n_issues, pstars)))

    bar = []

    for t in foo
        newrho = initialrho * sqrt(t.n_issues)
        push!(bar, newrho)
    end
    params  = zip(foo, bar)  |> z -> map(x-> (σ = x[1].σ,
                                           n_issues =  x[1].n_issues,
                                           p★calculator = x[1].p★calculator,
                                           ρ = x[2]), z)

    lazymap(y-> pdl.PoodlParam(n_issues = y.n_issues,
                          σ = y.σ,
                          size_nw = 500,
                          time = 500_000,
                          p = 0.9,
                          ρ = y.ρ,
                          propintransigents = pintran,
                          p★calculator = y.p★calculator), params)
end




params = poodlparamsgen(σs, n_issues, pstars, ρs, pintrans, intranpositions)


simresult = pdl.simstatesvec2(params[1], pullfn = pdl.pulloiks)


