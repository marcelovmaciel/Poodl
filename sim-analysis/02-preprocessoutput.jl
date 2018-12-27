using Pkg

Pkg.activate("../sim-scripts/Poodl")

using Revise
using CSV, DataFrames, JLD2
using Poodl
const pdl = Poodl


#Helper fns and problem definition

discretize(x) = round(Int,x)


# Data structures from the simulation 

@load "data/ParamSweep6params-star1.jld2" ParamSweep6params★
@load "data/ParamSweep6params-star2.jld2" ParamSweep6params★★
@load "data/ParamSweep6params-star3.jld2" ParamSweep6params★★★

simslist = [ ParamSweep6params★,
             ParamSweep6params★★,
             ParamSweep6params★★★]


# Create df for regression plot - 6params version

const sixparams = simslist[1].paramcombdf

totaldf =  pdl.DF.DataFrame( N = map(discretize, sixparams[:size_nw]),
                             n_issues = map(discretize, sixparams[:n_issues]),
                             p = sixparams[:p],
                             σ = sixparams[:σ],
                             ρ = sixparams[:ρ],
                             p_intran = sixparams[:p_intran])

Ystd5000★,Ynips5000★ = pdl.extractys(simslist[1].outputArray)
Ystd5000★★,Ynips5000★★ = pdl.extractys(simslist[2].outputArray)
Ystd5000★★★,Ynips5000★★★ = pdl.extractys(simslist[3].outputArray)

totaldf[:Ystd★] = Ystd5000★
totaldf[:Ystd★★] = Ystd5000★★
totaldf[:Ystd★★★] = Ystd5000★★★
totaldf[:Initstd ] = simslist[1].initcondmeasure

CSV.write("data/5kparamsresults.csv",totaldf)


#  Create df for sobol bar plot - 6params version
function sobolS1STcoefs(indict, output)
    Si_std = pdl.sobolanalysis(indict, output)
    delete!(Si_std, "S2"); delete!(Si_std, "S2_conf")
    
    stdsi_df =  (pdl.DF.DataFrame(Var = indict["names"])
                 |> x -> pdl.DF.hcat(x, DataFrame(Si_std)))
end

CSV.write("data/saltelli5000std-star1.csv",
          sobolS1STcoefs(simslist[1].indict, Ystd5000★))

CSV.write("data/saltelli5000std-star2.csv",
          sobolS1STcoefs(simslist[1].indict, Ystd5000★★))

CSV.write("data/saltelli5000std-star3.csv",
          sobolS1STcoefs(simslist[1].indict, Ystd5000★★★))

