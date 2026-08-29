reset

set terminal pngcairo enhanced size 1200,800
set output 'central_second_derivative.png'

set title 'Central-Difference Approximation of the Second Derivative'
set xlabel 'x'
set ylabel 'Second derivative'
set grid
set key top right

plot 'central_difference.dat' using 1:5 \
     with linespoints pointtype 7 pointsize 0.4 \
     title 'Central second difference', \
     'central_difference.dat' using 1:6 \
     with lines linewidth 2 \
     title 'Exact second derivative -sin(x)'
