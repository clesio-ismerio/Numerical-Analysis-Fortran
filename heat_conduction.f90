program heat_conduction
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: dp = real64
    integer, parameter :: number_of_nodes = 51

    real(dp), parameter :: length = 1.0_dp
    real(dp), parameter :: diffusivity = 1.0e-4_dp
    real(dp), parameter :: left_temperature = 100.0_dp
    real(dp), parameter :: right_temperature = 0.0_dp
    real(dp), parameter :: initial_temperature = 20.0_dp
    real(dp), parameter :: final_time = 2000.0_dp

    real(dp) :: temperature(number_of_nodes)
    real(dp) :: new_temperature(number_of_nodes)
    real(dp) :: dx, dt, stability_parameter
    real(dp) :: time, x
    real(dp) :: output_interval, next_output_time
    integer :: i, step, number_of_steps
    integer :: output_unit

    dx = length / real(number_of_nodes - 1, dp)

    ! This choice gives r = 0.4, below the stability limit 0.5.
    dt = 0.4_dp * dx**2 / diffusivity

    stability_parameter = diffusivity * dt / dx**2

    if (stability_parameter > 0.5_dp) then
        error stop 'The explicit finite-difference method is unstable.'
    end if

    number_of_steps = ceiling(final_time / dt)

    temperature = initial_temperature
    temperature(1) = left_temperature
    temperature(number_of_nodes) = right_temperature

    new_temperature = temperature

    output_interval = 400.0_dp
    next_output_time = 0.0_dp
    time = 0.0_dp

    open(newunit=output_unit, file='heat.dat', &
         status='replace', action='write')

    do step = 0, number_of_steps

        if (time >= next_output_time - 0.5_dp*dt .or. step == number_of_steps) then

            do i = 1, number_of_nodes
                x = real(i - 1, dp) * dx
                write(output_unit,'(3(es20.10,1x))') x, time, temperature(i)
            end do
            
            write(output_unit,*)

            next_output_time = next_output_time + output_interval
        end if

        if (step == number_of_steps) exit

        do i = 2, number_of_nodes - 1
            new_temperature(i) = temperature(i) + &
                stability_parameter * &
                (temperature(i+1) - 2.0_dp*temperature(i) + &
                 temperature(i-1))
        end do

        new_temperature(1) = left_temperature
        new_temperature(number_of_nodes) = right_temperature

        temperature = new_temperature
        time = time + dt
    end do

    close(output_unit)

    print '(a,f12.6)', 'Spatial step, dx (m):       ', dx
    print '(a,f12.6)', 'Time step, dt (s):          ', dt
    print '(a,f12.6)', 'Stability parameter, r:     ', stability_parameter
    print '(a)', 'Output file: heat.dat'

end program heat_conduction
