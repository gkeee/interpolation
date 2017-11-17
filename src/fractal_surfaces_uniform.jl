include("../src/gmsh.jl")
using gmsh
module FractalMeshInterpolation

export ω_cof, mesh_interpolate

function ω_cof(mesh, α_7) #scaling factor
    # number_elements = size(mesh.elements)[1]
    # mesh.elements = mesh.elements[1:Int(number_elements/2), 1:end]

    P = [mesh.nodes[1:3, 1:2] ones(3, 1)]
    P_inv = inv(P)
    z = mesh.nodes[1:3,  end]
    A_elements = mesh.elements'
    A_nodes = mesh.nodes[A_elements, 1:3]

    row_1 = P_inv * A_nodes[:, :, 1]
    row_2 = P_inv * A_nodes[:, :, 2]
    row_3 = P_inv * A_nodes[:, :, 3] .- α_7 * P_inv * z

    α_1 = row_1[1, 1:end]
    α_2 = row_1[2, 1:end]
    β_1 = row_1[3, 1:end]

    α_3 = row_2[1, 1:end]
    α_4 = row_2[2, 1:end]
    β_2 = row_2[3, 1:end]

    α_5 = row_3[1, 1:end]
    α_6 = row_3[2, 1:end]
    β_3 = row_3[3, 1:end]

    return (α_1, α_2, β_1, α_3, α_4, β_2, α_5, α_6, β_3)
end  # w_cof

function mesh_interpolate(mesh, α_7, f0, K)
    function template(func)
        α_1, α_2, β_1, α_3, α_4, β_2, α_5, α_6, β_3 = ω_cof(mesh, α_7)
        function f_next(px, py)
            n = 0
            for i = 1 : 40
                m_e = mesh.elements
                m_n = mesh.nodes

                A1 = [px py 1;
                m_n[m_e[i, 1], 1] m_n[m_e[i, 1], 2] 1;
                m_n[m_e[i, 2], 1] m_n[m_e[i, 2], 2] 1]
                det1 = det(A1)

                A2 = [px py 1;
                m_n[m_e[i,2],1] m_n[m_e[i,2],2] 1;
                m_n[m_e[i,3],1] m_n[m_e[i,3],2] 1]
                det2 = det(A2)

                A3 = [px py 1;
                m_n[m_e[i,3],1] m_n[m_e[i,3],2] 1;
                m_n[m_e[i,1],1] m_n[m_e[i,1],2] 1]
                det3 = det(A3)

                if det1 >= 0 && det2 >= 0 && det3 >= 0
                    n = i
                    break
                end #if end
            end #for end
            # println(n)
            if n == 0
                x1, x2, x3 = mesh.nodes[1:3, 1]
                y1, y2, y3 = mesh.nodes[1:3, 2]
                error("The point $((px, py)) is not in the interpolation triangle")
            end
            l_inv = inv([α_1[n] α_2[n]; α_3[n] α_4[n]]) * ([px, py] - [β_1[n], β_2[n]])
            temp = l_inv' * [α_5[n], α_6[n]] + α_7 * func(l_inv[1], l_inv[2]) + β_3[n]
            return temp
        end  # f_next
        return f_next
    end # template

    ff = f0
    for j = 1 : K
        ff=template(ff)
    end
    return ff
end  # mesh_interpolation

end # module
