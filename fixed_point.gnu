set terminal pngcairo enhanced size 1200,800
set output 'fixed_point_intersection.png'

set title 'Fixed Point of g(x) = (x+2)^{1/3}'
set xlabel 'x'
set ylabel 'y'
set grid
set key top left

g(x) = (x+2.0)**(1.0/3.0)

set xrange [0.5:2.5]
set yrange [0.5:2.5]

plot g(x) with lines linewidth 2 title 'y = g(x)', \
     x with lines linewidth 2 dashtype 2 title 'y = x'
