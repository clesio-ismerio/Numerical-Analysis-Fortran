reset
    
set terminal pngcairo enhanced size 1200,800
set output 'integration_comparison.png'

set title 'Error Comparison of Numerical Integration Methods'
set xlabel 'Number of subintervals or elements'
set ylabel 'Absolute error'

set logscale x 2
set logscale y

set grid
set key bottom left

plot 'integration_comparison.dat' using 1:2 \
     with linespoints linewidth 2 pointtype 7 \
     title 'Composite trapezoidal', \
     'integration_comparison.dat' using 1:3 \
     with linespoints linewidth 2 pointtype 5 \
     title 'Composite Simpson', \
     'integration_comparison.dat' using 1:4 \
     with linespoints linewidth 2 pointtype 9 \
     title 'Composite 3-point Gaussian'
