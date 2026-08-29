program simple_trapezoidal_rule
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    real(real64) :: a
    real(real64) :: b
    real(real64) :: integral
    real(real64) :: exact_value
    real(real64) :: absolute_error

    a = 0.0_real64
    b = 1.0_real64

    integral = trapezoidal_rule(f, a, b)

    ! Reference value for the selected integral.
    exact_value = 0.7468241328124271_real64
    absolute_error = abs(exact_value - integral)

    write(*,'(A,F20.12)') 'Trapezoidal approximation = ', integral
    write(*,'(A,F20.12)') 'Reference value           = ', exact_value
    write(*,'(A,ES20.10)') 'Absolute error            = ', absolute_error

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function trapezoidal_rule(func, x_left, x_right) result(value)
        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: x_left
        real(real64), intent(in) :: x_right
        real(real64) :: value

        value = 0.5_real64 * (x_right - x_left) * &
                (func(x_left) + func(x_right))
    end function trapezoidal_rule

end program simple_trapezoidal_rule
