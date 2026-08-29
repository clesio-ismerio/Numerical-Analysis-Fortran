reset

set terminal pngcairo enhanced size 1200,800
set output 'gauss_seidel_components.png'

set title 'Gauss--Seidel Iteration: Evolution of the Solution Components'
set xlabel 'Iteration'
set ylabel 'Approximate value'

set grid
set key bottom right

plot 'gauss_seidel_convergence.dat' using 1:4 \
     with linespoints linewidth 2 pointtype 7 title 'x_1', \
     'gauss_seidel_convergence.dat' using 1:5 \
     with linespoints linewidth 2 pointtype 5 title 'x_2', \
     'gauss_seidel_convergence.dat' using 1:6 \
     with linespoints linewidth 2 pointtype 9 title 'x_3'

unset output
