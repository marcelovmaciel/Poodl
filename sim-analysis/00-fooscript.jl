using Pkg
Pkg.activate("../sim-scripts/Poodl")
using DataFrames

problem = Dict("num_vars" => 5,
            "names" => [ "n_issues", "p", "σ", "ρ", "p_intran"],
            "bounds" => [[1, 10],
                         [0.1, 0.99],
                         [0.01, 0.5],
                         [0.0, 0.1],
                         [0.0, 0.3]])
using PyCall

@pyimport SALib.sample.saltelli as saltelli


paramsdf = boundsdict_toparamsdf(problem)




@load "data/ParamSweep6params.jld2" ParamSweep6params


ParamSweep6params |>  typeof |> fieldnames



ParamSweep6params.outputArray
