using Revise
using Poodl
const  pdl  = Poodl

@code_warntype pdl.createbetaparams(5)

pdl.create_belief(0.1,1, (α = 0.5, β = 0.6))

pdl.createbetaparams(0)

testAgent = pdl.Agent_o(1, [], 0.5, [2,3,4], [1,2,3], (α =1.1, β = 1.4))

ideology = [pdl.create_belief(0.1, 1, (α = 0.5, β = 0.6)) for issue in 1:5 ]

ideology |> eltype |> x -> fieldtype(x, :o)

pdl.Agent_o <: pdl.AbstractAgent

@code_warntype pdl.create_idealpoint(ideology)

pdl.getitemsproperty(ideology, :o)
pdl.create_agent(pdl.Agent_o, 1, 1, 0.1, (α = 1.1, β = 1.2))

ag2 = pdl.create_agent(pdl.Agent_oσ, 1, 1, 0.1, (α = 1.1, β = 1.2))

pdl.create_agent(2, 1, 1, 0.1, (α = 1.1, β = 1.2))

pdl.createpop(pdl.Agent_o, 0.1, 1, 2) |> eltype

pdl.createpop(1, 0.1, 1, 2) 


