reset

# File: plot_adams_bashforth_error.gp

set terminal pngcairo enhanced size 1000,700
set output 'adams_bashforth_error.png'

set title 'Absolute Error of the Adams-Bashforth AB4 Method'
set xlabel 'x'
set ylabel '|y_n - y(x_n)|'
set grid
set logscale y
set format y '10^{%L}'

plot 'adams_bashforth.dat' using 1:4 with linespoints \
     linewidth 2 pointtype 7 title 'Absolute error'

set output
