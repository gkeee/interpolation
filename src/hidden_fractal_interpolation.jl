module HiddenFractalInterpolation

include("./utilities.jl")

export ω_cof, hidden_interpolate

function ω_cof(x::Vector{<:Real},
               y::Vector{<:Real},
               H::Vector{<:Real},
               d::Vector{<:Real},
               h::Vector{<:Real},
               l::Vector{<:Real},
               m::Vector{<:Real})
    p = y[1 : end - 1] - d * y[1] - h * H[1]
    q = H[1 : end - 1] - l * y[1] - m * H[1]
    r = y[2 : end] - d * y[end] - h * H[end]
    s = H[2 : end] - l * y[end] - m * H[end]
    b = x[end] - x[1]

    a = (x[2 : end] - x[1 : end-1]) / b
    c = (r - p) / b
    e = (x[end] * x[1: end-1] - x[1] * x[2 : end]) / b
    f = p - c * x[1]
    k = (s - q) / b
    g = q - k * x[1]

    return (a, c, e, f, g, k)
end  # w_cof


function hidden_interpolate(x, y, H, d, h, l, m, f0, K)
     function template(func)
         a, c, e, f, g, k = ω_cof(x, y, H, d, h, l, m)
        idx = 1 : length(x)
        function f_next(xd)
            b_i = x .< xd
            if all(b_i)
                return [y[end]; H[end]]
            elseif any(b_i)
                n=idx[b_i][end]
                MA = [d[n] h[n]; l[n] m[n]]
                Mb = [c[n]; k[n]]
                Mc = [f[n]; g[n]]
                temp = MA * func((xd - e[n]) / a[n]) + Mb * ((xd - e[n]) / a[n]) + Mc
                return temp
            else
                return [y[1]; H[1]]
            end
        end  # f_next
        return f_next
     end # template
#
#     f1 = template(f0)
#     sigma = maximum(d)
#     g(x) = f1(x) - f0(x)
#     m = norm_estimate_1(g, x[1], x[end])
#     K = ceil(Int, log(epsilon * (1-sigma) / m) / log(sigma))
#
    ff = f0
    for n = 1 : K
        ff=template(ff)
    end
    return ff
#
end  # hidden_interpolation

end # module
