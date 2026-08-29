reset

set terminal pngcairo enhanced size 1200,800
set output 'trapezoidal_rule.png'

set title 'Simple Trapezoidal Rule'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set key top right

set xrange [0:1]
set yrange [0:1.1]

set style fill transparent solid 0.25 border

plot 'trapezoid.dat' using 1:2 with filledcurves y1=0 \
     title 'Trapezoidal approximation', \
     'function.dat' using 1:2 with lines linewidth 3 \
     title 'f(x) = exp(-x^2)', \
     'trapezoid.dat' using 1:2 with lines linewidth 2 \
     title 'Linear interpolant', \
     '-' using 1:2 with points pointtype 7 pointsize 1.5 \
     title 'Integration nodes'
0.0 1.0
1.0 0.3678794412
e
