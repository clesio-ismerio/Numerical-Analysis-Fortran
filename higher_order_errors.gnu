reset

set terminal pngcairo enhanced size 1400,900
set output 'higher_order_errors.png'

set title 'Absolute Errors of Numerical Differentiation Methods'
set xlabel 'x'
set ylabel 'Absolute error'
set grid
set logscale y
set format y '10^{%L}'
set key outside right center

plot 'higher_order_errors.dat' using 1:2 \
     with lines linewidth 2 \
     title 'Forward O(h)', \
     'higher_order_errors.dat' using 1:3 \
     with lines linewidth 2 \
     title 'Backward O(h)', \
     'higher_order_errors.dat' using 1:4 \
     with lines linewidth 2 \
     title 'Central O(h^2)', \
     'higher_order_errors.dat' using 1:5 \
     with lines linewidth 2 \
     title 'Forward O(h^2)', \
     'higher_order_errors.dat' using 1:6 \
     with lines linewidth 2 \
     title 'Backward O(h^2)', \
     'higher_order_errors.dat' using 1:7 \
     with lines linewidth 2 \
     title 'Central O(h^4)'
