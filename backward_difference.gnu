reset

set terminal pngcairo enhanced size 1200,800
set output 'backward_difference.png'

set title 'Backward-Difference Approximation'
set xlabel 'x'
set ylabel 'Derivative'
set grid
set key top right

plot 'backward_difference.dat' using 1:3 \
     with linespoints pointtype 7 pointsize 0.4 \
     title 'Backward difference', \
     'backward_difference.dat' using 1:4 \
     with lines linewidth 2 \
     title 'Exact derivative cos(x)'
