reset

set terminal pngcairo enhanced size 1200,800
set output 'lagrange_interpolation.png'

set title 'Lagrange Polynomial Interpolation'
set xlabel 'x'
set ylabel 'p(x)'

set grid
set key top left
set border linewidth 1.2

plot 'lagrange_curve.dat' \
using 1:2 with lines linewidth 2 \
     title 'Lagrange polynomial', \
     'lagrange_points.dat' \
     using 1:2 with points pointtype 7 \
     pointsize 1.5 title 'Data points'

set output
