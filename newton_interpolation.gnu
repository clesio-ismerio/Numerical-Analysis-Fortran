reset

set terminal pngcairo enhanced size 1200,800
set output 'newton_interpolation.png'

set title 'Newton Interpolation with Divided Differences'
set xlabel 'x'
set ylabel 'y'

set grid
set key bottom right
set border linewidth 1.2

plot 'newton_curve.dat' using 1:2 with lines linewidth 2 \
     title 'Newton polynomial', \
     'newton_curve.dat' using 1:3 with lines dashtype 2 \
     linewidth 2 title 'Exact function sin(x)', \
     'newton_points.dat' using 1:2 with points pointtype 7 \
     pointsize 1.5 title 'Interpolation nodes'

set output
