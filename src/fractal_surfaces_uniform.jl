include("../src/gmsh.jl")
using  gmsh
using Plots
plotly()

mesh = gmsh.read("/home/gizemkalender/Desktop/interpolation/src/t1.msh")
