set grid
set xlabel "x"
set ylabel "sin(x)"
plot "data3.dat" using 1:2 with lines lw 2
pause -1
