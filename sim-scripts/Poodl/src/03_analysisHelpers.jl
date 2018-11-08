
"""
    sweep_sample(param_values; time = 250_000, agent_type = "mutating o")

this fn pressuposes an array of param_values where each column is a param and each row is a parametization;
Then it runs the sim for each parametization and pushs system measures to another array (the output array)
"""
function sweep_sample(param_values; size_nw = 500, time = 250_000, agent_type = Agent_o)
    Y = []
Meter.@showprogress 1 "Computing..." for i in 1:size(param_values)[1]
    paramfromsaltelli = PoodlParam(size_nw =  round(Int,param_values[i,1]),
                                    n_issues = round(Int,param_values[i,2]),
                                    p = param_values[i,3],
                                    σ = param_values[i,4],
                                    ρ = param_values[i,5],
                                    propintransigents = param_values[i,6],
                                    time = time,
                                    agent_type = agent_type)
        out  =  simple_run(paramfromsaltelli) |> pullidealpoints |> outputfromsim
        push!(Y,out)
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
