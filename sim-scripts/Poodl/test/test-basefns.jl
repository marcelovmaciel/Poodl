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
                                [1,2,3], (1.1,1.4))
    # gotta automate this process later
        @test testAgent.id == 1
        @test testAgent.ideo == []
        @test testAgent.idealpoint == 0.5
        @test testAgent.neighbors == [2,3,4]
        @test testAgent.certainissues == [1,2,3]
        @test testAgent.certainparams == (1.1,1.4)
    end
end

@testset "in which fns are tested" begin
    @test length(pdl.createbetaparams(5)) == 5
    @test_throws DomainError pdl.createbetaparams(0)
    @test_throws DomainError pdl.create_belief(2, 1 , (α = 1.1, β = 1.2))

end






#@testset "in which type-stability is tested" begin
#    f(a, b, c) = b > 1 ? 1 : 1.0
#    @inferred f(1, 2, 3)
#end
