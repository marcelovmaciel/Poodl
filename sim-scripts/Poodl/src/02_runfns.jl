# Types needed for the simulation

"Parameters for the simulation; makes the code cleaner"
Param.@with_kw struct PoodlParam{R<:Real}
    n_issues::Int = 1
    size_nw::Int = 2
    p::R = 0.9
    σ::R = 0.1
    time::Int = 2
    ρ::R = 0.01
    agent_type = Agent_o
    graphcreator::Function = LG.CompleteGraph
    propintransigents::R = 0.1
    intranpositions::String = "random"
    p★calculator::Function = calculatep★
end


## Information Storing Fns
#I'm going to initialize a dataframe and update it at each time step.
"""
    create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator,
                propintransigents; intranpositions = "random")

this fn is a helper for all other fns used in the simulation
"""
function create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator,
                propintransigents; intranpositions = "random")
    pop = createpop(agent_type, σ, n_issues, size_nw)
    add_neighbors!(pop,graphcreator)
    turninto_intransigents!(pop, propintransigents, position = intranpositions)
    return(pop)
end

function create_initialcond(pa::PoodlParam)
    Param.@unpack n_issues, size_nw, p, σ, time, ρ, agent_type,graphcreator, propintransigents, intranpositions, p★calculator =pa
    create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator, propintransigents, intranpositions = intranpositions)
end



"self-describing... it takes a population and returns an array of ideal points"
function pullidealpoints(pop)
    idealpoints = Float64[]
    for agent in pop
        push!(idealpoints,agent.idealpoint)
    end
    return(idealpoints)
end


"""
    outputfromsim(endpoints::Array)
fn to turn extracted information into system measures; pressuposes an array with some system state (set of agents attributes); like the one returned by pullidealpoints
"""
function outputfromsim(endpoints::Array)
    stdpoints = Stats.std(endpoints)
    num_points = endpoints |> StatsBase.countmap |> length
    return(stdpoints,num_points)
end



"""
    function createstatearray(pop,time)

Creates an array with the agents' ideal points; it's an alternative to saving everything in a df

"""
function createstatearray(pop,time)
    statearray = Array{Array{Float64}}(undef,time+1)'
    statearray[1] = pullidealpoints(pop)
    return(statearray)
end



"""
    create_initdf(pop)

fn to initialize the df; it should store all the info I may need later.
"""
function create_initdf(pop)
    df = DF.DataFrame(time = Integer[], id  = Integer[],  ideal_point = Real[])
    for agent in pop
        time = 0 
        push!(df,[time agent.id  agent.idealpoint ]) 
    end
    return df
end


"""
    update_df!(pop,df,time)

fn to update the df with relevant information.
"""
function update_df!(pop,df,time)
    for agent in pop
        push!(df,[time  agent.id   agent.idealpoint ])
    end
end



#= Running Functions
=#

"""
    agents_update!(population,p, σ, ρ)

this executes the main procedure of the model: one pair of agents interact and another updates randomly (noise).
"""
function agents_update!(population, p, ρ, p★calculator )
    updateibelief!(rand(population),population,p, p★calculator)
    ρ_update!(rand(population), ρ)
    nothing
end


"""
    runsim!(pop,df::DataFrame,p,σ,ρ,time)
this fn runs the main procedure iteratively while updating the df;

"""
function runsim!(pop,df::DF.DataFrame,p,ρ,time, p★calculator)
   for step in 1:time
        agents_update!(pop,p,  ρ, p★calculator)
        update_df!(pop,df,step)
    end 
end

"""
    runsim!(pop,p,σ,ρ,time)

runs the main procedure iteratively then returns the final population

"""
function runsim!(pop,p,ρ,time, p★calculator)
    for step in 1:time
        agents_update!(pop, p, ρ, p★calculator)
    end
end



"repetition of the sim for some parameters;"
function one_run(pa::PoodlParam)
    Param.@unpack n_issues, size_nw, p, σ, time, ρ, agent_type,graphcreator, propintransigents, intranpositions, p★calculator =pa
    pop = create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator, propintransigents, intranpositions = intranpositions)
    df = create_initdf(pop)
    runsim!(pop,df,p,σ,ρ,time, p★calculator)
    return(df)
end
    

"""this runs the simulation without using any df;
this speeds up a lot the sim, but i can't keep track of the system state evolution;
that is, I only save the end state
"""
function simple_run(pa::PoodlParam)
    Param.@unpack n_issues, size_nw, p, σ, time, ρ, agent_type,graphcreator, propintransigents, intranpositions, p★calculator =pa
    pop = create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator, propintransigents, intranpositions = intranpositions)
    runsim!(pop,p,ρ,time, p★calculator)
    return(pop)
end


"""
    simstatesvec(pa::PoodlParam)
runs the simulation and keeps each iteration configuration (ideal points)

"""
function simstatesvec(pa::PoodlParam)
    Param.@unpack n_issues, size_nw, p, σ, time, ρ, agent_type,graphcreator, propintransigents, intranpositions, p★calculator =pa
    pop = create_initialcond(agent_type, σ, n_issues, size_nw,graphcreator, propintransigents, intranpositions = intranpositions)
    statearray = createstatearray(pop, pa.time)

    for step in 1:time
        agents_update!(pop,p, ρ, p★calculator)
        statearray[step+1] =  pop |> pullidealpoints
       end
    return(statearray)
end


"""
    statesmatrix(statearray, time, size_nw)
fn to turn the system configurations (its state) into a matrix. I need to plot the agents' time series.
Takes a lot of time (10 min for 1.000.000 iterations and 1000 agents)
"""
function statesmatrix(pa; time = pa.time, size_nw = pa.size_nw)
    a = Array{Float64}(undef, time+1,size_nw)
    statesvec = simstatesvec(pa)

   Meter.@showprogress 1 "Computing..." for (step,popstate) in enumerate(statesvec)
        for (agent_indx,agentstate) in enumerate(popstate)
            a[step,agent_indx] = agentstate
        end
    end
    return(a)
end


function get_simpleinitcond(param)
    Y = Tuple{Float64,Int64}[]
    Param.@unpack n_issues, size_nw, p, σ, time, ρ, agent_type,graphcreator, propintransigents, intranpositions, p★calculator = param
    pop = create_initialcond(agent_type, σ, n_issues,
                             size_nw,graphcreator, propintransigents,
                             intranpositions = intranpositions)
    out = pop |> pullidealpoints |> outputfromsim
    push!(Y,out)
    Ystd = Y[1][1]
    return(Ystd)
end


function initcondstds(paramvect)
    Y = Vector{Float64}(undef, length(paramvect))
    Meter.@showprogress 1 "Computing  initcond stds ..." for (index,value) in enumerate(paramvect)
        Y[index] = get_simpleinitcond(value)
    end
    return(Y)
end



