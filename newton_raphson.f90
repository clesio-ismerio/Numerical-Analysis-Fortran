program newton_raphson_method
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: max_iter = 100
    integer :: iteration
    real(real64), parameter :: tolerance = 1.0e-12_real64
    real(real64), parameter :: small_derivative = 1.0e-14_real64
    real(real64) :: x, x_new
    real(real64) :: fx, dfx
    real(real64) :: error, residual

    x = 1.5_real64

    open(unit=10, file='newton_data.dat', &
         status='replace', action='write')

    write(10,'(A)') '# iteration x_old f(x_old) df(x_old)' // &
                    ' x_new error residual'

    print '(A)', 'Newton--Raphson Method'
    print '(A)', ' iter          x_old              f(x_old)' // &
                 '            df(x_old)              x_new' // &
                 '               error            residual'

    do iteration = 1, max_iter

        fx = function_f(x)
        dfx = derivative_f(x)

        if (abs(dfx) < small_derivative) then
            print *, 'Error: derivative is too close to zero.'
            stop
        end if

        x_new = x - fx / dfx
        error = abs(x_new - x)
        residual = abs(function_f(x_new))

        print '(I5,6ES20.10)', iteration, x, fx, dfx, &
                              x_new, error, residual

        write(10,'(I6,6ES24.14)') iteration, x, fx, dfx, &
                                  x_new, error, residual

        if (error < tolerance .or. residual < tolerance) exit

        x = x_new

    end do

    close(10)

    print *
    print '(A,ES24.15)', 'Approximate root = ', x_new
    print '(A,ES24.15)', 'Residual         = ', &
                          abs(function_f(x_new))
    print '(A,I0)',      'Iterations       = ', iteration

contains

    pure real(real64) function function_f(x)
        real(real64), intent(in) :: x

        function_f = x**3 - x - 2.0_real64
    end function function_f

    pure real(real64) function derivative_f(x)
        real(real64), intent(in) :: x

        derivative_f = 3.0_real64 * x**2 - 1.0_real64
    end function derivative_f

end program newton_raphson_method
