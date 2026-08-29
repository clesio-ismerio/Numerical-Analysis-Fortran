reset

set terminal pngcairo enhanced size 1200,800
set output 'gauss_seidel_convergence.png'

set title 'Convergence of the Gauss--Seidel Method'
set xlabel 'Iteration'
set ylabel 'Error or residual infinity norm'

set grid
set logscale y
set key top right

plot 'gauss_seidel_convergence.dat' using 1:2 \
     with linespoints linewidth 2 pointtype 7 \
     title 'Successive-iteration error', \
     'gauss_seidel_convergence.dat' using 1:3 \
     with linespoints linewidth 2 pointtype 5 \
     title 'Residual norm'

unset output
