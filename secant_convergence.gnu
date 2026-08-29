set terminal pngcairo enhanced size 1200,800
set output 'secant_convergence.png'

set title 'Convergence of the Secant Method'
set xlabel 'Iteration'
set ylabel 'Absolute difference'
set grid
set logscale y
set key top right

plot 'secant_data.dat' using 1:6 with linespoints \
     linewidth 2 pointtype 7 title '|x_n - x_{n-1}|'
