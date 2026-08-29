program predator_prey
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: dp = real64

    real(dp) :: alpha, beta, gamma, delta
    real(dp) :: state(2)
    real(dp) :: derivative_vector(2)
    real(dp) :: prey_equilibrium, predator_equilibrium
    real(dp) :: invariant
    real(dp) :: time, dt, final_time
    integer :: step, number_of_steps
    integer :: output_unit

    alpha = 1.10_dp
    beta  = 0.40_dp
    gamma = 0.40_dp
    delta = 0.10_dp

    state(1) = 10.0_dp
    state(2) = 5.0_dp

    dt = 0.01_dp
    final_time = 50.0_dp
    number_of_steps = nint(final_time / dt)

    prey_equilibrium = gamma / delta
    predator_equilibrium = alpha / beta

    time = 0.0_dp

    open(newunit=output_unit, file='predator_prey.dat', &
         status='replace', action='write')

    do step = 0, number_of_steps
        call derivatives(state, derivative_vector, &
                         alpha, beta, gamma, delta)

        invariant = delta * state(1) - &
                    gamma * log(state(1)) + &
                    beta * state(2) - &
                    alpha * log(state(2))

        write(output_unit,'(6(es20.10,1x))') &
            time, state(1), state(2), &
            derivative_vector(1), derivative_vector(2), invariant

        if (step < number_of_steps) then
            call rk4_step(time, state, dt, &
                          alpha, beta, gamma, delta)
            time = time + dt
        end if

        if (any(state <= 0.0_dp)) then
            error stop 'A nonphysical population value was obtained.'
        end if
    end do

    close(output_unit)

    print '(a,f12.5)', 'Equilibrium prey population:     ', &
                       prey_equilibrium
    print '(a,f12.5)', 'Equilibrium predator population: ', &
                       predator_equilibrium
    print '(a)', 'Output file: predator_prey.dat'

contains

    subroutine derivatives(state, derivative_vector, &
                           alpha, beta, gamma, delta)
        real(dp), intent(in)  :: state(2)
        real(dp), intent(out) :: derivative_vector(2)
        real(dp), intent(in)  :: alpha, beta, gamma, delta

        real(dp) :: prey, predator

        prey = state(1)
        predator = state(2)

        derivative_vector(1) = alpha * prey - &
                               beta * prey * predator

        derivative_vector(2) = delta * prey * predator - &
                               gamma * predator
    end subroutine derivatives

    subroutine rk4_step(time, state, dt, &
                        alpha, beta, gamma, delta)
        real(dp), intent(in)    :: time, dt
        real(dp), intent(inout) :: state(2)
        real(dp), intent(in)    :: alpha, beta, gamma, delta

        real(dp) :: k1(2), k2(2), k3(2), k4(2)
        real(dp) :: temporary_state(2)

        if (time < -huge(time)) stop

        call derivatives(state, k1, alpha, beta, gamma, delta)

        temporary_state = state + 0.5_dp * dt * k1
        call derivatives(temporary_state, k2, &
                         alpha, beta, gamma, delta)

        temporary_state = state + 0.5_dp * dt * k2
        call derivatives(temporary_state, k3, &
                         alpha, beta, gamma, delta)

        temporary_state = state + dt * k3
        call derivatives(temporary_state, k4, &
                         alpha, beta, gamma, delta)

        state = state + dt * &
            (k1 + 2.0_dp*k2 + 2.0_dp*k3 + k4) / 6.0_dp
    end subroutine rk4_step

end program predator_prey
