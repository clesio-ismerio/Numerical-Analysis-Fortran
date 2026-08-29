reset

set terminal pngcairo enhanced size 1000,700
set grid
set key top right

set output 'vibration_displacement.png'
set title 'Forced Damped Mechanical Oscillator'
set xlabel 'Time, t (s)'
set ylabel 'Displacement, x (m)'

plot 'vibration.dat' using 1:2 with lines linewidth 2 \
     title 'Displacement'

set output 'vibration_phase.png'
set title 'Phase-Space Diagram'
set xlabel 'Displacement, x (m)'
set ylabel 'Velocity, v (m/s)'

plot 'vibration.dat' using 2:3 with lines linewidth 2 \
     title 'Phase trajectory'

set output 'vibration_energy.png'
set title 'Mechanical Energy'
set xlabel 'Time, t (s)'
set ylabel 'Energy, E (J)'

plot 'vibration.dat' using 1:5 with lines linewidth 2 \
     title 'Mechanical energy'

unset output
