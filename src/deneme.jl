using VoronoiDelaunay
using Plots
using GeometricalPredicates
using Base

tess =DelaunayTessellation2D(50)
for x in [1.1, 1.2, 1.3, 1.5, 1.6], y in [1.3, 1.1, 1.5, 1.8, 1.2]
# for x in linspace(1.1,2.5,10), y in linspace(1.1,1.9,6)
    push!(tess,Point2D(x,y))
    tess
end



function getplotxy(edges)
    edges = collect(edges)
    x = Float64[]
    y = Float64[]
    for e in edges
        push!(x, getx(getb(e)))
        push!(x, getx(geta(e)))
        push!(x, NaN)
        push!(y, gety(geta(e)))
        push!(y, gety(getb(e)))
        push!(y, NaN)
    end
    (x, y)
end

x, y = getplotxy( delaunayedges(tess))

 p = plot(x,y)
 display(p)
# # for x= 1.1:0.2:1.9
# #     for y = 1.1:0.2:1.9
# #      push!(tess,getplotxy(x,y))
# #     end
# # end
# #
# # p= plot(tess)
# # display(p)
