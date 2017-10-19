
include("../src/fractal_interpolation.jl")
using FractalInterpolation
using PyPlot

f0(xi) = (y[N] - y[1]) / (x[N] - x[1]) * (xi - x[N]) + y[N]
x = collect(linspace(0, pi, 10))
y = sin.(x)
N = length(x)
d = ones(N - 1) * 0.5
plot(x, y, "o",linewidth=5, label="Data set")
title("Fractal Interpolation")
legend(loc="upper right")
xlabel("x")
ylabel("y")

f_interpolated = interpolate(f0, x, y, d, 1e-3)
domain = linspace(x[1], x[end], 1000)
range = f_interpolated.(domain)
plot(domain, range , label="Interpolate")
legend(loc="upper right")
