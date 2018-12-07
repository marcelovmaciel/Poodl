using Pkg

##Pkg.activate("./")
Pkg.activate("../sim-scripts/Poodl")


using Revise
import Poodl
const  pdl  = Poodl


struct ParamSweep_inout{T1 <: Dict, T2<: Array}
    description::String
    indict::T1
    paramcombdf::pdl.DF.DataFrame
    outputArray::T2
end


pdl.mkdirs("data")

problem = Dict("num_vars" => 5,
            "names" => [ "n_issues", "p", "σ", "ρ", "p_intran"],
            "bounds" => [[1, 10],
                         [0.1, 0.99],
                         [0.01, 0.5],
                         [0.0, 0.1],
                         [0.0, 0.3]])


paramvalues5k_5params = pdl.boundsdict_toparamsdf(problem, samplesize = 10)


#pdl.@save  "data/sample5k5params.jld2" paramvalues5k_5params

@time pdl.sweep_sample(paramvalues5k_5params,
                                time = 1);

@time poodlvect = pdl.poodlparamsvec(paramvalues5k_5params,
                                     time = 1);


poodlvect = pdl.poodlparamsvec(paramvalues5k_5params,
                                time = 1);
poodlvect[1] |> pdl.simple_run


@time Yout = pdl.altsweep(poodlvect);

@time Yout = pdl.altsweep(poodlvect)

@code_warntype Yout = pdl.altsweep(poodlvect)

@time Ysaltelli5params = pdl.sweep_sample(paramvalues5k_5params,
                                time = 1000);


# @code_warntype pdl.sweep_sample(paramvalues5k_5params, time = 10)
                  
# pdl.@save "data/saltelli5k5params.jld2" Ysaltelli5params
 
ParamSweep5params = ParamSweep_inout("Five parameters and sample of 5k",
                                     problem, paramvalues5k_5params, Ysaltelli5params)

@code_warntype foofunc(poodlvect[1])
ParamSweep5params |> typeof |> fieldnames

@code_warntype poodlvect |> pdl.altsweep3

@time Yinitial = poodlvect |> pdl.altsweep3;


Yinitial |> typeof


Yinitial[1]


println("done")



@time paramvalues5k_5params |> x -> pdl.poodlparamsvec(x,time = 1) |> pdl.paramvec_toinitialconds;
