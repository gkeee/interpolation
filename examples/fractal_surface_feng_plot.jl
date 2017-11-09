# Bivariate fractal interolation functions on grid, Leoni Dalla
include("../src/fractal_surfaces_feng.jl")

using FractalSurfaces
using Plots

plotly()

x = linspace(0, 1, 5)
y = linspace(0, 1, 4)
z = [0.3 1.1 2 1.5 2;
     0.3 2 1.8 1.5 2;
     3 2 3 3.3 3;
     2 3 2.5 4 4.5]
λ = [2 3 1 3;
     3 -2 3 -2;
     4 2 -3 5]
    a, b, c, d, e, f, g, k = ω_cof(x, y, z)

f0(xi, yi) = xi + yi
K = 6
f_interpolated_surfaces = interpolate_surfaces(x, y, z, λ, f0, K)

# X = linspace(x[1], x[end], 1000)
# Y = linspace(y[1], y[end], 1000)
# # z = f_interpolated_surfaces.(domain_x, domain_y)
# Z = zeros(length(X), length(Y))
# for i = 1 : length(X)
#     for j = 1 :  length(Y)
#         Z[i, j] = f_interpolated_surfaces(Y[j], X[i])
#     end
# end
# p = surface(X, Y, Z, label="Interpolate")
#
# # legend(loc="upper right")
# display(p)
