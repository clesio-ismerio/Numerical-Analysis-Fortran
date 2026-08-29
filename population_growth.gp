reset

set terminal pngcairo enhanced size 1000,700
set grid

set output 'population_growth.png'
set title 'Logistic Population Growth'
set xlabel 'Time'
set ylabel 'Population'
set key bottom right

carrying_capacity = 1000.0

plot 'population.dat' using 1:2 with lines linewidth 2 \
     title 'RK4 solution', \
     'population.dat' using 1:3 with points pointtype 6 \
     pointinterval 20 title 'Analytical solution', \
     carrying_capacity with lines dashtype 2 \
     title 'Carrying capacity'

set output 'population_growth_rate.png'
set title 'Population Growth Rate'
set xlabel 'Time'
set ylabel 'dP/dt'
set key top right

plot 'population.dat' using 1:4 with lines linewidth 2 \
     title 'Growth rate'

set output 'population_error.png'
set title 'Absolute Error of the RK4 Solution'
set xlabel 'Time'
set ylabel '|P_{numerical} - P_{exact}|'
set logscale y

plot 'population.dat' using 1:5 with lines linewidth 2 \
     title 'Absolute error'

unset output
