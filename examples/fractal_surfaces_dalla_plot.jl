# Bivariate fractal interolation functions on grid, Leoni Dalla
include("../src/fractal_surfaces.jl")

using FractalSurfaces
using Plots

plotly()

x = linspace(0,1,5)
y = linspace(0,1,4)
z = [0.3 1.1 2 1.5 2;
     0.3 2 1.8 1.5 2;
     3 2 3 3.3 3;
     2 3 2.5 4 4.5]
# z = zeros(length(x),length(y))
# for i = 1: length(x)
#     for j = 1 : length(y)
#         z[i,j] = x[i]^2 + y[j]^2
#     end
# end


     s = 0.5 * ones(length(y), length(x))
     a, b, c, d, e, f, g, k = ω_cof(x, y, z, s)

f0(xi,yi) = xi + yi
K = 6
f_interpolated_surfaces = interpolate_surfaces(x, y, z, s, f0, K)

X = linspace(x[1], x[end], 1000)
Y = linspace(y[1], y[end], 1000)
# z = f_interpolated_surfaces.(domain_x, domain_y)
Z = zeros(1000, 1000)
for i = 1 : length(X)
    for j = 1 :  length(Y)
        Z[i, j] = f_interpolated_surfaces(X[i], Y[j])
    end
end
p = surface(X, Y, Z, label="Interpolate")

# legend(loc="upper right")
display(p)
