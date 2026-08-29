reset

set terminal pngcairo enhanced size 1200,800
set output 'cubic_spline_interpolation.png'

set title 'Natural Cubic Spline Interpolation'
set xlabel 'x'
set ylabel 'y'

set grid
set key top right
set border linewidth 1.2

plot 'spline_curve.dat' using 1:2 with lines linewidth 2 \
     title 'Natural cubic spline', \
     'spline_curve.dat' using 1:3 with lines dashtype 2 \
     linewidth 2 title 'Exact function', \
     'spline_points.dat' using 1:2 with points pointtype 7 \
     pointsize 1.5 title 'Interpolation nodes'

set output
