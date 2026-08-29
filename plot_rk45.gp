reset

# File: plot_rk45.gp

set terminal pngcairo enhanced size 1000,700
set output 'rk45_solution.png'

set title 'Adaptive Dormand-Prince RK45 Method'
set xlabel 'x'
set ylabel 'y(x)'
set grid
set key top left

plot 'rk45.dat' using 1:2 with linespoints \
     linewidth 2 pointtype 7 title 'Dormand-Prince RK45', \
     'rk45.dat' using 1:3 with lines \
     linewidth 2 title 'Exact solution'

set output
