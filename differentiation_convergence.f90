program differentiation_convergence
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_of_levels = 14
    integer :: level
    real(real64) :: x, h
    real(real64) :: exact
    real(real64) :: error_forward
    real(real64) :: error_central
    real(real64) :: error_fourth
    real(real64) :: previous_forward
    real(real64) :: previous_central
    real(real64) :: previous_fourth
    real(real64) :: order_forward
    real(real64) :: order_central
    real(real64) :: order_fourth

    x = 1.0_real64
    h = 0.2_real64
    exact = cos(x)

    previous_forward = 0.0_real64
    previous_central = 0.0_real64
    previous_fourth = 0.0_real64

    open(unit=10, file='differentiation_convergence.dat', &
         status='replace', action='write')

    write(10,'(A)') &
        '# h error_forward error_central error_fourth ' // &
        'order_forward order_central order_fourth'

    do level = 1, number_of_levels

        error_forward = abs( &
            (f(x+h)-f(x))/h - exact)

        error_central = abs( &
            (f(x+h)-f(x-h))/(2.0_real64*h) - exact)

        error_fourth = abs( &
            (f(x-2.0_real64*h) - &
             8.0_real64*f(x-h) + &
             8.0_real64*f(x+h) - &
             f(x+2.0_real64*h)) / &
            (12.0_real64*h) - exact)

        if (level == 1) then
            order_forward = 0.0_real64
            order_central = 0.0_real64
            order_fourth = 0.0_real64
        else
            order_forward = log(previous_forward / &
                                error_forward)/log(2.0_real64)

            order_central = log(previous_central / &
                                error_central)/log(2.0_real64)

            order_fourth = log(previous_fourth / &
                               error_fourth)/log(2.0_real64)
        end if

        write(10,'(7(ES24.15,1X))') h, &
            error_forward, error_central, error_fourth, &
            order_forward, order_central, order_fourth

        previous_forward = error_forward
        previous_central = error_central
        previous_fourth = error_fourth

        h = h/2.0_real64
    end do

    close(10)

    print *, 'Convergence study completed.'
    print *, 'Output file: differentiation_convergence.dat'

contains

    pure function f(x) result(value)
        real(real64), intent(in) :: x
        real(real64) :: value

        value = sin(x)
    end function f

end program differentiation_convergence
