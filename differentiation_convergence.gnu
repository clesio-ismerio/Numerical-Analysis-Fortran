reset

set terminal pngcairo enhanced size 1200,850
set output 'differentiation_convergence.png'

set title 'Convergence of Finite-Difference Approximations'
set xlabel 'Step size h'
set ylabel 'Absolute error'
set grid
set logscale xy
set format x '10^{%L}'
set format y '10^{%L}'
set key top left

plot 'differentiation_convergence.dat' using 1:2 \
     with linespoints pointtype 7 \
     title 'Forward O(h)', \
     'differentiation_convergence.dat' using 1:3 \
     with linespoints pointtype 5 \
     title 'Central O(h^2)', \
     'differentiation_convergence.dat' using 1:4 \
     with linespoints pointtype 9 \
     title 'Central O(h^4)'
