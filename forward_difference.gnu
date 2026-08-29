reset

set terminal pngcairo enhanced size 1200,800
set output 'forward_difference.png'

set title 'Forward-Difference Approximation'
set xlabel 'x'
set ylabel 'Derivative'
set grid
set key top right

plot 'forward_difference.dat' using 1:3 \
     with linespoints pointtype 7 pointsize 0.4 \
     title 'Forward difference', \
     'forward_difference.dat' using 1:4 \
     with lines linewidth 2 \
     title 'Exact derivative cos(x)'
