# using PyPlot

module FractalInterpolation

include("./utilities.jl")

export interpolate

"""
    ω_cof(x::Array{Real}, y, d)
"""
function ω_cof(x::Array{Real}, y, d)
    N = length(x)
    h = x[N] - x[1]
    a = zeros(N - 1)
    e = zeros(N - 1)
    c = zeros(N - 1)
    ff = zeros(N - 1)
    for n = 1 : N - 1
        a[n] = (x[n+1] - x[n])/h
        e[n] = (x[N]*x[n] - x[1]*x[n+1]) / h
        c[n] = ((y[n + 1] - y[n]) - d[n]*((y[N] - y[1]))) / h
        ff[n] = ((x[N]*y[n] - x[1]*y[n + 1]) - d[n]*(x[N]*y[1] - x[1]*y[N])) / h
    end
    return (a, c, e, ff)
end  # w_cof

function interpolate(f0, x, y, d, epsilon)
    function template(f)
        a, c, e, ff = ω_cof(x, y, d)
        idx = 1 : length(x)
        function f_next(xd)
            b_i = x .< xd
            if all(b_i)
                return y[end]
            elseif any(b_i)
                n=idx[b_i][end]
                temp = c[n] * ((xd - e[n]) / a[n]) + d[n] * f((xd - e[n]) / a[n]) + ff[n]
                return temp
            else
                return y[1]
            end
        end  # f_next
        return f_next
    end # template

    f1 = template(f0)
    sigma = maximum(d)
    g(x) = f1(x) - f0(x)
    m = norm_estimate_1(g, x[1], x[end])
    K = ceil(Int, log(epsilon * (1-sigma) / m) / log(sigma))

    f = f0
    for n = 1 : K
        f=template(f)
    end
    return f

end  # interpolation
end  # module FractalInterpolation
