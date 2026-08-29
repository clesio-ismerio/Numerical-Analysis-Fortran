program mechanical_vibration
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: dp = real64

    real(dp) :: mass, damping, stiffness
    real(dp) :: force_amplitude, excitation_frequency
    real(dp) :: natural_frequency, damping_ratio
    real(dp) :: initial_displacement, initial_velocity
    real(dp) :: time, final_time, dt
    real(dp) :: state(2)
    real(dp) :: force, energy
    integer :: number_of_steps, step
    integer :: output_unit

    mass                 = 1.0_dp
    damping              = 0.40_dp
    stiffness            = 20.0_dp
    force_amplitude      = 2.0_dp
    excitation_frequency = 4.0_dp

    initial_displacement = 0.10_dp
    initial_velocity     = 0.0_dp

    dt         = 0.005_dp
    final_time = 20.0_dp

    natural_frequency = sqrt(stiffness / mass)
    damping_ratio = damping / &
                    (2.0_dp * sqrt(stiffness * mass))

    state(1) = initial_displacement
    state(2) = initial_velocity
    time = 0.0_dp

    number_of_steps = nint(final_time / dt)

    open(newunit=output_unit, file='vibration.dat', &
         status='replace', action='write')

    do step = 0, number_of_steps
        force = force_amplitude * &
                cos(excitation_frequency * time)

        energy = 0.5_dp * mass * state(2)**2 + &
                 0.5_dp * stiffness * state(1)**2

        write(output_unit,'(5(es20.10,1x))') &
            time, state(1), state(2), force, energy

        if (step < number_of_steps) then
            call rk4_step(time, state, dt, mass, damping, &
                          stiffness, force_amplitude, &
                          excitation_frequency)
            time = time + dt
        end if
    end do

    close(output_unit)

    print '(a,f12.6)', 'Natural angular frequency (rad/s): ', &
                       natural_frequency
    print '(a,f12.6)', 'Damping ratio:                     ', &
                       damping_ratio
    print '(a)', 'Output file: vibration.dat'

contains

    subroutine derivatives(time, state, derivative, mass, damping, &
                           stiffness, force_amplitude, &
                           excitation_frequency)
        real(dp), intent(in)  :: time
        real(dp), intent(in)  :: state(2)
        real(dp), intent(out) :: derivative(2)
        real(dp), intent(in)  :: mass, damping, stiffness
        real(dp), intent(in)  :: force_amplitude
        real(dp), intent(in)  :: excitation_frequency

        real(dp) :: external_force

        external_force = force_amplitude * &
                         cos(excitation_frequency * time)

        derivative(1) = state(2)
        derivative(2) = (external_force - &
                         damping * state(2) - &
                         stiffness * state(1)) / mass
    end subroutine derivatives

    subroutine rk4_step(time, state, dt, mass, damping, stiffness, &
                        force_amplitude, excitation_frequency)
        real(dp), intent(in)    :: time, dt
        real(dp), intent(inout) :: state(2)
        real(dp), intent(in)    :: mass, damping, stiffness
        real(dp), intent(in)    :: force_amplitude
        real(dp), intent(in)    :: excitation_frequency

        real(dp) :: k1(2), k2(2), k3(2), k4(2)
        real(dp) :: temporary_state(2)

        call derivatives(time, state, k1, mass, damping, stiffness, &
                         force_amplitude, excitation_frequency)

        temporary_state = state + 0.5_dp * dt * k1
        call derivatives(time + 0.5_dp*dt, temporary_state, k2, &
                         mass, damping, stiffness, force_amplitude, &
                         excitation_frequency)

        temporary_state = state + 0.5_dp * dt * k2
        call derivatives(time + 0.5_dp*dt, temporary_state, k3, &
                         mass, damping, stiffness, force_amplitude, &
                         excitation_frequency)

        temporary_state = state + dt * k3
        call derivatives(time + dt, temporary_state, k4, &
                         mass, damping, stiffness, force_amplitude, &
                         excitation_frequency)

        state = state + dt * &
            (k1 + 2.0_dp*k2 + 2.0_dp*k3 + k4) / 6.0_dp
    end subroutine rk4_step

end program mechanical_vibration
