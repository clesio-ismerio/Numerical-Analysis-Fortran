reset

set terminal pngcairo enhanced size 1200,800
set output 'central_first_derivative.png'

set title 'Central-Difference Approximation of the First Derivative'
set xlabel 'x'
set ylabel 'First derivative'
set grid
set key top right

plot 'central_difference.dat' using 1:2 \
     with linespoints pointtype 7 pointsize 0.4 \
     title 'Central difference', \
     'central_difference.dat' using 1:3 \
     with lines linewidth 2 \
     title 'Exact derivative cos(x)'
