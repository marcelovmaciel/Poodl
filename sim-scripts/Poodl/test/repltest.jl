using Pkg
Pkg.activate(pwd())


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

@code_warntype pdl.calculate_pstar(b1, b1, 0.9)

@code_warntype pdl.updateibelief!(pop1[1], pop1, 0.9)

@inferred pdl.updateibelief!(pop1[1], pop1, 0.9)

@code_warntype pdl.ρ_update!(pop1[1], 0.01)


