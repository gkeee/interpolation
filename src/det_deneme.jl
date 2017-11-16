include("../src/gmsh.jl")
using  gmsh
using Plots
mesh = gmsh.read("/home/gizemkalender/Desktop/interpolation/src/t1.msh")
plt =scatter(mesh.nodes[1:end, 1], mesh.nodes[1:end, 2])
# for i = 1:40
i=15
        p1 = mesh.elements[i,1:end][1]
        p2 = mesh.elements[i,1:end][2]
        p3 = mesh.elements[i,1:end][3]
        plot!([mesh.nodes[p1, 1], mesh.nodes[p2, 1], mesh.nodes[p3, 1], mesh.nodes[p1, 1]],
        [mesh.nodes[p1, 2], mesh.nodes[p2, 2], mesh.nodes[p3, 2], mesh.nodes[p1, 2]])
#         i += 1
# end
scatter!(mesh.nodes[1:3,1], mesh.nodes[1:3,2] ,color="red", m=5)
display(plt)

px=0.25;
py=0.1;

for i = 1:40
        m_e = mesh.elements
        m_n = mesh.nodes
        A1 = [px py 1;
              m_n[m_e[i,1],1] m_n[m_e[i,1],2] 1;
              m_n[m_e[i,2],1] m_n[m_e[i,2],2] 1]
        det1 = det(A1)
        A2 = [px py 1;
              m_n[m_e[i,3],1] m_n[m_e[i,3],2] 1;
              m_n[m_e[i,1],1] m_n[m_e[i,1],2] 1]
        det2 = det(A2)
        A3 = [px py 1;
              m_n[m_e[i,2],1] m_n[m_e[i,2],2] 1;
              m_n[m_e[i,3],1] m_n[m_e[i,3],2] 1]
        det3 = det(A3)
         if det1 >= 0 && det2 >= 0 && det3 >= 0
              println(i)
              break
         end
end
