using PyPlot

# x = [1; 2; 3.25; 4.75; 5]
# y = [10; 11; 15; 20; 8]
# x = [0; 30; 60; 100]
# y = [0; 50; 40; 10]
# x = linspace(0, pi, 10)
# y = sin.(x)
# x = collect(linspace(0, 1, 11))
# x = collect(linspace(0, pi, 11))
# y = sin.(x)
x = linspace(0,pi,10)
y = sin.(x)

N = length(x);
d = ones(N - 1) * 0.5
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

# function heaviside(x)
#     if x == 0
#         return 1
#     end
#     return 0.5 * sign(x) + 0.5
# end

function template(f)
    idx=1:length(x)
    function f_next(xd)
        # if xd == x[end]
        #     return y[end]
        # else
        b_i=(x.<xd)
        if all(b_i)
            return y[end]
        elseif any(b_i)
          n=idx[b_i][end]

            # (heaviside(xd - x[n]) - heaviside(xd - x[n + 1])) for n = 1 : N - 1])
            # float(x[n]<=xd<=x[n+1]) for n = 1 : N - 1])
        # end
       else
          return y[1]
       end
    #    println("n= $n")
       return c[n] * ((xd - e[n]) / a[n]) + d[n] * f((xd - e[n]) / a[n]) + ff[n]
    end
    return f_next
end
# function norm_estimate_n(f,a,b,n=2)
#     function integrant(f)
#         return abs.(f.(x).^n)
#     end
#     return quadgk(integrant,a,b).^(1/n)
# end
# function norm_estimate_inf(f,a,b)
#     function integrant(f)
#         return abs.(f.(x))
#     end
#     return # optimize -f(x)
# end

function norm_estimate_1(f,a,b)
    function integrant(x)
        return abs.(f.(x))
    end
    return quadgk(integrant,a,b)[1]
end



function interpolate(f0, x, y, d, epsilon)
    f1 = template(f0)
    function g(x)
        return f1(x)-f0(x)
    end

    sigma = maximum(d)
    m = norm_estimate_1(g,x[1],x[end])
    K = ceil(Int, log(epsilon * (1-sigma) / m) / log(sigma))
    # println("K: $K")
    f = f0
    for n = 1 : K
        # println("Iteration = $n")
        f=template(f)
    end
  return f
end

f0(xi) = (y[N] - y[1]) / (x[N] - x[1]) * (xi - x[N]) + y[N]

# K = 6
# epsilon = 0.0025
domain = linspace(0,pi,1000)
plot(x, y, "o",linewidth=5, label=" Data set ")
title("Fractal Interpolation")
legend(loc="right upper")
xlabel("x")
ylabel("y")
# for K = 1 : 10
#     res = interpolate(f0, x, y, d, K)
#     range = map(res, domain)
#     plot(domain, range, label="K=$K")
#     legend(loc="right upper")
#     # pause(1)
# end
    res = interpolate(f0, x, y, d, 1e-3)
    range = map(res, domain)
    plot(domain, range)
    legend(loc="right upper")


res=interpolate(f0, x, y, d, 1e-4)
l=linspace(0,pi,100)
@time res.(l)
@time res.(l)



a = 4
