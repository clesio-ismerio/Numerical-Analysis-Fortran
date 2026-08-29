program rc_circuit
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: dp = real64

    real(dp) :: resistance, capacitance
    real(dp) :: source_voltage, capacitor_voltage
    real(dp) :: time_constant
    real(dp) :: time, dt, final_time
    real(dp) :: exact_voltage, current
    real(dp) :: stored_energy, absolute_error
    integer :: step, number_of_steps
    integer :: output_unit

    resistance      = 1000.0_dp
    capacitance     = 100.0e-6_dp
    source_voltage  = 12.0_dp
    capacitor_voltage = 0.0_dp

    time_constant = resistance * capacitance

    dt = time_constant / 50.0_dp
    final_time = 5.0_dp * time_constant
    number_of_steps = nint(final_time / dt)

    time = 0.0_dp

    open(newunit=output_unit, file='rc_circuit.dat', &
         status='replace', action='write')

    do step = 0, number_of_steps
        exact_voltage = source_voltage * &
                        (1.0_dp - exp(-time/time_constant))

        current = (source_voltage - capacitor_voltage) / resistance

        stored_energy = 0.5_dp * capacitance * &
                        capacitor_voltage**2

        absolute_error = abs(capacitor_voltage - exact_voltage)

        write(output_unit,'(6(es20.10,1x))') &
            time, capacitor_voltage, exact_voltage, &
            current, stored_energy, absolute_error

        if (step < number_of_steps) then
            call rk4_step(time, capacitor_voltage, dt, &
                          resistance, capacitance, source_voltage)
            time = time + dt
        end if
    end do

    close(output_unit)

    print '(a,f12.6)', 'Time constant (s): ', time_constant
    print '(a,f12.6)', 'Final numerical voltage (V): ', &
                       capacitor_voltage
    print '(a)', 'Output file: rc_circuit.dat'

contains

    pure function derivative(voltage, resistance, capacitance, &
                             source_voltage) result(dvdt)
        real(dp), intent(in) :: voltage
        real(dp), intent(in) :: resistance, capacitance
        real(dp), intent(in) :: source_voltage
        real(dp) :: dvdt

        dvdt = (source_voltage - voltage) / &
               (resistance * capacitance)
    end function derivative

    subroutine rk4_step(time, voltage, dt, resistance, capacitance, &
                        source_voltage)
        real(dp), intent(in)    :: time, dt
        real(dp), intent(inout) :: voltage
        real(dp), intent(in)    :: resistance, capacitance
        real(dp), intent(in)    :: source_voltage

        real(dp) :: k1, k2, k3, k4

        ! The equation is autonomous; time is retained for consistency.
        if (time < -huge(time)) stop

        k1 = derivative(voltage, resistance, capacitance, &
                        source_voltage)

        k2 = derivative(voltage + 0.5_dp*dt*k1, &
                        resistance, capacitance, source_voltage)

        k3 = derivative(voltage + 0.5_dp*dt*k2, &
                        resistance, capacitance, source_voltage)

        k4 = derivative(voltage + dt*k3, &
                        resistance, capacitance, source_voltage)

        voltage = voltage + dt * &
                  (k1 + 2.0_dp*k2 + 2.0_dp*k3 + k4) / 6.0_dp
    end subroutine rk4_step

end program rc_circuit
