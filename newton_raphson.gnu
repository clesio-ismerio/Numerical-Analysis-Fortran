set terminal pngcairo enhanced size 1200,800
set output 'newton_geometry.png'

set title 'Geometrical Interpretation of the Newton--Raphson Method'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set zeroaxis
set key top left

f(x) = x**3 - x - 2.0
df(x) = 3.0*x**2 - 1.0

x0 = 1.8
fx0 = f(x0)
dfx0 = df(x0)

tangent(x) = fx0 + dfx0*(x-x0)
x1 = x0-fx0/dfx0

set xrange [1.0:2.1]
set yrange [-3.0:5.0]

plot f(x) with lines linewidth 2 title 'f(x)', \
     tangent(x) with lines linewidth 2 dashtype 2 \
     title 'Tangent at x_0', \
     x0,fx0 with points pointtype 7 pointsize 1.5 \
     title '(x_0,f(x_0))', \
     x1,0 with points pointtype 5 pointsize 1.5 \
     title 'x_1'
