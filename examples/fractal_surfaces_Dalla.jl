# Bivariate fractal interolation functions on grid, Leoni Dalla
include("../src/fractal_surfaces.jl")

using FractalSurfaces

x = [0; 100; 200; 300]
y = [0; 100; 200; 300]
z = [1 4 6 2;
     2 1 3 6;
     5 0 4 3;
     3 6 3 4]
     s = 0.5 * ones(length(y), length(x))
     a, b, c, d, e, f, g, k = ω_cof(x, y, z, s)

f0(xi,yi) = xi + yi
K = 6
f_interpolated_surfaces = interpolate_surfaces(x, y, z, s, f0, K)
