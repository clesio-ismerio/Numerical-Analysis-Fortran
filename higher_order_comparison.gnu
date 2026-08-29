reset

set terminal pngcairo enhanced size 1400,900
set output 'higher_order_comparison.png'

set title 'Comparison of Numerical Differentiation Methods'
set xlabel 'x'
set ylabel 'First derivative'
set grid
set key outside right center

plot 'higher_order_comparison.dat' using 1:2 \
     with lines linewidth 3 \
     title 'Exact cos(x)', \
     'higher_order_comparison.dat' using 1:3 \
     with lines \
     title 'Forward O(h)', \
     'higher_order_comparison.dat' using 1:4 \
     with lines \
     title 'Backward O(h)', \
     'higher_order_comparison.dat' using 1:5 \
     with lines \
     title 'Central O(h^2)', \
     'higher_order_comparison.dat' using 1:6 \
     with lines \
     title 'Forward O(h^2)', \
     'higher_order_comparison.dat' using 1:7 \
     with lines \
     title 'Backward O(h^2)', \
     'higher_order_comparison.dat' using 1:8 \
     with lines \
     title 'Central O(h^4)'
