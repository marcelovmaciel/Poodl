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

ag2 = pdl.create_agent(pdl.Agent_oσ, 1, 1, 0.1, (α = 1.1, β = 1.2))


@code_warntype pdl.createpop(pdl.Agent_o, 0.1, 1, 2)

pop1 = pdl.createpop(pdl.Agent_o, 0.1, 5, 25) 


@doc pdl.createpop

@code_warntype pdl.pick_intranids(pop1, 0.3, position = "center")

@code_warntype pdl.turninto_intransigents!(pop1, 0.3 , position = "center")

@code_warntype pdl.turninto_intransigents(pop1, 0.2 , position = "extremes")

@code_warntype pdl.creategraphfrompop(pop1, pdl.LG.CompleteGraph)

nw1 =  pdl.creategraphfrompop(pop1, pdl.LG.CompleteGraph)

@code_warntype pdl.add_neighbors!(pop1, pdl.LG.CompleteGraph)

