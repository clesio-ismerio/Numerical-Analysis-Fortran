reset

set terminal pngcairo enhanced size 1000,700
set output 'projectile_trajectory.png'

set title 'Projectile Motion with Quadratic Aerodynamic Drag'
set xlabel 'Horizontal distance, x (m)'
set ylabel 'Vertical distance, y (m)'
set grid
set key top right
set xrange [0:*]
set yrange [0:*]

plot 'projectile.dat' using 2:3 with lines linewidth 2 \
     title 'Trajectory with drag'

set output 'projectile_velocity.png'
set title 'Projectile Velocity Components'
set xlabel 'Time, t (s)'
set ylabel 'Velocity (m/s)'

plot 'projectile.dat' using 1:4 with lines linewidth 2 \
     title 'v_x', \
     'projectile.dat' using 1:5 with lines linewidth 2 \
     title 'v_y', \
     'projectile.dat' using 1:6 with lines linewidth 2 \
     title 'Speed'

unset output
