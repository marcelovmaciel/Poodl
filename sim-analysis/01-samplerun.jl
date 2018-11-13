using Pkg

Pkg.activate("sim-scripts/Poodl")


using Revise, PyCall
import Poodl
const  pdl  = Poodl



@pyimport SALib.sample.saltelli as saltelli

pdl.mkdirs("data")


problem  = Dict("num_vars" => 5,
             "names" => [ "n_issues", "p", "σ", "ρ", "p_intran"],
             "bounds" => [[1, 10],
                          [0.1, 0.99],
                          [0.01, 0.5],
                          [0.0, 0.1],
                          [0.0, 0.3]])

paramvalues5k_5params = saltelli.sample(problem, 5000)


@save  "data/sample5k5params.jld2" paramvalues5k_5params


Ysaltelli5params = sweep_sample(paramvalues5k_5params,
                                time = 1_000_000,
                                size_nw = 500,
                                agent_type = "mutating o")

@save "data/saltelli5k5params.jld2" Ysaltelli5params

println("done")
