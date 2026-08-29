program dormand_prince_rk45
    use iso_fortran_env, only: real64
    implicit none

    integer :: accepted_steps, rejected_steps
    integer, parameter :: max_attempts = 1000000

    real(real64) :: x, y, x0, y0, xf
    real(real64) :: h, hmin, hmax
    real(real64) :: atol, rtol
    real(real64) :: y4, y5
    real(real64) :: error_estimate
    real(real64) :: error_scale
    real(real64) :: normalized_error
    real(real64) :: factor
    real(real64) :: safety
    real(real64) :: factor_min, factor_max
    real(real64) :: used_step
    real(real64) :: y_exact, absolute_error
    integer :: attempts

    x0 = 0.0_real64
    y0 = 0.5_real64
    xf = 2.0_real64

    h    = 0.1_real64
    hmin = 1.0e-12_real64
    hmax = 0.25_real64

    atol = 1.0e-10_real64
    rtol = 1.0e-8_real64

    safety    = 0.9_real64
    factor_min = 0.2_real64
    factor_max = 5.0_real64

    x = x0
    y = y0

    accepted_steps = 0
    rejected_steps = 0
    attempts       = 0

    open(unit=10, file='rk45.dat', status='replace', &
         action='write')

    write(10,'(A)') &
        '# x numerical exact absolute_error used_step error_estimate'

    y_exact       = exact_solution(x)
    absolute_error = abs(y - y_exact)

    write(10,'(6ES24.15)') x, y, y_exact, absolute_error, &
                           0.0_real64, 0.0_real64

    do while (x < xf)
        attempts = attempts + 1

        if (attempts > max_attempts) then
            error stop 'Maximum number of RK45 attempts exceeded.'
        end if

        if (x + h > xf) h = xf - x

        used_step = h

        call rk45_step(x, y, used_step, y5, y4)

        error_estimate = abs(y5 - y4)

        error_scale = atol + rtol*max(abs(y), abs(y5))

        if (error_scale <= tiny(1.0_real64)) then
            normalized_error = error_estimate
        else
            normalized_error = error_estimate/error_scale
        end if

        if (normalized_error <= 1.0_real64) then
            x = x + used_step
            y = y5

            accepted_steps = accepted_steps + 1

            y_exact        = exact_solution(x)
            absolute_error = abs(y - y_exact)

            write(10,'(6ES24.15)') x, y, y_exact, &
                absolute_error, used_step, error_estimate
        else
            rejected_steps = rejected_steps + 1
        end if

        if (normalized_error <= &
            100.0_real64*epsilon(1.0_real64)) then

            factor = factor_max
        else
            factor = safety*normalized_error**(-0.2_real64)
            factor = min(factor_max, max(factor_min, factor))
        end if

        h = used_step*factor
        h = min(hmax, max(hmin, h))

        if (h <= hmin .and. normalized_error > 1.0_real64) then
            error stop &
                'Step size reached hmin before tolerance was met.'
        end if
    end do

    close(10)

    print '(A)', 'Dormand-Prince RK45 integration completed.'
    print '(A,I0)', 'Accepted steps: ', accepted_steps
    print '(A,I0)', 'Rejected steps: ', rejected_steps
    print '(A,ES14.6)', 'Final numerical value: ', y
    print '(A,ES14.6)', 'Final exact value:     ', &
                        exact_solution(x)
    print '(A,ES14.6)', 'Final absolute error:  ', &
                        abs(y - exact_solution(x))

contains

    subroutine rk45_step(x, y, h, y5, y4)
        real(real64), intent(in)  :: x, y, h
        real(real64), intent(out) :: y5, y4

        real(real64) :: k1, k2, k3, k4
        real(real64) :: k5, k6, k7

        k1 = f(x,y)

        k2 = f( &
            x + h*(1.0_real64/5.0_real64), &
            y + h*((1.0_real64/5.0_real64)*k1) &
        )

        k3 = f( &
            x + h*(3.0_real64/10.0_real64), &
            y + h*( &
                (3.0_real64/40.0_real64)*k1 + &
                (9.0_real64/40.0_real64)*k2) &
        )

        k4 = f( &
            x + h*(4.0_real64/5.0_real64), &
            y + h*( &
                (44.0_real64/45.0_real64)*k1 - &
                (56.0_real64/15.0_real64)*k2 + &
                (32.0_real64/9.0_real64)*k3) &
        )

        k5 = f( &
            x + h*(8.0_real64/9.0_real64), &
            y + h*( &
                (19372.0_real64/6561.0_real64)*k1 - &
                (25360.0_real64/2187.0_real64)*k2 + &
                (64448.0_real64/6561.0_real64)*k3 - &
                (212.0_real64/729.0_real64)*k4) &
        )

        k6 = f( &
            x + h, &
            y + h*( &
                (9017.0_real64/3168.0_real64)*k1 - &
                (355.0_real64/33.0_real64)*k2 + &
                (46732.0_real64/5247.0_real64)*k3 + &
                (49.0_real64/176.0_real64)*k4 - &
                (5103.0_real64/18656.0_real64)*k5) &
        )

        k7 = f( &
            x + h, &
            y + h*( &
                (35.0_real64/384.0_real64)*k1 + &
                (500.0_real64/1113.0_real64)*k3 + &
                (125.0_real64/192.0_real64)*k4 - &
                (2187.0_real64/6784.0_real64)*k5 + &
                (11.0_real64/84.0_real64)*k6) &
        )

        y5 = y + h*( &
            (35.0_real64/384.0_real64)*k1 + &
            (500.0_real64/1113.0_real64)*k3 + &
            (125.0_real64/192.0_real64)*k4 - &
            (2187.0_real64/6784.0_real64)*k5 + &
            (11.0_real64/84.0_real64)*k6)

        y4 = y + h*( &
            (5179.0_real64/57600.0_real64)*k1 + &
            (7571.0_real64/16695.0_real64)*k3 + &
            (393.0_real64/640.0_real64)*k4 - &
            (92097.0_real64/339200.0_real64)*k5 + &
            (187.0_real64/2100.0_real64)*k6 + &
            (1.0_real64/40.0_real64)*k7)
    end subroutine rk45_step

    pure function f(x,y) result(dydx)
        real(real64), intent(in) :: x, y
        real(real64) :: dydx

        dydx = y - x*x + 1.0_real64
    end function f

    pure function exact_solution(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = (x + 1.0_real64)**2 - 0.5_real64*exp(x)
    end function exact_solution

end program dormand_prince_rk45
