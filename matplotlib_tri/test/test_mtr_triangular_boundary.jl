using PyPlot
using PyCall
@pyimport matplotlib.tri as mtr
# @pyimport matplotlib.pyplot as plt

# struct Points
#     x::Float64
#     y::Float64
# end

function find_triangular_regions(x, y, convex_hull=false)
    if !convex_hull
        regions = mtr.Triangulation(x, y)
    else
        # TODO: Find convex hull of the region
    end  # if-else
    return regions
end  # find_triangular_regions

function get_region_edges_points(regions, num_points_per_edge=4)
    # TODO: Remove repeated points if exist!
    edges = regions[:edges]  # Unique edges of all regions
    number_of_points = length(regions[:x])
    number_of_edges = size(edges)[1]
    # points = Array{Points}(number_of_edges * num_points_per_edge + number_of_points)  # Point array of boundary mesh
    # x_points = zeros(number_of_edges * (num_points_per_edge - 2) + number_of_points)  # Point array of boundary mesh
    x_points = zeros(number_of_edges * (num_points_per_edge))  # Point array of boundary mesh
    # x_points = NaN * zeros(number_of_edges * (num_points_per_edge - 2))  # Point array of boundary mesh
    y_points = similar(x_points)  # Point array of boundary mesh
    # γ = linspace(0, 1, num_points_per_edge)[2 : end - 1]
    γ = linspace(0, 1, num_points_per_edge)[1 : end]
    for k = 1 : size(edges)[1]
        p1x, p2x = regions[:x][edges[k, :] + 1]
        p1y, p2y = regions[:y][edges[k, :] + 1]
        if abs(p1x - p2x) < 10 * eps()
            x_edge_values = p1x * ones(size(γ)[1])
        else
            x_edge_values = γ * p1x + (1 - γ) * p2x
        end
        if abs(p1y - p2y) < 10 * eps()
            y_edge_values = p1y*ones(size(γ)[1])
        else
            y_edge_values = γ * p1y + (1 - γ) * p2y
        end
        x_points[(k-1) * size(γ)[1] + 1 : k * size(γ)[1]] = x_edge_values
        y_points[(k-1) * size(γ)[1] + 1 : k * size(γ)[1]] = y_edge_values
    end  # forfind_triangular_regio
    # x_points[end - number_of_points + 1: end] = regions[:x]
    # y_points[end - number_of_points + 1 : end] = regions[:y]
    return x_points, y_points
end  # mesh_boundary

# function mesh_interior(regions, boundary_points_x, boundary_points_y, num_interior_points, num_points_per_edge)
function mesh_interior(regions, num_interior_points, num_points_per_edge)
    # TODO: Generate random points more evenly in the regions
    # TODO: Pruning of close points
    get_finder_method = regions[:get_trifinder]
    finder = get_finder_method()
    # TODO: for each region create a distinct mesh
    number_of_regions = size(regions[:triangles])[1]
    meshes = Array{typeof(regions)}(number_of_regions)
    for k = 1: number_of_regions
        # TODO: filter boundary points belonging to specific ...
        # TODO: ...region before creating the mesh
        mask = trues(number_of_regions)
        mask[k] = false
        regions[:set_mask](mask)
        bx_filtered, by_filtered = get_region_edges_points(regions, num_points_per_edge)
        # filter = 2 * finder(boundary_points_x, boundary_points_y) + 1 .> 0.
        # bx_filtered = boundary_points_x[filter]
        # by_filtered = boundary_points_y[filter]
        minx = minimum(bx_filtered)
        miny = minimum(by_filtered)
        maxx = maximum(bx_filtered)
        maxy = maximum(by_filtered)
        # TODO: Filter close points 
        x_points = minx + rand(num_interior_points) * (maxx - minx)
        y_points = miny + rand(num_interior_points) * (maxy - miny)
        result = finder(x_points, y_points)
        mask = (2 * result + 1) .> 0
        x_points = [x_points[mask]; bx_filtered]
        y_points = [y_points[mask]; by_filtered]
        meshes[k] = mtr.Triangulation(x_points, y_points)
    end

    return meshes
end  # mesh_interior

num_points = 5
l_boundary = 20

xs = [10., 20., 30., 30., 20., 10., 0., 0., 15.] * l_boundary
ys = [0., 0., 10., 20., 30., 30., 20., 10., 15.] * l_boundary
# xs = [0., 0., 1., 1., 0.5] * l_boundary
# ys = [0., 1., 0., 1., 0.5] * l_boundary
rregions = find_triangular_regions(xs, ys)
# boundary_points_x, boundary_points_y = get_region_edges_points(rregions, num_points)
# meshes= mesh_interior(rregions, boundary_points_x, boundary_points_y, num_points^2, num_points)
meshes= mesh_interior(rregions, num_points^2, num_points)

for mesh in meshes
    triplot(mesh, linewidth=1.)
    pause(3)
end
