reset

# File: plot_rk4.gp

set terminal pngcairo enhanced size 1000,700
set output 'rk4_solution.png'

set title 'Classical Fourth-Order Runge-Kutta Method'
set xlabel 'x'
set ylabel 'y(x)'
set grid
set key top left

plot 'rk4.dat' using 1:2 with linespoints \
     linewidth 2 pointtype 7 title 'RK4', \
     'rk4.dat' using 1:3 with lines \
     linewidth 2 title 'Exact solution'

set output
