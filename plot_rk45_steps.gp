reset

# File: plot_rk45_steps.gp

set terminal pngcairo enhanced size 1000,700
set output 'rk45_step_size.png'

set title 'Adaptive Step Size of the Dormand-Prince RK45 Method'
set xlabel 'x'
set ylabel 'Accepted step size'
set grid
set key top right

plot 'rk45.dat' every ::1 using 1:5 with linespoints \
     linewidth 2 pointtype 7 title 'Step size'

set output
