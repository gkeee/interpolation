
include("../src/fractal_surfaces.jl")

using FractalSurfaces
using Base.Test


@testset "FractalSurfaces Tests" begin
    x = [0; 100; 200; 300]
    y = [0; 100; 200; 300]
    z = [1 4 6 2;
         2 1 3 6;
         5 0 4 3;
         3 6 3 4]
    s = 0.5 * ones(length(y), length(x))
    a, b, c, d, e, f, g, k = ω_cof(x, y, z, s) 
end
