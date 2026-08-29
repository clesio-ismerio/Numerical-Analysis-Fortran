program projectile_motion
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: dp = real64
    real(dp), parameter :: pi = acos(-1.0_dp)

    real(dp) :: mass, diameter, area
    real(dp) :: rho, cd, gravity, drag_parameter
    real(dp) :: initial_speed, angle_deg, angle_rad
    real(dp) :: dt, time
    real(dp) :: state(4), old_state(4)
    real(dp) :: old_time
    real(dp) :: fraction, impact_time, impact_range
    integer :: output_unit

    mass          = 0.145_dp
    diameter      = 0.073_dp
    rho           = 1.225_dp
    cd            = 0.47_dp
    gravity       = 9.81_dp
    initial_speed = 50.0_dp
    angle_deg     = 45.0_dp
    dt            = 0.01_dp

    area = pi * diameter**2 / 4.0_dp
    drag_parameter = rho * cd * area / (2.0_dp * mass)

    angle_rad = angle_deg * pi / 180.0_dp

    state(1) = 0.0_dp
    state(2) = 0.0_dp
    state(3) = initial_speed * cos(angle_rad)
    state(4) = initial_speed * sin(angle_rad)

    time = 0.0_dp

    open(newunit=output_unit, file='projectile.dat', &
         status='replace', action='write')

    write(output_unit,'(6(es20.10,1x))') &
        time, state(1), state(2), state(3), state(4), &
        sqrt(state(3)**2 + state(4)**2)

    do
        old_state = state
        old_time  = time

        call rk4_step(time, state, dt, drag_parameter, gravity)

        time = time + dt

        if (state(2) >= 0.0_dp) then
            write(output_unit,'(6(es20.10,1x))') &
                time, state(1), state(2), state(3), state(4), &
                sqrt(state(3)**2 + state(4)**2)
        end if

        if (state(2) < 0.0_dp .and. time > dt) exit
    end do

    close(output_unit)

    fraction = old_state(2) / (old_state(2) - state(2))
    impact_time = old_time + fraction * dt
    impact_range = old_state(1) + &
                   fraction * (state(1) - old_state(1))

    print '(a,f12.5)', 'Flight time (s):       ', impact_time
    print '(a,f12.5)', 'Horizontal range (m):  ', impact_range
    print '(a,f12.5)', 'Drag parameter (1/m):  ', drag_parameter
    print '(a)',      'Output file: projectile.dat'

contains

    subroutine derivatives(state, derivative, drag_parameter, gravity)
        real(dp), intent(in)  :: state(4)
        real(dp), intent(out) :: derivative(4)
        real(dp), intent(in)  :: drag_parameter, gravity
        real(dp) :: speed

        speed = sqrt(state(3)**2 + state(4)**2)

        derivative(1) = state(3)
        derivative(2) = state(4)
        derivative(3) = -drag_parameter * speed * state(3)
        derivative(4) = -gravity - &
                        drag_parameter * speed * state(4)
    end subroutine derivatives

    subroutine rk4_step(time, state, dt, drag_parameter, gravity)
        real(dp), intent(in)    :: time, dt
        real(dp), intent(inout) :: state(4)
        real(dp), intent(in)    :: drag_parameter, gravity

        real(dp) :: k1(4), k2(4), k3(4), k4(4)
        real(dp) :: temporary_state(4)

        ! The equations are autonomous, so time is not explicitly used.
        if (time < -huge(time)) stop

        call derivatives(state, k1, drag_parameter, gravity)

        temporary_state = state + 0.5_dp * dt * k1
        call derivatives(temporary_state, k2, drag_parameter, gravity)

        temporary_state = state + 0.5_dp * dt * k2
        call derivatives(temporary_state, k3, drag_parameter, gravity)

        temporary_state = state + dt * k3
        call derivatives(temporary_state, k4, drag_parameter, gravity)

        state = state + dt * &
            (k1 + 2.0_dp*k2 + 2.0_dp*k3 + k4) / 6.0_dp
    end subroutine rk4_step

end program projectile_motion
