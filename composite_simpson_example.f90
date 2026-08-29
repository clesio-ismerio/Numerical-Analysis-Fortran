program composite_simpson_example
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer :: n

    real(real64) :: a
    real(real64) :: b
    real(real64) :: integral
    real(real64) :: exact_value
    real(real64) :: absolute_error

    a = 0.0_real64
    b = 1.0_real64
    n = 10

    integral = composite_simpson(f, a, b, n)

    exact_value = 0.7468241328124271_real64
    absolute_error = abs(exact_value - integral)

    write(*,'(A,I0)')      'Number of subintervals = ', n
    write(*,'(A,F20.12)')  'Composite Simpson      = ', integral
    write(*,'(A,F20.12)')  'Reference value        = ', exact_value
    write(*,'(A,ES20.10)') 'Absolute error         = ', absolute_error

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

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

        integer :: i

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

        do i = 1, number_of_intervals-1
            x = x_left + real(i,real64)*h

            if (mod(i,2) == 0) then
                sum_even = sum_even + func(x)
            else
                sum_odd = sum_odd + func(x)
            end if
        end do

        value = (h/3.0_real64) * &
                (func(x_left) + 4.0_real64*sum_odd + &
                 2.0_real64*sum_even + func(x_right))
    end function composite_simpson

end program composite_simpson_example
