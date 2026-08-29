program lagrange_interpolation
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 5
    integer, parameter :: number_plot_points = 501

    real(real64) :: x(n), y(n)
    real(real64) :: x_value, y_value
    real(real64) :: x_plot, x_min, x_max, dx
    integer :: i, unit_data, unit_curve

    x = [-2.0_real64, -1.0_real64, 0.0_real64, &
          1.0_real64,  2.0_real64]

    y = [ 5.0_real64,  2.0_real64, 1.0_real64, &
          2.0_real64,  5.0_real64]

    x_value = 0.5_real64
    y_value = lagrange_value(x, y, n, x_value)

    print '(a,f10.5)', 'Evaluation point:  x = ', x_value
    print '(a,f10.5)', 'Interpolated value: y = ', y_value

    ! Save the original data.
    open(newunit=unit_data, &
         file='lagrange_points.dat', &
         status='replace', &
         action='write')

    do i = 1, n
        write(unit_data, '(2es24.14)') x(i), y(i)
    end do

    close(unit_data)

    ! Save the interpolating curve.
    x_min = minval(x)
    x_max = maxval(x)

    dx = (x_max - x_min) / &
         real(number_plot_points - 1, real64)

    open(newunit=unit_curve, &
         file='lagrange_curve.dat', &
         status='replace', &
         action='write')

    do i = 1, number_plot_points
        x_plot = x_min + real(i - 1, real64) * dx

        write(unit_curve, '(2es24.14)') &
            x_plot, lagrange_value(x, y, n, x_plot)
    end do

    close(unit_curve)

contains

    function lagrange_value(x_data, y_data, number_points, value) &
        result(interpolated_value)

        integer, intent(in) :: number_points
        real(real64), intent(in) :: x_data(number_points)
        real(real64), intent(in) :: y_data(number_points)
        real(real64), intent(in) :: value

        real(real64) :: interpolated_value
        real(real64) :: basis
        real(real64) :: difference
        real(real64) :: tolerance

        integer :: i, j

        interpolated_value = 0.0_real64

        do i = 1, number_points
            basis = 1.0_real64

            do j = 1, number_points
                if (j /= i) then

                    difference = abs(x_data(i) - x_data(j))

                    tolerance = epsilon(1.0_real64) * &
                        max(1.0_real64, &
                            abs(x_data(i)), &
                            abs(x_data(j)))

                    if (difference <= tolerance) then
                        error stop &
                            'Interpolation nodes must be distinct.'
                    end if

                    basis = basis * &
                        (value - x_data(j)) / &
                        (x_data(i) - x_data(j))

                end if
            end do

            interpolated_value = interpolated_value + &
                y_data(i) * basis
        end do

    end function lagrange_value

end program lagrange_interpolation
