function norm_estimate_n(f, a, b, n=2)
    integrant(x) = abs(f(x))^n
    return quadgk(integrant, a, b)^(1 / n)[1]
end

function norm_estimate_inf(f, a, b)
    # using NLopt, JuMP
    # m = Model(solver=NLoptSolver(algorithm=:LD_MMA))
    # @variable(m, x)
    # @NLconstraint(m, a <= x <= b)
    # JuMP.register(m, :f, 1, f, autodiff=true)
    # @NLobjective(m, Min, -f(x))
    # solve(m)
    # # println(" f(x) ", getobjectivevalue(m), " at ", [getvalue(x)])
    # return getobjectivevalue(m)
    x = linspace(a, b, 1000)
    return maximum(f.(x))
end

function norm_estimate_1(f, a, b)
    integrant(x) = abs(f(x))
    return quadgk(integrant, a, b)[1]
end
