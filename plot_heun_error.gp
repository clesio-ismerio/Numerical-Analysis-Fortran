reset

# File: plot_heun_error.gp

set terminal pngcairo enhanced size 1000,700
set output 'heun_error.png'

set title 'Absolute Error of the Heun Method'
set xlabel 'x'
set ylabel '|y_n - y(x_n)|'
set grid
set logscale y
set format y '10^{%L}'

plot 'heun.dat' using 1:4 with linespoints \
     linewidth 2 pointtype 7 title 'Absolute error'

set output
