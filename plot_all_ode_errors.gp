reset

# File: plot_all_ode_errors.gp

set terminal pngcairo enhanced size 1200,800
set output 'ode_methods_errors.png'

set title 'Absolute Errors of the Numerical ODE Methods'
set xlabel 'x'
set ylabel '|y_n - y(x_n)|'
set grid
set logscale y
set format y '10^{%L}'
set key top right

plot \
    'euler.dat' using 1:4 with linespoints \
        linewidth 1 pointtype 4 title 'Euler', \
    'improved_euler.dat' using 1:4 with linespoints \
        linewidth 1 pointtype 5 title 'Improved Euler', \
    'heun.dat' using 1:4 with linespoints \
        linewidth 1 pointtype 6 title 'Heun', \
    'rk4.dat' using 1:4 with linespoints \
        linewidth 1 pointtype 7 title 'RK4', \
    'rk45.dat' every ::1 using 1:4 with linespoints \
        linewidth 2 pointtype 8 title 'Dormand-Prince RK45', \
    'adams_bashforth.dat' using 1:4 with linespoints \
        linewidth 1 pointtype 9 title 'Adams-Bashforth AB4'

set output
