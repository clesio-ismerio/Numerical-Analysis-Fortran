reset

set terminal pngcairo enhanced size 1000,700
set grid
set key bottom right

set output 'rc_voltage.png'
set title 'Charging of an RC Circuit'
set xlabel 'Time, t (s)'
set ylabel 'Capacitor voltage, V_C (V)'

plot 'rc_circuit.dat' using 1:2 with lines linewidth 2 \
     title 'RK4 solution', \
     'rc_circuit.dat' using 1:3 with points pointtype 6 \
     pointinterval 10 title 'Analytical solution'

set output 'rc_current.png'
set title 'Current During Capacitor Charging'
set xlabel 'Time, t (s)'
set ylabel 'Current, i (A)'

plot 'rc_circuit.dat' using 1:4 with lines linewidth 2 \
     title 'Circuit current'

set output 'rc_error.png'
set title 'Absolute Numerical Error'
set xlabel 'Time, t (s)'
set ylabel '|V_{numerical} - V_{exact}| (V)'
set logscale y

plot 'rc_circuit.dat' using 1:6 with lines linewidth 2 \
     title 'RK4 absolute error'

unset output
