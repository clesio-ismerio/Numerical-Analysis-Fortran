reset

set terminal pngcairo enhanced size 1200,800
set output 'composite_trapezoidal.png'

set title 'Composite Trapezoidal Rule with n = 8'
set xlabel 'x'
set ylabel 'f(x)'
set grid
set key top right

f(x) = exp(-x*x)

a = 0.0
b = 1.0
n = 8
h = (b-a)/n

set xrange [a:b]
set yrange [0:1.1]

set style fill transparent solid 0.20 border

plot f(x) with lines linewidth 3 title 'f(x) = exp(-x^2)', \
     for [i=0:n-1] \
     [a+i*h:a+(i+1)*h] \
     (f(a+i*h) + \
     (f(a+(i+1)*h)-f(a+i*h)) * \
     (x-(a+i*h))/h) \
     with filledcurves y1=0 notitle, \
     for [i=0:n-1] \
     [a+i*h:a+(i+1)*h] \
     (f(a+i*h) + \
     (f(a+(i+1)*h)-f(a+i*h)) * \
     (x-(a+i*h))/h) \
     with lines linewidth 1 notitle
