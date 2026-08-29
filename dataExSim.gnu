set grid
set xlabel "x"
set ylabel "y"
set title "Experiment and Simulation Example"
plot "data1.dat" using 1:2 with lines title "Experiment", \
     "data2.dat" using 1:2 with linespoints title "Simulation"
