set terminal pngcairo enhanced size 1200,800
set output 'false_position_geometry.png'

set title 'Geometrical Interpretation of the False Position Method'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set zeroaxis
set key top left

f(x) = x**3 - x - 2.0

a = 1.0
b = 2.0
fa = f(a)
fb = f(b)

line(x) = fa + (fb-fa)*(x-a)/(b-a)
c = (a*fb-b*fa)/(fb-fa)

set xrange [0.8:2.2]
set yrange [-3.0:5.0]

plot f(x) with lines linewidth 2 title 'f(x)', \
     line(x) with lines linewidth 2 dashtype 2 \
     title 'Secant through interval endpoints', \
     a,fa with points pointtype 7 pointsize 1.5 title '(a,f(a))', \
     b,fb with points pointtype 7 pointsize 1.5 title '(b,f(b))', \
     c,0 with points pointtype 5 pointsize 1.5 \
     title 'False-position estimate'
