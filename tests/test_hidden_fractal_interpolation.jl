include("../src/hidden_fractal_interpolation.jl")

using HiddenFractalInterpolation
using Plots

x = [0; 30; 60; 100]
y = [0; 50; 40; 10]
H = [0; 30; 60; 100]
d = [0.3; 0.3; 0.3]
h = [0.2; 0.2; 0.2]
l = [-0.1; -0.1; -0.1]
m = [0.3; 0; -0.1]

a, c, e, f, g, k = ω_cof(x, y, H, d, h, l, m)

f0(xi) = [(y[end] - y[1]) / (x[end] - x[1]) * (xi - x[end]) + y[end];
          (H[end] - H[1]) / (x[end] - x[1]) * (xi - x[end]) + H[end]]
K = 100

fh_interpolated = hidden_interpolate(x, y, H, d, h, l, m, f0, K)
y_new, z_new = fh_interpolated(x[3])
domain = linspace(x[1], x[end], 1000)
range = fh_interpolated.(domain)
new_range = [range[k][1] for k = 1 : length(range)]
p = plot(domain, new_range , label="Hidden Interpolate")
# # legend!(loc="upper right")
