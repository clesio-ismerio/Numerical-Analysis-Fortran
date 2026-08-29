reset

set terminal pngcairo enhanced size 1200,800
set output 'gaussian_quadrature.png'

set title 'Three-Point Gauss-Legendre Quadrature'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set key top right

set xrange [0:1]
set yrange [0:1.1]

plot 'function.dat' using 1:2 with lines linewidth 3 \
     title 'f(x) = exp(-x^2)', \
     'gaussian_nodes.dat' using 1:2 \
     with impulses linewidth 2 \
     title 'Gaussian nodes', \
     'gaussian_nodes.dat' using 1:2:($3*2.5) \
     with points pointtype 7 pointsize variable \
     title 'Node weight'
