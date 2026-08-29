set terminal pngcairo enhanced size 1200,800
set output 'bisection_function.png'

set title 'Root of f(x) = x^3 - x - 2'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set key top left
set zeroaxis

f(x) = x**3 - x - 2.0
root = 1.5213797068

set xrange [0.8:2.2]

plot f(x) with lines linewidth 2 title 'f(x)', \
     0 with lines dashtype 2 title 'y = 0', \
     root,0 with points pointtype 7 pointsize 1.5 \
     title 'Approximate root'
