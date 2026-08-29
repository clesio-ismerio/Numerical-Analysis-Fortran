set terminal pngcairo enhanced size 1200,800
set output 'secant_geometry.png'

set title 'Geometrical Interpretation of the Secant Method'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set zeroaxis
set key top left

f(x) = x**3 - x - 2.0

x0 = 1.0
x1 = 2.0
f0 = f(x0)
f1 = f(x1)

secant(x) = f0 + (f1-f0)*(x-x0)/(x1-x0)
x2 = x1-f1*(x1-x0)/(f1-f0)

set xrange [0.8:2.2]
set yrange [-3.0:5.0]

plot f(x) with lines linewidth 2 title 'f(x)', \
     secant(x) with lines linewidth 2 dashtype 2 \
     title 'Secant line', \
     x0,f0 with points pointtype 7 pointsize 1.5 \
     title '(x_0,f(x_0))', \
     x1,f1 with points pointtype 7 pointsize 1.5 \
     title '(x_1,f(x_1))', \
     x2,0 with points pointtype 5 pointsize 1.5 \
     title 'x_2'
