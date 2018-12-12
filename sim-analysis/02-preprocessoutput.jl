using Pkg

Pkg.activate("../sim-scripts/Poodl")



using Revise
using CSV, PyCall, JLD2
using Poodl
const pdl = Poodl

@pyimport SALib.analyze.sobol as sobol


#Helper fns and problem definition

discretize(x) = round(Int,x)


# Data structures from the simulation 

@load "data/ParamSweep6params.jld2" ParamSweep6params

ParamSweep6params |> typeof |> fieldnames

# @load    "data/sample5k5params.jld2" #paramvalues5k_5params 

# @load "data/saltelli5k5params.jld2" #Ysaltelli5params

# @load "data/saltellisample5000initcond.jld2" #saltelli5000_initialcond



# Turn the array initcond array into df then save it

# initYstd,initYnips = pdl.extractys(saltelli5000_initialcond)

# initcondf = pdl.DF.DataFrame(std = initYstd, nips = initYnips)

# CSV.write("data/saltelli70kinitcond.csv", initcondf)


# Create df for regression plot - 6params version

const sixparams = ParamSweep6params.paramcombdf
totaldf =  pdl.DF.DataFrame( N = map(discretize, sixparams[:size_nw]),
                             n_issues = map(discretize, sixparams[:n_issues]),
                             p = sixparams[:p],
                             σ = sixparams[:σ],
                             ρ = sixparams[:ρ],
                             p_intran = sixparams[:p_intran])

Ystd5000,Ynips5000 = pdl.extractys(ParamSweep6params.outputArray)

totaldf[:Ystd] = Ystd5000

totaldf

CSV.write("data/5000paramsandresults.csv",totaldf)


#  Create df for sobol bar plot - 5params version

Si_std = sobol.analyze(problem, Ystd5000)

delete!(Si_std, "S2"); delete!(Si_std, "S2_conf")

varcolumn=  pdl.DF.DataFrame(Var = problem["names"])

stdsi_df =  pdl.DF.hcat(varcolumn,DataFrame(Si_std))

CSV.write("data/saltelli5000std.csv", stdsi_df)

