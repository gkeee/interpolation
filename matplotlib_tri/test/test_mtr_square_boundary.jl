using PyPlot
using PyCall
@pyimport matplotlib.tri as mtr
# @pyimport matplotlib.pyplot as plt

xs = [0., 0., 1., 1.] * 20 
ys = [0., 1., 0., 1.] * 20
xr = rand(400) * 20
yr = rand(400) * 20
bl = collect(1:19)
b0 = zeros(19)
b1 = ones(19) * 20
x = collect([xs; xr; bl; b0; b1; bl; bl])
y = collect([ys; yr; bl; bl; bl; b1; b0])

tri = mtr.Triangulation(xs, ys)
rand_tri = mtr.Triangulation(x, y)
rand_tri_analyzer = mtr.TriAnalyzer(rand_tri)
rand_tri_finder = mtr.TrapezoidMapTriFinder(rand_tri)
uniform_refiner = mtr.UniformTriRefiner(tri)
triplot(rand_tri)
# rand_tri_refiner = mtr.UniformTriRefiner(rand_tri)
# subplot(2, 1, 1)
# triplot(tri)
# subplot(2, 1, 2)
# triplot(rand_tri)
# figure()
# mask = abs(rand_tri_analyzer[:circle_ratios]()) .<= 0.2
# if any(mask)
#     rand_tri[:set_mask](mask)
#     rand_tri_refiner = mtr.UniformTriRefiner(rand_tri)
#     random_refined_tri = rand_tri_refiner[:refine_triangulation](subdiv=2)
#     # rand_tri[:triangles][mask, :]
#     # rand_tri[:set_mask](nothing)
#     triplot(random_refined_tri, linewidth=2.)
#     # triplot(uniform_refined_tri)
# end
