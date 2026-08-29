reset
set terminal pngcairo enhanced size 1200,800
set output 'tabulated_differentiation.png'

set title 'Numerical Differentiation of Tabulated Data'
set xlabel 'x'
set ylabel 'Derivative'
set grid
set key top right

plot 'tabulated_differentiation.dat' using 1:3 \
     with linespoints pointtype 7 pointsize 0.4 \
     title 'Numerical derivative', \
     'tabulated_differentiation.dat' using 1:4 \
     with lines linewidth 2 \
     title 'Exact derivative cos(x)'
