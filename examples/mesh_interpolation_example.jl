include("../src/gmsh.jl")
include("../src/fractal_surfaces_uniform.jl")
using gmsh
using Plots
using FractalMeshInterpolation

# Create interpolation data
mesh = gmsh.read("/home/gizemkalender/Desktop/interpolation/src/t1.msh")
f(x) = x[1:end, 1].^2 + x[1:end, 2].^2
mesh.nodes[1:end, 3] = f(mesh.nodes)

# Interpolate the created data
f0(x, y) = x + y
α_7 = 0.5
K = 6
f_interpolated = mesh_interpolate(mesh, α_7, f0, K)






# # Plot interpolation data
# srf = surface(mesh.nodes[1:end, 1], mesh.nodes[1:end, 2], mesh.nodes[1:end, 3],reuse = false)
# display(srf)
# # 2D with
# plt = scatter(mesh.nodes[1:end, 1], mesh.nodes[1:end, 2])
# for i = 1:40
#       # i=20
#       p1 = mesh.elements[i, 1]
#       p2 = mesh.elements[i, 2]
#       p3 = mesh.elements[i, 3]
#       plot!([mesh.nodes[p1, 1], mesh.nodes[p2, 1], mesh.nodes[p3, 1], mesh.nodes[p1, 1]],
#       [mesh.nodes[p1, 2], mesh.nodes[p2, 2], mesh.nodes[p3, 2], mesh.nodes[p1, 2]])
#       i += 1
# end
# scatter!(mesh.nodes[1:3, 1], mesh.nodes[1:3, 2], color="red", m=5)
# display(plt)
