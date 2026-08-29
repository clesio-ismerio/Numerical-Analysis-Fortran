program composite_quadrature_comparison
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_of_tests = 8

    integer :: i
    integer :: n
    integer :: unit_output

    real(real64), parameter :: exact_value = &
        0.7468241328124271_real64

    real(real64) :: a
    real(real64) :: b
    real(real64) :: trapezoidal_value
    real(real64) :: simpson_value
    real(real64) :: trapezoidal_error
    real(real64) :: simpson_error

    a = 0.0_real64
    b = 1.0_real64

    open(newunit=unit_output, file='quadrature_errors.dat', &
         status='replace', action='write')

    write(unit_output,'(A)') &
        '# n  trapezoidal_error  simpson_error'

    write(*,'(A)') &
        '       n       Trapezoidal error       Simpson error'

    do i = 1, number_of_tests
        n = 2**i

        trapezoidal_value = &
            composite_trapezoidal(f, a, b, n)

        simpson_value = &
            composite_simpson(f, a, b, n)

        trapezoidal_error = &
            abs(exact_value-trapezoidal_value)

        simpson_error = &
            abs(exact_value-simpson_value)

        write(*,'(I8,2ES24.12)') &
            n, trapezoidal_error, simpson_error

        write(unit_output,'(I8,2ES24.12)') &
            n, trapezoidal_error, simpson_error
    end do

    close(unit_output)

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function composite_trapezoidal(func, x_left, x_right, &
                                   number_of_intervals) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right
        integer, intent(in) :: number_of_intervals

        integer :: j

        real(real64) :: h
        real(real64) :: sum
        real(real64) :: value
        real(real64) :: x

        if (number_of_intervals <= 0) then
            error stop 'The number of intervals must be positive.'
        end if

        h = (x_right-x_left) / &
            real(number_of_intervals,real64)

        sum = 0.5_real64 * &
              (func(x_left)+func(x_right))

        do j = 1, number_of_intervals-1
            x = x_left + real(j,real64)*h
            sum = sum + func(x)
        end do

        value = h*sum
    end function composite_trapezoidal

    function composite_simpson(func, x_left, x_right, &
                               number_of_intervals) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right
        integer, intent(in) :: number_of_intervals

        integer :: j

        real(real64) :: h
        real(real64) :: sum_even
        real(real64) :: sum_odd
        real(real64) :: value
        real(real64) :: x

        if (number_of_intervals <= 0) then
            error stop 'The number of intervals must be positive.'
        end if

        if (mod(number_of_intervals,2) /= 0) then
            error stop 'Composite Simpson requires an even n.'
        end if

        h = (x_right-x_left) / &
            real(number_of_intervals,real64)

        sum_odd = 0.0_real64
        sum_even = 0.0_real64

        do j = 1, number_of_intervals-1
            x = x_left + real(j,real64)*h

            if (mod(j,2) == 0) then
                sum_even = sum_even + func(x)
            else
                sum_odd = sum_odd + func(x)
            end if
        end do

        value = (h/3.0_real64) * &
                (func(x_left) + 4.0_real64*sum_odd + &
                 2.0_real64*sum_even + func(x_right))
    end function composite_simpson

end program composite_quadrature_comparison
