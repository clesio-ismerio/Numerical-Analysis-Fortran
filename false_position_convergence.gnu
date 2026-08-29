set terminal pngcairo enhanced size 1200,800
set output 'false_position_convergence.png'

set title 'Convergence of the False Position Method'
set xlabel 'Iteration'
set ylabel 'Absolute difference between successive estimates'
set grid
set logscale y
set key top right

plot 'false_position_data.dat' using 1:6 with linespoints \
     linewidth 2 pointtype 7 title '|x_n - x_{n-1}|'
