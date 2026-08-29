reset

# File: plot_rk45_errors.gp

set terminal pngcairo enhanced size 1000,700
set output 'rk45_errors.png'

set title 'Errors of the Dormand-Prince RK45 Method'
set xlabel 'x'
set ylabel 'Error'
set grid
set logscale y
set format y '10^{%L}'
set key top right

plot 'rk45.dat' every ::1 using 1:4 with linespoints \
     linewidth 2 pointtype 7 title 'True absolute error', \
     'rk45.dat' every ::1 using 1:6 with linespoints \
     linewidth 2 pointtype 5 title 'Embedded error estimate'

set output
