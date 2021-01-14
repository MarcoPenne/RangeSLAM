%syms x y real;
close all

addpath '../visualization'

xc1 = 4;
yc1 = 5;
r1 = 6;

C1 = [1 0 -xc1;
    0 1 -yc1;
    -xc1 -yc1 xc1*xc1+yc1*yc1-r1*r1];
%simplify([x y 1]*C1*[x; y; 1])

xc2 = 7;
yc2 = 2;
r2 = 1;

C2 = [1 0 -xc2;
    0 1 -yc2;
    -xc2 -yc2 xc2*xc2+yc2*yc2-r2*r2];
%simplify([x y 1]*C2*[x; y; 1])

circle(xc1, yc1, r1)
circle(xc2, yc2, r2)

syms x1 x2 real;
x = [x1 x2]
x(1)
x(2)
[x 1]*C1*[x'; 1]
f = @(x) (norm(x-[xc1 yc1]) - r1)^2 + (norm(x-[xc2 yc2]) - r2)^2

sol = fminunc(f, [0,0])
hold on
sol(1)
plot(sol(1), sol(2), 'b*', "linewidth", 2)