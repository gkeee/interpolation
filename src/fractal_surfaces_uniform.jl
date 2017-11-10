include("../src/gmsh.jl")
using  gmsh
using Plots
pyplot()
# Create interpolation data
mesh = gmsh.read("/home/gizem.kalender/Documents/interpolation/src/t1.msh")
f(x) = x[1:end, 1].^2 + x[1:end, 2].^2
mesh.nodes[1:end, 3] = f(mesh.nodes)
srf = surface(mesh.nodes[1:end, 1], mesh.nodes[1:end, 2], mesh.nodes[1:end, 3])
# print(mesh.nodes)
# plt = scatter(mesh.nodes[1:end, 1], mesh.nodes[1:end, 2])
# plot!([mesh.nodes[12, 1], mesh.nodes[3, 1], mesh.nodes[27, 1], mesh.nodes[12, 1]],
#         [mesh.nodes[12, 2], mesh.nodes[3, 2], mesh.nodes[27, 2], mesh.nodes[12, 2]])
# display(plt)
display(srf)


# for i = 1:40
#         p1 = mesh.elements[i,1:end][1]
#         p2 = mesh.elements[i,1:end][2]
#         p3 = mesh.elements[i,1:end][3]
#         plot!([mesh.nodes[p1, 1], mesh.nodes[p2, 1], mesh.nodes[p3, 1], mesh.nodes[p1, 1]],
#         [mesh.nodes[p1, 2], mesh.nodes[p2, 2], mesh.nodes[p3, 2], mesh.nodes[p1, 2]])
#         i += 1
# end
# scatter!(mesh.nodes[1:3,1], mesh.nodes[1:3,2] ,color="red", m=5)
# display(plt)

function ω_cof(mesh, α_7) #scaling factor
        # P = [mesh.nodes[1,1] mesh.nodes[1,2] 1;
        #      mesh.nodes[2,1] mesh.nodes[2,2] 1;
        #      mesh.nodes[3,1] mesh.nodes[3,2] 1]
        no_elements = size(mesh.elements)[1]

        mesh.elements = mesh.elements[1:Int(no_elements/2), 1:end]

        P = [mesh.nodes[1:3, 1:2] ones(3, 1)]
        z = mesh.nodes[1:3,  end]
        P_inv = inv(P)

        A_elements = mesh.elements'
        A_nodes = mesh.nodes[A_elements,1:3]


        row_1 = P_inv * A_nodes[:,:,1]
        row_2 = P_inv * A_nodes[:,:,2]
        row_3 = P_inv * A_nodes[:,:,3] .- α_7 * P_inv * z

        α_1 = row_1[1,1:end]
        α_2 = row_1[2,1:end]
        β_1 = row_1[3,1:end]

        α_3 = row_2[1,1:end]
        α_4 = row_2[2,1:end]
        β_2 = row_2[3,1:end]

        α_5 = row_3[1,1:end]
        α_6 = row_3[2,1:end]
        β_3 = row_3[3,1:end]

    return (α_1, α_2, β_1, α_3, α_4, β_2, α_5, α_6, β_3)
end  # w_cof
