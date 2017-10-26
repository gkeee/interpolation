function f(x::Array{Float64})
    return x * 2
end

function f(x::Array{Int})
    return x + 1
end

res1 = f([40.])
res2 = f([40])
res3 = f([1im])
