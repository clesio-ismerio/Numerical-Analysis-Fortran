set terminal pngcairo enhanced size 1400,900
set output 'root_methods_comparison.png'

set title 'Comparison of Root-Finding Methods'
set xlabel 'Iteration'
set ylabel 'Absolute difference between successive estimates'
set grid
set logscale y
set key top right

plot \
'comparison_bisection.dat' using 1:3 with linespoints \
linewidth 2 pointtype 7 title 'Bisection', \
'comparison_false_position.dat' using 1:3 with linespoints \
linewidth 2 pointtype 5 title 'False position', \
'comparison_fixed_point.dat' using 1:3 with linespoints \
linewidth 2 pointtype 9 title 'Fixed point', \
'comparison_newton.dat' using 1:3 with linespoints \
linewidth 2 pointtype 11 title 'Newton--Raphson', \
'comparison_secant.dat' using 1:3 with linespoints \
linewidth 2 pointtype 13 title 'Secant'
