reset

# File: plot_adams_bashforth.gp

set terminal pngcairo enhanced size 1000,700
set output 'adams_bashforth_solution.png'

set title 'Fourth-Order Adams-Bashforth Method'
set xlabel 'x'
set ylabel 'y(x)'
set grid
set key top left

plot 'adams_bashforth.dat' using 1:2 with linespoints \
     linewidth 2 pointtype 7 title 'Adams-Bashforth AB4', \
     'adams_bashforth.dat' using 1:3 with lines \
     linewidth 2 title 'Exact solution'

set output
