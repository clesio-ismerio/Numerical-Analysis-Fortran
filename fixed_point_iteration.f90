program fixed_point_iteration
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: max_iter = 100
    integer :: iteration
    real(real64), parameter :: tolerance = 1.0e-10_real64
    real(real64) :: x, x_new
    real(real64) :: error, residual

    x = 1.5_real64

    open(unit=10, file='fixed_point_data.dat',status='replace', action='write')

    write(10,'(A)') '# iteration x_old x_new error residual'

    print '(A)', 'Fixed-Point Iteration'
    print '(A)', ' iter  x_old   x_new' // &
                 '     error     residual'

    do iteration = 1, max_iter

        x_new = iteration_g(x)
        error = abs(x_new - x)
        residual = abs(function_f(x_new))

        print '(I5,4ES20.10)', iteration, x, x_new, error, residual
        write(10,'(I6,4ES24.14)') iteration, x, x_new, error, residual

        if (error < tolerance .or. residual < tolerance) exit

        x = x_new

    end do

    close(10)

    print *
    print '(A,ES24.15)', 'Approximate root = ', x_new
    print '(A,ES24.15)', 'Residual         = ', abs(function_f(x_new))
    print '(A,I0)', 'Iterations       = ', iteration

contains

    pure real(real64) function function_f(x)
        real(real64), intent(in) :: x

        function_f = x**3 - x - 2.0_real64
    end function function_f

    pure real(real64) function iteration_g(x)
        real(real64), intent(in) :: x

        iteration_g = sign(abs(x+ 2.0_real64)**(1.0_real64 / 3.0_real64), &
        x + 2.0_real64)
    end function iteration_g

end program fixed_point_iteration
