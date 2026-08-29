reset

# File: plot_heun.gp

set terminal pngcairo enhanced size 1000,700
set output 'heun_solution.png'

set title 'Heun Method'
set xlabel 'x'
set ylabel 'y(x)'
set grid
set key top left

plot 'heun.dat' using 1:2 with linespoints \
     linewidth 2 pointtype 7 title 'Heun method', \
     'heun.dat' using 1:3 with lines \
     linewidth 2 title 'Exact solution'

set output
