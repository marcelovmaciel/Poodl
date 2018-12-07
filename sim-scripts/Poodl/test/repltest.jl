using Pkg
Pkg.activate("../")


using Revise
using Poodl
const  pdl  = Poodl

@code_warntype pdl.createbetaparams(5)

pdl.create_belief(0.1,1, (α = 0.5, β = 0.6))

#stable
@code_warntype fill(5.0, (3, 3))

function array3(fillval, N)
           fill(fillval, ntuple(d->3, N))
end
#unstable

@code_warntype  array3(5.0, 2)



pdl.createbetaparams(5)

testAgent = pdl.Agent_o(1, [], 0.5, [2,3,4], [1,2,3], (α =1.1, β = 1.4)) 

ideology = [pdl.create_belief(0.1, 1, (α = 0.5, β = 0.6)) for issue in 1:5 ]

ideology |> eltype |> x -> fieldtype(x, :o)

pdl.Agent_o <: pdl.AbstractAgent

@code_warntype pdl.calculatemeanopinion(ideology)

pdl.getpropertylist(ideology, :o)
pdl.create_agent(pdl.Agent_o, 1, 1, 0.1, (α = 1.1, β = 1.2))


pdl.Agent_oσ( 1, 1, 0.1, (α = 1.1, β = 1.2))

ag2 = pdl.create_agent(pdl.Agent_oσ, 1, 1, 0.1, (α = 1.1, β = 1.2))


@code_warntype pdl.createpop(pdl.Agent_o, 0.1, 1, 2)

pop1 = pdl.createpop(pdl.Agent_o, 0.1, 5, 25)
pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)

typeof(pop1)


@code_warntype pdl.pick_intranids(pop1, 0.3, position = "center")

@code_warntype pdl.turninto_intransigents!(pop1, 0.3 , position = "center")

@code_warntype pdl.turninto_intransigents(pop1, 0.2 , position = "extremes")

@code_warntype pdl.creategraphfrompop(pop1, pdl.LG.CompleteGraph)

nw1 =  pdl.creategraphfrompop(pop1, pdl.LG.CompleteGraph)


@doc supertype

(typeof(nw1) <:
 pdl.LG.AbstractGraph)




#this is important; it proves there is something wrong with my design; maybe have a population type??
@code_warntype pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)

pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)


eltype(pop1) == typeof(getindex(pop1,1))
eltype(pop1) >: typeof(getindex(pop1,1))

pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)

@code_warntype pdl.getjtointeract(pop1[1],pop1) #the same error happens here!!!!



pdl.pick_issuebelief(pop1[1],  pdl.getjtointeract(pop1[1],pop1))

pdl.pick_issuebelief(pop1[1],  pdl.getjtointeract(pop1[1],pop1)) |> typeof

belieftuple = pdl.pick_issuebelief(pop1[1],  pdl.getjtointeract(pop1[1],pop1))


@code_warntype belieftuple |> x -> pdl.calculate_pstar(x[2], x[3], 0.9)


@code_warntype pdl.pick_issuebelief(pop1[1], pop1[2], 1)

b1,b2 = pdl.pick_issuebelief(pop1[1], pop1[2], 1)

@code_warntype

@time pdl.calculate_pstar(b1, b1, 0.9)




pop1 = pdl.createpop(pdl.Agent_o, 0.1, 5, 25)
@time pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)

@time pdl.updateibelief!(pop1[1], pop1, 0.9)



@time  pdl.ρ_update!(pop1[1], 0.01)


eltype(pdl.createpop(pdl.Agent_o, 0.1, 1, 5))

#-- test together ↓


#Do some sanity checking here for the calculate_pstar alternative implementation
parasect  = pdl.PoodlParam()

@doc pdl.create_initialcond

parasect.graphcreator

@code_warntype pdl.create_initialcond(parasect.agent_type,
                                      parasect.σ,
                                      parasect.n_issues,
                                      parasect.size_nw,
                                      parasect.graphcreator,
                                      parasect.propintransigents)

foopop = pdl.create_initialcond(parasect.agent_type,
                       parasect.σ,
                       parasect.n_issues,
                       parasect.size_nw * 5,
                       parasect.graphcreator,
                                parasect.propintransigents)

foopop[1] |> x -> fieldnames(typeof(x))

foopop[1] |> x-> getfield(x, :idealpoint)

foopop[1].idealpoint


pdl.calculate_pstar(foopop[1],foopop[5],1, 0.7)

foopop[1].idealpoint

foopop[2].idealpoint

p = 0.7
i_belief,j_belief = pdl.pick_issuebelief(foopop[1], foopop[2], 1)

num = p * (1 / (sqrt(2 * π ) * i_belief.σ ) )* exp(-((foopop[1].idealpoint - foopop[2].idealpoint)^2 / (2*i_belief.σ^2)))

denom= num + (1 - p)
alternative_pstar  = num / denom |> 



@doc pdl.pullidealpoints

@code_warntype pdl.pullidealpoints(foopop)

@code_warntype pdl.createstatearray(foopop, parasect.time)

@code_warntype pdl.create_initdf(foopop)

foodf = pdl.create_initdf(foopop)

@code_warntype pdl.update_df!(foopop, foodf, parasect.time)


pdl.agents_update!(foopop, parasect.p, parasect.σ, parasect.ρ)

pdl.update_df!(foopop, foodf, parasect.time)

foodf

foopop

@code_warntype pdl.outputfromsim(pdl.pullidealpoints(foopop))


@code_warntype pdl.createstatearray(foopop, parasect.time)

pdl.createstatearray(foopop,parasect.time)

@code_warntype pdl.agents_update!(foopop, parasect.p, parasect.σ, parasect.ρ)


@code_warntype pdl.runsim!(foopop,foodf,parasect.p, parasect.σ,
                           parasect.ρ, parasect.time)


@code_warntype pdl.one_run(parasect)

pdl.Agent_o |> typeof

typeof(pdl.LG.CompleteGraph) <: pdl.LG.SimpleGraphs.CompleteGraph

@doc pdl.LG.SimpleGraphs.CompleteGraph

typeof(typeof)


pdl.simple_run(parasect)

pdl.simstatesvec(parasect)

@code_warntype pdl.simstatesvec(parasect)

@code_warntype pdl.statesmatrix(parasect)


pdl.get_simpleinitcond(parasect)




#Testing memory allocations

pop1 = pdl.createpop(pdl.Agent_o, 0.1, 5, 25)
@time pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)

@time pdl.updateibelief!(pop1[1], pop1, 0.9)

@time  pdl.ρ_update!(pop1[1], 0.01)

@time pdl.agents_update!(pop1, 0.9, 0.01)


parasect  = pdl.PoodlParam()



foopop = pdl.create_initialcond(parasect.agent_type,
                       parasect.σ,
                       parasect.n_issues,
                       parasect.size_nw * 5,
                       parasect.graphcreator,
                                parasect.propintransigents)

@time pdl.runsim!(foopop,parasect.p, parasect.ρ, parasect.time)

# ↑↑↑↑↑↑↑↑ first run of this code leads to 422k allocations, the second to 14!!!

@time pdl.simple_run(parasect)

@time pdl.simple_run(parasect) |> pdl.pullidealpoints |> pdl.outputfromsim

@code_warntype pdl.simple_run(parasect) 


typeof(parasect)

parasect

pdl.Agent_o()

outsim = pdl.simple_run(parasect)
