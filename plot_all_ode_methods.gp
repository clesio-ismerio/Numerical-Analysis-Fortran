reset

# File: plot_all_ode_methods.gp

set terminal pngcairo enhanced size 1200,800
set output 'ode_methods_comparison.png'

set title 'Comparison of Numerical Methods for an Initial-Value Problem'
set xlabel 'x'
set ylabel 'y(x)'
set grid
set key top left

plot \
    'euler.dat' using 1:2 with linespoints \
        linewidth 1 pointtype 4 title 'Euler', \
    'improved_euler.dat' using 1:2 with linespoints \
        linewidth 1 pointtype 5 title 'Improved Euler', \
    'heun.dat' using 1:2 with linespoints \
        linewidth 1 pointtype 6 title 'Heun', \
    'rk4.dat' using 1:2 with linespoints \
        linewidth 1 pointtype 7 title 'RK4', \
    'rk45.dat' using 1:2 with linespoints \
        linewidth 2 pointtype 8 title 'Dormand-Prince RK45', \
    'adams_bashforth.dat' using 1:2 with linespoints \
        linewidth 1 pointtype 9 title 'Adams-Bashforth AB4', \
    'rk4.dat' using 1:3 with lines \
        linewidth 3 title 'Exact solution'

set output
