reset

set terminal pngcairo enhanced size 1200,800
set output 'polynomial_interpolation.png'

set title 'Polynomial Interpolation Using a Vandermonde System'
set xlabel 'x'
set ylabel 'p(x)'

set grid
set key top left
set border linewidth 1.2
set samples 500

plot 'polynomial_curve.dat' using 1:2 with lines linewidth 2 \
     title 'Interpolating polynomial', \
     'polynomial_points.dat' using 1:2 with points pointtype 7 \
     pointsize 1.5 title 'Data points'

set output
