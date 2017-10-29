include("../src/hidden_fractal_interpolation.jl")
include("../src/fractal_interpolation.jl")

using HiddenFractalInterpolation
using FractalInterpolation
using Plots, QuadGK
plotly()
# x = [0; 30; 60; 100]
x = collect(linspace(0, pi, 10))
y = sin.(x)
# H = [0.; 30; 60.; 100.]
H = x
n = length(x)
d = 0.3 * ones(n - 1)
h = 0.2 * ones(n - 1)
l = -0.1 * ones(n - 1)
m = rand(n-1)
# d = [0.3; 0.3; 0.3]
# h = [0.2; 0.2; 0.2]
# l = [-0.1; -0.1; -0.1]
# m = [0.3; 0.; -0.1]

a, c, e, f, g, k = ω_cof(x, y, H, d, h, l, m)

f0(xi) = [(y[end] - y[1]) / (x[end] - x[1]) * (xi - x[end]) + y[end];
          (H[end] - H[1]) / (x[end] - x[1]) * (xi - x[end]) + H[end]]
K = 6

fh_interpolated = hidden_interpolate(x, y, H, d, h, l, m, f0, K)
domain = linspace(x[1], x[end], 1000)
# range = map!(fh_interpolated, domain)
range_h = fh_interpolated.(domain)
new_range_h = [range_h[k][1] for k = 1 : length(range_h)]

f_interpolated = interpolate(x, y, d, 1e-3)
range = f_interpolated.(domain)
p = plot(domain, range , label="Interpolate")
plot!(domain, new_range_h , label="Hidden Interpolate",
    title = "Hidden Variable Fractal Interpolation",
    xlabel = "x",
    ylabel = "y" )
# legend!(loc="upper right")
scatter!(x,y, label = "Data set")
display(p)
@time fh_interpolated.(domain)
