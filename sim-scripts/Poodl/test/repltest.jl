using Revise
using Poodl
const  pdl  = Poodl

@code_warntype pdl.createbetaparams(5)

pdl.create_belief(0.1,1, (α = 0.5, β = 0.6))

pdl.createbetaparams(0)

testAgent = pdl.Agent_o(1, [], 0.5, [2,3,4], [1,2,3], (1.1,1.4))

ideology = [pdl.create_belief(0.1, 1, (α = 0.5, β = 0.6)) for issue in 1:5 ]

pdl.create_idealpoint(ideology)

foo2 = similar(ideology, typeof(getfield(ideology[1], :o)))

pdl.getitemsproperty(ideology, :o)

