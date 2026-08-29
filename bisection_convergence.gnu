set terminal pngcairo enhanced size 1200,800
set output 'bisection_convergence.png'

set title 'Convergence of the Bisection Method'
set xlabel 'Iteration'
set ylabel 'Estimated error'
set grid
set logscale y
set key top right

plot 'bisection_data.dat' using 1:6 with linespoints \
     linewidth 2 pointtype 7 title 'Estimated error'
