reset

set terminal pngcairo enhanced size 1200,800
set output 'forward_difference_error.png'

set title 'Absolute Error of the Forward Difference'
set xlabel 'x'
set ylabel 'Absolute error'
set grid
set logscale y
set format y '10^{%L}'
set key top right

plot 'forward_difference.dat' using 1:5 \
     with lines linewidth 2 \
     title '|Numerical - Exact|'
