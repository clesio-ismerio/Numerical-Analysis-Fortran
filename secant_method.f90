program secant_method
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: max_iter = 100
    integer :: iteration
    real(real64), parameter :: tolerance = 1.0e-12_real64
    real(real64), parameter :: small_value = 1.0e-14_real64
    real(real64) :: x0, x1, x2
    real(real64) :: f0, f1, f2
    real(real64) :: denominator
    real(real64) :: error

    x0 = 1.0_real64
    x1 = 2.0_real64

    open(unit=10, file='secant_data.dat', &
         status='replace', action='write')

    write(10,'(A)') '# iteration x0 x1 x2 f(x2) error'

    print '(A)', 'Secant Method'
    print '(A)', ' iter           x0                  x1' // &
                 '                  x2                f(x2)' // &
                 '               error'

    do iteration = 1, max_iter

        f0 = function_f(x0)
        f1 = function_f(x1)
        denominator = f1 - f0

        if (abs(denominator) < small_value) then
            print *, 'Error: denominator is too small.'
            stop
        end if

        x2 = x1 - f1 * (x1 - x0) / denominator
        f2 = function_f(x2)
        error = abs(x2 - x1)

        print '(I5,5ES20.10)', iteration, x0, x1, x2, f2, error
        write(10,'(I6,5ES24.14)') iteration, x0, x1, &
                                  x2, f2, error

        if (abs(f2) < tolerance .or. error < tolerance) exit

        x0 = x1
        x1 = x2

    end do

    close(10)

    print *
    print '(A,ES24.15)', 'Approximate root = ', x2
    print '(A,ES24.15)', 'Residual         = ', abs(function_f(x2))
    print '(A,I0)',      'Iterations       = ', iteration

contains

    pure real(real64) function function_f(x)
        real(real64), intent(in) :: x

        function_f = x**3 - x - 2.0_real64
    end function function_f

end program secant_method
