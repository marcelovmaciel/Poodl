using Pkg

##Pkg.activate("./")
Pkg.activate("../sim-scripts/Poodl")


using Revise
using JLD2
import Poodl
const  pdl  = Poodl



pdl.mkdirs("data")

problem = Dict("num_vars" => 6,
            "names" => [ "size_nw",
                         "n_issues", "p", "σ", "ρ", "p_intran"],
            "bounds" => [[500, 5000],
                         [1, 10],
                         [0.1, 0.99],
                         [0.01, 0.5],
                         [0.0, 0.1],
                         [0.0, 0.3]])


paramvalues5k_6params = pdl.boundsdict_toparamsdf(problem) 


#pdl.@save  "data/sample5k5params.jld2" paramvalues5k_5params


poodlvect = pdl.poodlparamsvec(paramvalues5k_6params, 1_000_000);

#initialconds = pdl.paramvec_toinitialconds(poodlvect)


Ysaltelli6params = pdl.sweep_sample(paramvalues5k_6params,
                                time = 1_000_000);


# @code_warntype pdl.sweep_sample(paramvalues5k_5params, time = 10)
                  
# pdl.@save "data/saltelli5k5params.jld2" Ysaltelli5params
 
ParamSweep6params = pdl.ParamSweep_inout("Six parameters and sample of 5k", problem,
                                     paramvalues5k_6params, Ysaltelli6params)

@save "data/ParamSweep6params.jld2" ParamSweep6params



println("done")




