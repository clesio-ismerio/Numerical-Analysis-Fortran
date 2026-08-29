reset

set terminal pngcairo enhanced size 1000,700
set output 'improved_euler_solution.png'

set title 'Improved Euler Method: Explicit Midpoint Method'
set xlabel 'x'
set ylabel 'y(x)'
set grid
set key top left

plot 'improved_euler.dat' using 1:2 with linespoints \
     linewidth 2 pointtype 7 title 'Improved Euler', \
     'improved_euler.dat' using 1:3 with lines \
     linewidth 2 title 'Exact solution'

set output
