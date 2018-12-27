
"""
function boundsdict_toparamsdf(boundsdict;samplesize = 5_000)

It receives a dictionary which will be used in saltelli.sample and returns a df
with the params values

The Dict ought to be of the kind:
problem = Dict("num_vars" => 5,
            "names" => [ "n_issues", "p", "σ", "ρ", "p_intran"],
            "bounds" => [[1, 10],
                         [0.1, 0.99],
                         [0.01, 0.5],
                         [0.0, 0.1],
                         [0.0, 0.3]])
"""
function boundsdict_toparamsdf(boundsdict;samplesize = 5_000)
    @pyimport SALib.sample.saltelli as saltelli
    problem_array = saltelli.sample(boundsdict,samplesize)
    foodf = DF.DataFrame()
    for (index,value) in enumerate(boundsdict["names"])
        setproperty!(foodf,Symbol(value), problem_array[:, index])
    end
    return(foodf)
end




"""
    sweep_sample(param_values; time = 250_000, agent_type = "mutating o")

this fn pressuposes an array of param_values where each column is a param and each row is a parametization;
Then it runs the sim for each parametization and pushs system measures to another array (the output array).

Let's say we have a Dict such as :

problem  = Dict("num_vars" => 5,
             "names" => [ "n_issues", "p", "σ", "ρ", "p_intran"],
             "bounds" => [[1, 10],
                          [0.1, 0.99],
                          [0.01, 0.5],
                          [0.0, 0.1],
                          [0.0, 0.3]])

Then SAlib.sample.saltelli(problem, 5000) returns an 60_000x5 Array{Float64,2}. Those are the param_values that we use as input for this function; i should refactor this to use dataframes.
"""
function sweep_sample(paramsdf; size_nw = 500, time = 250_000, agent_type = Agent_o, p★calculator = calculatep★)
    Y = Array{Tuple{Float64,Int64}}(undef, size(paramsdf[1]))
    Meter.@showprogress 1 "Running the sims..."       for i in 1:size(paramsdf)[1]
        paramfromsaltelli = PoodlParam(size_nw = round(Int, paramsdf[i, :size_nw]),
                                       n_issues = round(Int,paramsdf[i, :n_issues]),
                                       p = paramsdf[i, :p],
                                       σ = paramsdf[i,:σ],
                                       ρ = paramsdf[i, :ρ],
                                       propintransigents = paramsdf[i, :p_intran],
                                       time = time,
                                       agent_type = agent_type,
                                       p★calculator = p★calculator)
        out  =  simple_run(paramfromsaltelli) |> pullidealpoints |> outputfromsim
        Y[i] = out
    end
    return(Y)
end


function poodlparamsvec(paramsdf; time = 250_000, agent_type = Agent_o, p★calculator = calculatep★)
    Y = Array{PoodlParam{Float64}}(undef, size(paramsdf[1]))
      Meter.@showprogress 1 "Computing the params..."     for i in 1:size(paramsdf)[1]
        paramfromsaltelli = PoodlParam(size_nw =round(Int, paramsdf[i, :size_nw]),
                                       n_issues = round(Int,paramsdf[i, :n_issues]),
                                       p = paramsdf[i, :p],
                                       σ = paramsdf[i,:σ],
                                       ρ = paramsdf[i, :ρ],
                                       propintransigents = paramsdf[i, :p_intran],
                                       time = time,
                                       agent_type = agent_type,
                                       p★calculator = p★calculator)
        Y[i] = paramfromsaltelli
    end
    return(Y)
end



function paramvec_toinitialconds(paramsvec;agent_type = Agent_o)
    Y = Array{Array{typeof(agent_type())}}(undef, size(paramsvec)[1])

    Meter.@showprogress 1 "Computing initialconds..."    for (index,value) in enumerate(paramsvec)
        Y[index] = (value |> create_initialcond )
    end
    return(Y)
end



"""
    function getsample_initcond(param_values; time = 250_000, agent_type = "mutating o")
returns Initstd and Initnips (outputfromsim from initialcond)

"""
function getsample_initcond(param_values; time = 250_000, agent_type = "mutating o")

    param_values[:,1] = round.(Int,param_values[:,1])
    param_values[:,2] = round.(Int,param_values[:,2])
    Y = Tuple{Float64,Int64}[]

    Meter.@showprogress 1 "Computing..." for i in 1:size(param_values)[1]
        paramfromsaltelli = PoodlParam(size_nw = convert(Int,param_values[i,1]),
                                       n_issues = convert(Int,param_values[i,2]),
                                       p = param_values[i,3],
                                       σ = param_values[i,4],
                                       ρ = param_values[i,5],
                                       propintransigents = param_values[i,6],
                                       time = time,
                                       agent_type = agent_type)
        Param.@unpack n_issues, size_nw, p, σ, time, ρ, agent_type,graphcreator, propintransigents, intranpositions = paramfromsaltelli
        pop = create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator, propintransigents, intranpositions = intranpositions)
        out = pop |> pullidealpoints |> outputfromsim
        push!(Y,out)
    end
    return(Y)
end

"helper for analysis; it's here for DRY"
function extractys(Ypairs)
    Ystd = Float64[]
    Ynips =  Int64[]
    for i in Ypairs
        push!(Ystd,i[1])
        push!(Ynips,i[2])
    end
    return(Ystd,Ynips)
end

"""
    function sobolanalysis(problem, result)

Run sobol.analyze on the code; only to make the analysis all julian
"""
function sobolanalysis(problem, result)
    @pyimport SALib.analyze.sobol as sobol
    return(sobol.analyze(problem, result))
end



function dist_initstds(param,repetition)
    stdsout = []
Meter.@showprogress 1 "Extracting stds" for run in 1:repetition
        singlestd = get_simpleinitcond(param)
        push!(stdsout, singlestd)
    end
    return(stdsout)
end



"""
function multiruns(sigmanissues::Tuple; repetitions = 50)

    helper function to plot the box plots
"""
function multiruns(sigmanissues::Tuple; repetitions = 100) 
    pa = PoodlParam(n_issues = sigmanissues[1],
                       σ = sigmanissues[2],
                       size_nw = 500,
                       time = 1_000_000,
                       p = 0.9,
                       ρ = 1e-5,
                       propintransigents = 0.0,
                       intranpositions = "random")

    repetitionsout = Array{Float64}[]

Meter.@showprogress 1 "Multiruns"    for run in 1:repetitions
        singleout = simple_run(pa) |> pullidealpoints 
        push!(repetitionsout,singleout)
    end
    return(repetitionsout)
end


function mkdirs(filename)
    !(filename in readdir(pwd())) ? mkdir(filename) : println("dir $(filename) exists... no need to create one ")
end



"""
    ParamSweep_inout{T1 <: Dict, T2<: Array}
    description::String
    indict::T1
    paramcombdf::DF.DataFrame
    outputArray::T2
"""
struct ParamSweep_inout{T1 <: Dict, T2<: Array, T3<:Array}
    description::String
    indict::T1
    paramcombdf::DF.DataFrame
    outputArray::T2
    initcondmeasure::T3
end
