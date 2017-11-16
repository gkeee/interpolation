import DelaunayMeshes
import Plots

mesh = DelaunayMeshes.Mesh()
DelaunayMeshes.setboundingbox(mesh, [0., 10., 0., 10.])
# x = collect(linspace(0,1,6))
# y = collect(linspace(0,1,6))
# points = [x y]
nvertices = 10
points = rand(Float64, nvertices, 2)*10
push!(mesh, points)
xc, yc =  DelaunayMeshes.getdelaunaycoordinates(mesh.tesselation)
xc, yc = xc[3:end], yc[3:end]
plt =Plots.plot(xc*10, 10*yc)
display(plt)
