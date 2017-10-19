using PyPlot
# x = [1 2 3 4 5]
# f = [10 11 15 20 8]
x = linspace(0, pi, 10)
f = cos
y = f(x)
# x = collect(0:0.5:pi)
# f = sin.(x)
n = length(x) - 1;

A = zeros(4*n,4*n);
row = 1;
 for col=1:4:4*n
  A[row,col]=1;
  A[row+1,col]=1;
  row = row +2;
 end

row =1;
index =1;
 for col =2:4:4* n
  A[row,col]= x[index];
  A[row,col+1]= x[index]^2;
  A[row,col+2]= x[index]^3;
  index = index +1;
  row = row +2;
 end

 row =2;
 index =2;
  for col =2:4:4* n
   A[row,col]= x[index];
   A[row,col+1]= x[index]^2;
   A[row,col+2]= x[index]^3;
   index = index +1;
   row = row +2;
  end

row =2* n +1;
index =2;
  for col =2:4:4* n -4
   A[row,col]=1;
   A[row,col+1]=2* x[index];
   A[row,col+2]=3* x[index]^2;
   index = index +1;
   row = row +1;
  end

row =2* n +1;
index =2;
  for col=6:4:4* n
   A[row,col]= -1;
   A[row,col+1]= -2* x[index];
   A[row,col+2]= -3* x[index]^2;
   index = index +1;
   row = row +1;
  end

row =3* n ;
index =2;
  for col =3:4:4* n -4
   A[row,col]=2;
   A[row,col+1]=6* x[index];
   index = index +1;
   row = row +1;
  end

row =3*n ;
index =2;
 for col =7:4:4* n
  A[row,col]= -2;
  A[row,col+1]= -6* x[index];
  index = index +1;
  row = row +1;
 end

A[4*n-1,3]=2;
A[4*n-1,4]=6*x[1];
A[4*n,4*n-1]=2;
A[4*n,4*n]=6*x[n+1];

y = zeros(4*n,1);
y[1]= f[1];
 for i = 2:2:(2*n-2)
  s=convert(Int, (i/2+1))
  y[i]= f[s];
  y[i+1]= f[s];
 end
y[2*n]= f[end]
cof=A\y

function heaviside(x)
   0.5 * (sign(x) + 1)
end

function interval(x, a, b)
 heaviside(x-a) - heaviside(x-b)
end

# ps = zeros(Int(length(cof) / 4))
ps = Vector{Function}(Int(length(cof) / 4))
for j = 1 : length(ps)
    ps[j] = t -> cof[4*j-3] + cof[4*j-3+1]*t + cof[4*j-3+2]*t^2 + cof[4*j-3+3]*t^3
end

function p(t)
    if t == x[1]
        return f[1]
    elseif t == x[end]
        return f[end]
    else
        return sum([ps[i](t) * interval(t, x[i], x[i + 1]) for i = 1 : length(ps)])
    end
end

n_point=500
domain=linspace(x[1],x[end],n_point)
# domain = collect(x[1] : 0.125 :x[end])
range = map(p, domain)
range2= map(p,x)
plot(domain, range)
plot(x,range2,".")

plot(x, f, ".")
title("Cubic Spline Polynomial Interpolation")
legend(loc="upper right")
xlabel("x")
ylabel("y")

figure()

tol=5e-16
s=abs.(sin.(domain))
t=abs.(sin.(domain)-range)
s_p=abs.(sin.(x))
t_p=abs.(sin.(x)-map(p,x))
# t[1]<tol ? t[1]=0 : nothing
# t[end]<tol ? t[end]=0 : nothing
# s[1]<tol ?
error_p=t_p./s_p
error=t./s
z_i=t.<tol
idx=1:length(error)
error[z_i]=0
error[(s.<tol) & z_i]=NaN
# error_p[(s_p.<tol) & t_p.<tol]=0
plot(domain,error)
plot(x,error_p,"o")
title("Error function")
xlabel("x")
ylabel("y")











# p=zeros(100)
# for j=1:n
#  t=linspace(x[j],x[j+1],100)
#  p=zeros(100)
#  for i=1:100
#    p[i]=cof[4*j-3]+cof[4*j-3+1]*t[i]+cof[4*j-3+2]*t[i].^2+cof[4*j-3+3]*t[i].^3
#  end
#  scatter(t,p,2,label="Cubic spline polynomial interpolation")
#  # plot(x, y, ".", label=" Data set ")
#  # title("Cubic Spline Polynomial Interpolation")
#  # legend(loc="upper right")
#  # xlabel("x")
#  # ylabel("y")
# end
