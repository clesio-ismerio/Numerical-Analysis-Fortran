reset

set terminal pngcairo enhanced size 1200,800
set output 'iterative_methods_comparison.png'

set title 'Jacobi and Gauss--Seidel Convergence'
set xlabel 'Iteration'
set ylabel 'Residual infinity norm'

set logscale y
set grid
set key top right

plot 'jacobi_residual.dat' using 1:2 \
     with linespoints linewidth 2 pointtype 7 title 'Jacobi', \
     'gauss_seidel_residual.dat' using 1:2 \
     with linespoints linewidth 2 pointtype 5 \
     title 'Gauss--Seidel'

unset output
