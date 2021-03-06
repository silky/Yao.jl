using Compat
using Compat.Test
using Compat.LinearAlgebra
using Compat.SparseArrays

using Yao
using Yao.Blocks

@testset "constructor" begin
    g = Roller{5, ComplexF64}(X(), kron(2, X(), Y()), Z(), Z())
    @test isa(g, Roller{5, 4, ComplexF64})

    src = phase(0.1)
    g = Roller{4}(src)
    g[1].theta = 0.2
    @test src.theta == 0.1
    @test g[2].theta == 0.1
end

@testset "copy" begin
    g = Roller{4}(phase(0.1))
    cg = copy(g)

    cg[1].theta = 1.0
    @test g[1].theta == 0.1
end

@testset "setindex" begin
    g = Roller{4}(phase(0.1))
    @test_throws MethodError g[1] = X()
end

@testset "iteration" begin
    g = Roller{5}(phase(0.1))
    for each in g
        @test each.theta == 0.1
    end

    g = Roller{5, ComplexF64}(X(), kron(2, X(), Y()), Z(), Z())
    list = [X(), kron(2, X(), Y()), Z(), Z()]
    for (src, tg) in zip(g, list)
        @test src == tg
    end

    for i in eachindex(g)
        @test g[i] == list[i]
    end
end

@testset "tile one block" begin
g = Roller{5}(X())
@test state(g(register(bit"11111"))) == state(register(bit"00000"))
@test state(g(register(bit"11111", 3))) == state(register(bit"00000", 3))
end

@testset "roll multiple blocks" begin
g = Roller{5, ComplexF64}((X(), Y(), Z(), X(), X()))
tg = kron(5, X(), Y(), Z(), X(), X())
@test state(g(register(bit"11111"))) == state(tg(register(bit"11111")))
@test state(g(register(bit"11111", 3))) == state(tg(register(bit"11111", 3)))
end

@testset "matrix" begin
g = Roller{5, ComplexF64}((X(), Y(), Z(), X(), X()))
tg = kron(5, X(), Y(), Z(), X(), X())
@test mat(g) == mat(tg)
end

@testset "traits" begin
g = Roller{5, ComplexF64}(X(), kron(2, X(), Y()), Z(), Z())
@test eltype(g) == eltype(g.blocks)
@test length(g) == 4
@test isunitary(g) == true
end
