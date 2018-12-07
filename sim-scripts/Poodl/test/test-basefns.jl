@testset "in which Types are tested" begin
    @testset "in which Beliefs are tested" begin
        o = 0.5
        σ = 0.1
        testBelief = pdl.Belief(o, σ, 0)
        @test testBelief.o == o
        @test testBelief.σ == σ
        @test testBelief.whichissue == 0
    end

    @testset "in which Agents are tested" begin
        testAgent = pdl.Agent_o(1, [], 0.5, [2,3,4],
                                [1,2,3], (α = 1.1, β= 1.4))
    # gotta automate this process later
        @test testAgent.id == 1
        @test testAgent.ideo == []
        @test testAgent.idealpoint == 0.5
        @test testAgent.neighbors == [2,3,4]
        @test testAgent.certainissues == [1,2,3]
        @test testAgent.certainparams == (α = 1.1, β = 1.4)
    end
end

@testset "in which basefns were tested" begin
    pop1 = pdl.createpop(pdl.Agent_o, 0.1, 5, 25) 
    @test length(pdl.createbetaparams(5)) == 5
    @test_throws DomainError pdl.createbetaparams(0)
    @test_throws DomainError pdl.Belief(2, 1 , (α = 1.1, β = 1.2))
    #test_throws MethodError pdl.create_agent(2, 1, 1, 0.1, (α = 1.1, β = 1.2))
    @test_throws ArgumentError pdl.getpropertylist([1,2,3], :o)
    @test typeof([pdl.Belief(0.1, 1, (α = 0.5, β = 0.6)) for issue in 1:5 ]  |> pdl.calculatemeanopinion) == Float64
    @inferred pdl.createpop(pdl.Agent_o, 0.1, 1, 5)
    @test_throws MethodError pdl.createpop(1, 0.1, 1, 5)
    @test_throws ArgumentError pdl.pick_intranids(pop1, 0.6, position = "extremes")
    @test_throws ArgumentError pdl.pick_intranids(pop1, 0.2, position = "foo")
    @test_throws ArgumentError pdl.turninto_intransigents!(pop1, 0.2 , position = "foo")
    @test_throws ArgumentError pdl.turninto_intransigents!(pop1, 0.6 , position = "extremes")
    @inferred pdl.turninto_intransigents!(pop1, 0.2 , position = "extremes")
    @inferred pdl.turninto_intransigents(pop1, 0.2 , position = "extremes")
    @inferred pdl.pick_intranids(pop1, 0.2, position = "extremes")
    @test (eltype(pdl.turninto_intransigents(pop1, 0.2 , position = "extremes")) ==
           eltype(pop1) )
    @test (length(pdl.turninto_intransigents(pop1, 0.2 , position = "extremes")) ==
           length(pop1) )
    @test (typeof( pdl.creategraphfrompop(pop1, pdl.LG.CompleteGraph)) <:
           pdl.LG.AbstractGraph)

    pdl.add_neighbors!(pop1,pdl.LG.CompleteGraph)
    @test pdl.getjtointeract(pop1[1],pop1) |> typeof <: pdl.Agent_o #gotta change this; it shouold be == to a more inferred concrete type
    @inferred pdl.pick_issuebelief(pop1[1], pop1[2], 1)
    @inferred pdl.updateibelief!(pop1[1], pop1, 0.9)
end

