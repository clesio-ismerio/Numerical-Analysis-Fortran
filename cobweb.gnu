set terminal pngcairo enhanced size 1200,800
set output 'fixed_point_cobweb.png'

set title 'Cobweb Diagram for Fixed-Point Iteration'
set xlabel 'x'
set ylabel 'y'
set grid
set key top left

g(x) = (x+2.0)**(1.0/3.0)

x0 = 1.0
iterations = 12

# Write iteration data to file
set print 'cobweb_data.dat'

xold = x0
print xold, 0.0

do for [i=1:iterations] {
    xnew = g(xold)

    # Vertical segment: (x_n, x_n) -> (x_n, x_{n+1})
    print xold, xold
    print xold, xnew

    # Horizontal segment: (x_n, x_{n+1}) -> (x_{n+1}, x_{n+1})
    print xnew, xnew

    xold = xnew
}

unset print

set xrange [0.8:2.0]
set yrange [0.8:2.0]

plot g(x) with lines linewidth 2 title 'y = g(x)', \
     x with lines linewidth 2 dashtype 2 title 'y = x', \
     'cobweb_data.dat' using 1:2 with linespoints \
     linewidth 1.5 pointtype 7 title 'Iterations'

unset output
