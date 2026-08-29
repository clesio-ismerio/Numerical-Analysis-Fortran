reset

set terminal pngcairo enhanced size 1200,800
set output 'central_difference_error.png'

set title 'Errors of the Central-Difference Approximations'
set xlabel 'x'
set ylabel 'Absolute error'
set grid
set logscale y
set format y '10^{%L}'
set key top right

plot 'central_difference.dat' using 1:4 \
     with lines linewidth 2 \
     title 'First-derivative error', \
     'central_difference.dat' using 1:7 \
     with lines linewidth 2 \
     title 'Second-derivative error'
