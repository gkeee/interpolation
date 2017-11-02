module FractalSurfaces

# include("./utilities.jl")

export ω_cof, interpolate_surfaces

function ω_cof(x,
               y,
               z,
               s) #scaling factor

        a = (x[2:end] - x[1:end-1]) / (x[end] - x[1])

        b = (x[1:end-1] * x[end] - x[2:end] * x[1]) /
            (x[end] - x[1])

        c = (y[2:end] - y[1:end-1]) / (y[end] - y[1])

        d = (y[1:end-1] * y[end] - y[2:end] * y[1]) /
            (y[end] - y[1])

        g = (z[2:end, 2:end] + z[1:end-1, 1:end-1]
             - z[1:end-1, 2:end] - z[2:end, 1:end-1]
             - s[2:end, 2:end]
             * (z[end,end] + z[1,1] - z[1,end] - z[end,1])) /
             ((y[end] -y[1]) * (x[end] - x[1]))
        # g = zeros(length(y) - 1, length(x) - 1)
        e = (z[1:end-1, 1:end-1] - z[2:end, 1:end-1]
             - s[2:end, 2:end] * (z[1,1] - z[end,1])
             - g[1:end, 1:end] * y[1] * (x[1] - x[end])) /
             (x[1] - x[end])

        f = (z[1:end-1, 1:end-1] - z[1:end-1, 2:end]
             - s[2:end, 2:end] * (z[1,1] - z[1,end])
             - g[1:end, 1:end] * x[1] * (y[1] - y[end])) /
             (y[1] - y[end])

        k = z[2:end, 2:end] - e[1:end, 1:end] * x[end]
           - f[1:end, 1:end] * y[end]
           - s[2:end, 2:end] * z[end, end]
           - g[1:end, 1:end] * x[end] * y[end]

    return (a, b, c, d, e, f, g, k)
end  # w_cof


function interpolate_surfaces(x, y, z, s, f0, K)
     function template(func)
         a, b, c, d, e, f, g, k = ω_cof(x, y, z, s)
        idx = 1 : length(x)
        idy = 1 : length(y)
        function f_next(xd, yd)
            n_i = x .< xd
            m_i = y .< yd
            if all(n_i) || all(m_i)
                return z[end,end]
            elseif any(n_i) && any(m_i)
                n=idx[n_i][end]
                m=idy[m_i][end]
                temp = e[n,m] * ((xd-b[n])/a[n]) + f[n,m] * ((yd-d[m])/c[m])
                        + g[n,m] * ((xd-b[n])/a[n]) * ((yd-d[m])/c[m])
                        + s[n,m] * func((xd-b[n])/a[n], (yd-d[m])/c[m])
                        + k[n,m]
                return temp
            else
                return z[1,1]
            end
        end  # f_next
        return f_next
     end # template
# #
# #     f1 = template(f0)
# #     sigma = maximum(d)
# #     g(x) = f1(x) - f0(x)
# #     m = norm_estimate_1(g, x[1], x[end])
# #     K = ceil(Int, log(epsilon * (1-sigma) / m) / log(sigma))
# #
    ff = f0
    for n = 1 : K
        ff=template(ff)
    end
    return ff
end  # interpolation_surfaces

end # module
