reset

set terminal pngcairo enhanced size 1200,800
set output 'quadrature_errors.png'

set title 'Convergence of Composite Quadrature Methods'
set xlabel 'Number of subintervals, n'
set ylabel 'Absolute error'

set logscale x 2
set logscale y

set grid
set key bottom left

plot 'quadrature_errors.dat' using 1:2 \
     with linespoints linewidth 2 pointtype 7 \
     title 'Composite trapezoidal rule', \
     'quadrature_errors.dat' using 1:3 \
     with linespoints linewidth 2 pointtype 5 \
     title "Composite Simpson's rule"
