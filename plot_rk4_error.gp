reset

# File: plot_rk4_error.gp

set terminal pngcairo enhanced size 1000,700
set output 'rk4_error.png'

set title 'Absolute Error of the RK4 Method'
set xlabel 'x'
set ylabel '|y_n - y(x_n)|'
set grid
set logscale y
set format y '10^{%L}'

plot 'rk4.dat' using 1:4 with linespoints \
     linewidth 2 pointtype 7 title 'Absolute error'

set output
