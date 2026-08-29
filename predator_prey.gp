reset

set terminal pngcairo enhanced size 1000,700
set grid

set output 'predator_prey_time.png'
set title 'Lotka--Volterra Predator--Prey Model'
set xlabel 'Time'
set ylabel 'Population'
set key top right

plot 'predator_prey.dat' using 1:2 with lines linewidth 2 \
     title 'Prey', \
     'predator_prey.dat' using 1:3 with lines linewidth 2 \
     title 'Predator'

set output 'predator_prey_phase.png'
set title 'Predator--Prey Phase Diagram'
set xlabel 'Prey population'
set ylabel 'Predator population'
set key top right

prey_equilibrium = 4.0
predator_equilibrium = 2.75

plot 'predator_prey.dat' using 2:3 with lines linewidth 2 \
     title 'Phase trajectory', \
     '+' using (prey_equilibrium):(predator_equilibrium) \
     with points pointtype 7 pointsize 1.5 \
     title 'Coexistence equilibrium'

set output 'predator_prey_invariant.png'
set title 'Lotka--Volterra Conserved Quantity'
set xlabel 'Time'
set ylabel 'H(x,y)'
set key top right

plot 'predator_prey.dat' using 1:6 with lines linewidth 2 \
     title 'Numerical invariant'

unset output
