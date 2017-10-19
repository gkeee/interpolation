include("../src/utilities.jl")
f(x) = x^2
opt = norm_estimate_inf(f, 1, 4)
