include("../src/fractal_interpolation.jl")

using FractalInterpolation
using Base.Test


@testset "FractalInterpolation Tests" begin
    x = linspace(0, pi, 10)
    y = sin.(x)
    N = length(x)
    d = ones(N - 1) * 0.5
    a, c, e, ff = ω_cof(x, y, d)
    @test norm(a - ones(N - 1) * 0.11111) < 1e-3
end


function composition(g)
    function h(x)
        return 2 * g(x)
    end
    return h
end

@testset "Composition Test" begin
    g(x) = x^2
    f = composition(g)
    @test f(2) == 8

end
