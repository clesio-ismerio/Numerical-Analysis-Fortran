program newton_interpolation
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 6
    integer, parameter :: number_plot_points = 601

    real(real64) :: x(n), y(n), coefficients(n)
    real(real64) :: x_value, y_value
    real(real64) :: x_plot, x_min, x_max, dx
    integer :: i, unit_data, unit_curve

    x = [0.0_real64, 0.5_real64, 1.0_real64, &
         1.5_real64, 2.0_real64, 2.5_real64]

    y = sin(x)

    call divided_difference_coefficients( &
        x, y, n, coefficients)

    print '(a)', &
        'Newton divided-difference coefficients:'

    do i = 1, n
        print '(a,i0,a,es16.8)', &
            'b(', i-1, ') = ', coefficients(i)
    end do

    x_value = 1.25_real64

    y_value = evaluate_newton( &
        x, coefficients, n, x_value)

    print *
    print '(a,f10.5)', &
        'Evaluation point:  x = ', x_value

    print '(a,f10.5)', &
        'Interpolated value: y = ', y_value

    print '(a,f10.5)', &
        'Exact sin(x):       y = ', sin(x_value)

    print '(a,es16.8)', &
        'Absolute error:       ', &
        abs(y_value - sin(x_value))

    ! Save the interpolation nodes.
    open( &
        newunit=unit_data, &
        file='newton_points.dat', &
        status='replace', &
        action='write' &
    )

    do i = 1, n
        write(unit_data, '(2es24.14)') x(i), y(i)
    end do

    close(unit_data)

    ! Save the interpolating curve
    ! and the exact function.
    x_min = minval(x)
    x_max = maxval(x)

    dx = (x_max - x_min) / &
        real(number_plot_points - 1, real64)

    open( &
        newunit=unit_curve, &
        file='newton_curve.dat', &
        status='replace', &
        action='write' &
    )

    do i = 1, number_plot_points
        x_plot = x_min + &
            real(i - 1, real64) * dx

        write(unit_curve, '(3es24.14)') &
            x_plot, &
            evaluate_newton( &
                x, coefficients, n, x_plot), &
            sin(x_plot)
    end do

    close(unit_curve)

contains

    subroutine divided_difference_coefficients( &
        x_data, y_data, number_points, coefficients)

        integer, intent(in) :: number_points

        real(real64), intent(in) :: &
            x_data(number_points)

        real(real64), intent(in) :: &
            y_data(number_points)

        real(real64), intent(out) :: &
            coefficients(number_points)

        integer :: interpolation_order, i

        real(real64) :: denominator
        real(real64) :: tolerance

        coefficients = y_data

        do interpolation_order = 1, number_points - 1

            do i = number_points, &
                   interpolation_order + 1, -1

                denominator = x_data(i) - &
                    x_data(i - interpolation_order)

                tolerance = epsilon(1.0_real64) * &
                    max( &
                        1.0_real64, &
                        abs(x_data(i)), &
                        abs(x_data( &
                            i - interpolation_order)) &
                    )

                if (abs(denominator) <= tolerance) then
                    error stop &
                        'Interpolation nodes must be distinct.'
                end if

                coefficients(i) = &
                    (coefficients(i) - &
                     coefficients(i - 1)) / &
                    denominator

            end do
        end do

    end subroutine divided_difference_coefficients


    function evaluate_newton( &
        x_data, coefficients, number_points, value) &
        result(interpolated_value)

        integer, intent(in) :: number_points

        real(real64), intent(in) :: &
            x_data(number_points)

        real(real64), intent(in) :: &
            coefficients(number_points)

        real(real64), intent(in) :: value
        real(real64) :: interpolated_value

        integer :: i

        interpolated_value = &
            coefficients(number_points)

        do i = number_points - 1, 1, -1

            interpolated_value = &
                coefficients(i) + &
                (value - x_data(i)) * &
                interpolated_value

        end do

    end function evaluate_newton

end program newton_interpolation
