reset

set terminal pngcairo enhanced size 1200,800
set output 'simpson_rule.png'

set title "Simpson's 1/3 Rule"
set xlabel 'x'
set ylabel 'f(x)'
set grid
set key top right

set xrange [0:1]
set yrange [0:1.1]

set style fill transparent solid 0.25 border

plot 'simpson_parabola.dat' using 1:2 with filledcurves y1=0 \
     title 'Simpson approximation', \
     'function.dat' using 1:2 with lines linewidth 3 \
     title 'f(x) = exp(-x^2)', \
     'simpson_parabola.dat' using 1:2 with lines linewidth 2 \
     title 'Quadratic interpolant', \
     '-' using 1:2 with points pointtype 7 pointsize 1.5 \
     title 'Integration nodes'
0.0 1.0
0.5 0.7788007831
1.0 0.3678794412
e
