reset

set terminal pngcairo enhanced size 1200,850
set output 'differentiation_orders.png'

set title 'Observed Orders of Accuracy'
set xlabel 'Step size h'
set ylabel 'Observed order p'
set grid
set logscale x
set format x '10^{%L}'
set yrange [0:5]
set key top right

plot 'differentiation_convergence.dat' every ::1 using 1:5 \
     with linespoints pointtype 7 \
     title 'Forward difference', \
     'differentiation_convergence.dat' every ::1 using 1:6 \
     with linespoints pointtype 5 \
     title 'Central difference', \
     'differentiation_convergence.dat' every ::1 using 1:7 \
     with linespoints pointtype 9 \
     title 'Fourth-order central difference', \
     1.0 with lines dashtype 2 title 'Theoretical order 1', \
     2.0 with lines dashtype 2 title 'Theoretical order 2', \
     4.0 with lines dashtype 2 title 'Theoretical order 4'
