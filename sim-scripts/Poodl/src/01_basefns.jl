#Structs for Agents and Beliefs --------------------

#Those abstract types are for later refactoring
abstract type  AbstractAgent end
#abstract type AbstractBelief end
#abstract type AgentAttribute end

"Concrete type for Agents' beliefs; comprised of opinion, uncertainty and an id (whichissue)"
mutable struct Belief{T1 <: Real, T2 <: Integer}
    o::T1
    σ::T1
    whichissue::T2
end


"""
    mutable struct Agent_o{T1 <: Integer, T2 <: Vector, T3 <: Real,
                       T4 <: Vector, T5 <: Tuple} <: AbstractAgent

Concrete type for an Agent which only change its opinion.

Fields:
 - id::Integer
 - ideo:: Vector
 - idealpoint::Real
 - neighbors::Vector
 - certainissues::Vector
 - certainparams::NamedTuple

"""
mutable struct Agent_o{T1 <: Integer, T2 <: Vector, T3 <: Real,
                       T4 <: Vector, T5 <: NamedTuple} <: AbstractAgent
    id::T1
    ideo::T2
    idealpoint::T3
    neighbors::T4
    certainissues::T4
    certainparams::T5
end


mutable struct Agent_oσ{T1 <: Integer, T2 <: Vector, T3 <: Real,
                       T4 <: Vector, T5 <: NamedTuple} <: AbstractAgent
    id::T1
    ideo::T2
    idealpoint::T3
    neighbors::T4
    certainissues::T4
    certainparams::T5
end

"Belief(σ::T1, whichissue::T2,
         paramtuple::T3) where {T1 <: Real, T2 <: Integer, T3 <: NamedTuple}"
function Belief(σ::T1, whichissue::T2,
         paramtuple::T3) where {T1 <: Real, T2 <: Integer, T3 <: NamedTuple}
    #maybe this should be inside the constructor ?? think about that...
    (0 < σ <= 1) || throw(DomainError(σ, "σ must be between 0 and 1"))
    o = rand(Dist.Beta(paramtuple.α,paramtuple.β))
    return(Belief(o, σ, whichissue))
end

"Agent_oσ(n_issues::Tint, id::Tint, σ::Treal,
           paramtuple::TNT) where {Tint <: Integer, Treal <: Real, TNT <: NamedTuple}"
function Agent_oσ(n_issues::Tint, id::Tint, σ::Treal,
           paramtuple::TNT) where {Tint <: Integer, Treal <: Real, TNT <: NamedTuple}
    ideology = [Belief(σ, issue, paramtuple) for issue in 1:n_issues ]
    idealpoint = calculatemeanopinion(ideology)
    return(Agent_oσ(id,ideology, idealpoint,[0], [0], paramtuple))
end



"Agent_o(n_issues::Tint, id::Tint, σ::Treal,
           paramtuple::TNT) where {Tint <: Integer, Treal <: Real, TNT <: NamedTuple}"
function Agent_o(n_issues::Tint, id::Tint, σ::Treal,
           paramtuple::TNT) where {Tint <: Integer, Treal <: Real, TNT <: NamedTuple}
    ideology = [Belief(σ, issue, paramtuple) for issue in 1:n_issues ]
    idealpoint = calculatemeanopinion(ideology)
    return(Agent_o(id,ideology, idealpoint,[0], [0], paramtuple))
end


Agent_o() = Agent_o(1,1,0.1,(α = 1.1, β = 1.1))
Agent_oσ() = Agent_oσ(1,1,0.1,(α = 1.1, β = 1.1))


"""
     createbetaparams(popsize::Integer)

Creates a list of parameters for posterior instantiation of Belief
"""
function createbetaparams(popsize::Integer)
    popsize >= 2 || throw(DomainError(popsize, "popsize must be at least 2"))
    αs = range(1.1,  length = popsize , stop = 100) |> RD.shuffle
    βs = range(1.1, length = popsize , stop = 100) |> RD.shuffle
    betaparams = zip(αs,βs) |> x -> [(α = i[1], β = i[2]) for i in x]
end


#=
this functions generalizes what i was previously doing with create_idealpoint.
That is, with createidealpoint i apply some measure to a list of attributes from the items of another list.
The latter is what this fn does.
=#
"This fn extracts a list of properties from another list.
If we have a container of composite types with field :o it will return a list of the :os."
function getpropertylist(list::Vector, whichproperty::Symbol)
    ((fieldcount(eltype(list)) > 0) ||
      throw(ArgumentError( "can't get a propertyfrom a type without fields ")))
    apropertylist = similar(list, fieldtype(eltype(list), whichproperty))
    for (keys, values) in enumerate(list)
       apropertylist[keys] = getfield(values, whichproperty)
    end
    return(apropertylist)
end

"calculatemeanopinion(ideology) = getpropertylist(ideology, :o) |> Stats.mean"
calculatemeanopinion(ideology) = getpropertylist(ideology, :o) |> Stats.mean


"""
    createpop(agent_type::Type{Agent_o}, σ::Real,
    n_issues::Integer, size::Integer)::Vector{Agent_o}

Creates a  vector of agents of type Agent_o
"""
function createpop(agent_type,
            σ::Real,  n_issues::Integer, size::Integer)
    betaparams = createbetaparams(size)
    population = Array{typeof(agent_type())}(undef, size)
    for i in 1:size
        population[i] = agent_type(n_issues, i,σ, betaparams[i])
    end
    return(population)
end


"""
    function pick_intranids(pop,propintransigents::AbstractFloat; position = "random")::Vector{Int}
"""
function pick_intranids(pop,propintransigents::AbstractFloat; position = "random")::Vector{Int}
    nintransigents = round(Int, length(pop) * propintransigents)
    if position == "random"
        whichintransigents = StatsBase.sample(1:length(pop), nintransigents,
                                replace = false)
    elseif position == "extremes"
        # gives an error if nintransigents > len(extremistsid)
        extremistsid = map( x -> x.id,
                            filter(x -> ( x.idealpoint < 0.2) || (x.idealpoint > 0.8),
                                   pop))
        if nintransigents > length(extremistsid)
            throw(ArgumentError("there aren't enough agents on the extremes; try a lower prop_intran"))
            else
            whichintransigents  = StatsBase.sample(extremistsid, nintransigents,
                                         replace = false)
        end
    elseif position == "center"
        centristsid = map( x -> x.id,
                            filter(x -> ( x.idealpoint > 0.25) && (x.idealpoint < 0.75),
                                   pop))
        if nintransigents > length(centristsid)
            throw(ArgumentError("there aren't enough agents on the center; try a lower prop_intran"))
        else
            whichintransigents = StatsBase.sample(centristsid,nintransigents,
                                        replace = false)
        end
    else
        throw(ArgumentError("wrong position; correct: random,extremes,center"))
    end 
    return(whichintransigents)
end

"""
    turninto_intransigents!(pop,propextremists::AbstractFloat)

turn some agents into extremists; that is, given a number or proportion of extremists and issues it makes the σ of some issues and some agents into ≈ 0 (1e-20)
"""
function turninto_intransigents!(pop,propintransigents::AbstractFloat; position = "random")
    n_issues = length(pop[1].ideo)
    whichintransigents = pick_intranids(pop, propintransigents::AbstractFloat; position = position)

    for i in whichintransigents
        whichissues = StatsBase.sample(1:n_issues, 1,
                             replace = false)
        pop[i].certainissues = whichissues
        for issue in whichissues
            pop[i].ideo[issue].σ = 1e-20
        end
    end
    nothing
end

function turninto_intransigents(pop,propintransigents::AbstractFloat; position = "random")
    n_issues = length(pop[1].ideo)
    whichintransigents = pick_intranids(pop, propintransigents::AbstractFloat; position = position)
    
    likepop = copy(pop)
    for i in whichintransigents
        whichissues = StatsBase.sample(1:n_issues, 1,
                             replace = false)
        likepop[i].certainissues = whichissues
        for issue in whichissues
            likepop[i].ideo[issue].σ = 1e-20
        end
    end
    return(likepop)
end

#those graph fns should probably be refactored ... 
"""
    creategraphfrompop(population, graphcreator)

Creates a graph; helper for add_neighbors!
"""
function creategraphfrompop(population, graphcreator::Function)
    graphsize = length(population)
    nw = graphcreator(graphsize)
end

"""
    add_neighbors!(population, nw)

adds the neighbors from nw to pop;
"""
function add_neighbors!(population, graphcreator::Function)
    neighsids = creategraphfrompop(population,
                                   graphcreator).fadjlist
    for (key, value) in enumerate(neighsids)
        population[key].neighbors = value
    end
    nothing
end

#= Interaction functions
=#

"""
    getjtointeract(i::AbstractAgent,  population)
Chooses and returns a neighbor for i
"""
function getjtointeract(i::AbstractAgent,  population)
    whichj = rand(i.neighbors)
    j = population[whichj]
end

"""
    pick_issuebelief(i::AbstractAgent, j::AbstractAgent)

Takes two agents and returns a tuple with:
 * which issue they discuss
 * i and j beliefs
"""
function pick_issuebelief(i::AbstractAgent, j::AbstractAgent, whichissue::Int)
    i_belief = i.ideo[whichissue]
    j_belief = j.ideo[whichissue]
    return(i_belief, j_belief)::Tuple{Belief{Float64, Int64},Belief{Float64,Int64}}
end

changing_term★(i,j,i_belief,j_belief) = (-((i_belief.o - j_belief.o)^2 / (2*i_belief.σ^2)))
changing_term★★(i,j,i_belief,j_belief) = (-((i.idealpoint - j.idealpoint)^2 / (2*i_belief.σ^2)))
changing_term★★★(i,j,i_belief,j_belief) = (-((i.idealpoint - j_belief.o)^2 / (2*i_belief.σ^2)))

function calculate_pstar(i::AbstractAgent, j::AbstractAgent,
               whichissue::Int, p::AbstractFloat, termcalculator::Function)
    i_belief,j_belief = pick_issuebelief(i, j, whichissue)
    cterm =  termcalculator(i,j,i_belief,j_belief) 
    num = p * (1 / (sqrt(2 * π ) * i_belief.σ ) ) * exp(cterm)
    denom = num + (1 - p)
    pstar  = num / denom
    return(pstar)
end

calculatep★(i, j, whichissue, p) = calculate_pstar(i, j, whichissue, p, changing_term★)
calculatep★★(i, j, whichissue, p) = calculate_pstar(i, j, whichissue, p, changing_term★★)
calculatep★★★(i, j, whichissue, p) = calculate_pstar(i, j, whichissue, p, changing_term★★★)



"""
    calc_posterior_o(i_belief::Belief, j_belief::Belief, p::AbstractFloat)

Helper for update_step
Input = beliefs in an issue and confidence paramater; Output = i new opinion
"""
calc_posterior_o(i_belief::Belief, j_belief::Belief, p★::AbstractFloat) = (p★ *
                                                         ((i_belief.o + j_belief.o) / 2) +
                                                         (1 - p★) * i_belief.o )
"""
    calc_pos_uncertainty(i_belief::Belief, j_belief::Belief, p::AbstractFloat)
helper for update_step
"""
calc_pos_uncertainty(i_belief::Belief, j_belief::Belief,
                     p★::AbstractFloat) = (sqrt(i_belief.σ^2 *
                                                ( 1 - pₚ/2) +
                                                pₚ *
                                                (1 - pₚ) *
                                                ((i_belief.o - j_belief.o)/2)^2))


"""
    update_o!(i::AbstractAgent, which_issue::Integer, posterior_o::AbstractFloat)

 update_step for changing opinion but not belief

"""
function update_o!(i::AbstractAgent, which_issue::Integer, posterior_o::AbstractFloat)
    i.ideo[which_issue].o = posterior_o
    newidealpoint = calculatemeanopinion(i.ideo)
    i.idealpoint = newidealpoint
    nothing
end

"""
    update_oσ!(i::AbstractAgent,issue_belief::Integer, posterior_o::AbstractFloat, posterior_σ::AbstractFloat)

update_step for the version with changing opinions and changing uncertainty
"""
function update_oσ!(i::AbstractAgent,issue_belief::Integer, 
        posterior_o::AbstractFloat, posterior_σ::AbstractFloat)
    i.ideo[issue_belief].o = posterior_o
    i.ideo[issue_belief].σ = posterior_σ
    newidealpoint = calculatemeanopinion(i.ideo)
    i.idealpoint = newidealpoint
    nothing
end

"""
    updateibelief!(i::Agent_o, population, p::AbstractFloat )

Main update fn; has two methods depending on the agent type

"""
function updateibelief!(i::Agent_o, population,
                 p::AbstractFloat, ★calculator::Function)
    whichissue= rand(1:length(i.ideo))
    j = getjtointeract(i,population)
    ibelief,jbelief = pick_issuebelief(i,j,whichissue)
    p★ = ★calculator(i, j, whichissue, p)
    pos_o = calc_posterior_o(ibelief,jbelief, p★)
    update_o!(i,whichissue,pos_o)
    nothing
end

function updateibelief!(i::Agent_oσ, population,
                 p::AbstractFloat, ★calculator::Function)
    whichissue= rand(1:length(i.ideo))
    j = getjtointeract(i,population)
    ibelief,jbelief = pick_issuebelief(i,j,whichissue)
    p★ = ★calculator(i, j, whichissue, p)
    pos_o = calc_posterior_o(ibelief,jbelief, p★)
    pos_σ = calc_pos_uncertainty(ibelief, jbelief, p★)
    update_oσ!(i, whichissue,pos_o, pos_σ)
    nothing
end

"""
    ρ_update!(i::AbstractAgent,  σ::AbstractFloat, ρ::AbstractFloat)

fn for noise updating; note it returns a randomly taken o(t+1) = o(t) + r,  but the new σ is the initial one
"""
function ρ_update!(i::AbstractAgent, ρ::AbstractFloat)
    whichissue = rand(1:length(i.ideo))
    r =  rand(Dist.Normal(0,ρ))
    if (i.ideo[whichissue].σ != 1e-20)
        if i.ideo[whichissue].o + r > 1.0
            i.ideo[whichissue].o = 1.0
        elseif i.ideo[whichissue].o + r < 0.0
            i.ideo[whichissue].o = 0.0
        else
            i.ideo[whichissue].o += r
        end
        newidealpoint = calculatemeanopinion(i.ideo)
        i.idealpoint = newidealpoint
    end
    nothing
end


