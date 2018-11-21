using Pkg

Pkg.activate("../sim-scripts/Poodl")


using Revise
import Poodl
const  pdl  = Poodl


pdl.mkdirs("data")

problem = Dict("num_vars" => 5,
            "names" => [ "n_issues", "p", "σ", "ρ", "p_intran"],
            "bounds" => [[1, 10],
                         [0.1, 0.99],
                         [0.01, 0.5],
                         [0.0, 0.1],
                         [0.0, 0.3]])


paramvalues5k_5params = pdl.boundsdict_toparamsdf(problem)


#pdl.@save  "data/sample5k5params.jld2" paramvalues5k_5params


Ysaltelli5params = pdl.sweep_sample(paramvalues5k_5params,
                                time = 10)


# @code_warntype pdl.sweep_sample(paramvalues5k_5params, time = 10)
                  
# pdl.@save "data/saltelli5k5params.jld2" Ysaltelli5params

println("done")