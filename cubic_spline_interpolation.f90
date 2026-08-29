program cubic_spline_interpolation
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: number_points = 7
    integer, parameter :: number_intervals = number_points-1
    integer, parameter :: number_plot_points = 801

    real(real64) :: x(number_points), y(number_points)
    real(real64) :: a(number_intervals)
    real(real64) :: b(number_intervals)
    real(real64) :: c(number_points)
    real(real64) :: d(number_intervals)

    real(real64) :: x_value, y_value
    real(real64) :: x_plot, x_min, x_max, dx
    integer :: i, unit_data, unit_curve

    x = [0.0_real64, 0.5_real64, 1.0_real64, &
         1.5_real64, 2.0_real64, 2.5_real64, &
         3.0_real64]

    y = exp(-0.3_real64*x)*sin(2.0_real64*x)

    call natural_cubic_spline(x,y,number_points,a,b,c,d)

    print '(a)', 'Natural cubic spline coefficients:'
    print *

    do i = 1, number_intervals
        print '(a,i0,a,f8.3,a,f8.3,a)', &
            'Interval ', i, ': [', x(i), ', ', x(i+1), ']'

        print '(a,4es16.8)', 'a, b, c, d = ', &
            a(i), b(i), c(i), d(i)
    end do

    x_value = 1.25_real64
    y_value = evaluate_spline(x,a,b,c,d,number_points,x_value)

    print *
    print '(a,f10.5)', 'Evaluation point:  x = ', x_value
    print '(a,f10.5)', 'Spline value:      y = ', y_value
    print '(a,f10.5)', 'Exact value:       y = ', &
        exp(-0.3_real64*x_value)*sin(2.0_real64*x_value)

    ! Save interpolation nodes.
    open(newunit=unit_data, file='spline_points.dat', &
         status='replace', action='write')

    do i = 1, number_points
        write(unit_data,'(2es24.14)') x(i), y(i)
    end do

    close(unit_data)

    ! Save spline and exact-function curves.
    x_min = x(1)
    x_max = x(number_points)
    dx = (x_max-x_min)/real(number_plot_points-1,real64)

    open(newunit=unit_curve, file='spline_curve.dat', &
         status='replace', action='write')

    do i = 1, number_plot_points
        x_plot = x_min + real(i-1,real64)*dx

        write(unit_curve,'(3es24.14)') x_plot, &
            evaluate_spline(x,a,b,c,d,number_points,x_plot), &
            exp(-0.3_real64*x_plot)*sin(2.0_real64*x_plot)
    end do

    close(unit_curve)

contains

    subroutine natural_cubic_spline(x_data,y_data,n,a,b,c,d)
        integer, intent(in) :: n
        real(real64), intent(in) :: x_data(n)
        real(real64), intent(in) :: y_data(n)

        real(real64), intent(out) :: a(n-1)
        real(real64), intent(out) :: b(n-1)
        real(real64), intent(out) :: c(n)
        real(real64), intent(out) :: d(n-1)

        real(real64) :: h(n-1)
        real(real64) :: alpha(n)
        real(real64) :: lower(n)
        real(real64) :: mu(n)
        real(real64) :: z(n)
        integer :: i

        do i = 1, n-1
            h(i) = x_data(i+1)-x_data(i)

            if (h(i) <= 0.0_real64) then
                error stop 'The interpolation nodes must be increasing.'
            end if
        end do

        alpha = 0.0_real64

        do i = 2, n-1
            alpha(i) = 3.0_real64*(y_data(i+1)-y_data(i))/h(i) - &
                       3.0_real64*(y_data(i)-y_data(i-1))/h(i-1)
        end do

        lower(1) = 1.0_real64
        mu(1) = 0.0_real64
        z(1) = 0.0_real64

        do i = 2, n-1
            lower(i) = 2.0_real64*(x_data(i+1)-x_data(i-1)) - &
                       h(i-1)*mu(i-1)

            mu(i) = h(i)/lower(i)
            z(i) = (alpha(i)-h(i-1)*z(i-1))/lower(i)
        end do

        lower(n) = 1.0_real64
        z(n) = 0.0_real64
        c(n) = 0.0_real64

        do i = n-1, 1, -1
            c(i) = z(i)-mu(i)*c(i+1)

            b(i) = (y_data(i+1)-y_data(i))/h(i) - &
                   h(i)*(c(i+1)+2.0_real64*c(i))/3.0_real64

            d(i) = (c(i+1)-c(i))/(3.0_real64*h(i))
            a(i) = y_data(i)
        end do
    end subroutine natural_cubic_spline

    function evaluate_spline(x_data,a,b,c,d,n,value) &
        result(interpolated_value)

        integer, intent(in) :: n
        real(real64), intent(in) :: x_data(n)
        real(real64), intent(in) :: a(n-1)
        real(real64), intent(in) :: b(n-1)
        real(real64), intent(in) :: c(n)
        real(real64), intent(in) :: d(n-1)
        real(real64), intent(in) :: value

        real(real64) :: interpolated_value
        real(real64) :: delta
        integer :: interval, left, right, middle

        ! Use the first or last interval for extrapolation.
        if (value <= x_data(1)) then
            interval = 1
        else if (value >= x_data(n)) then
            interval = n-1
        else
            ! Binary search for the interval.
            left = 1
            right = n

            do while (right-left > 1)
                middle = (left+right)/2

                if (value >= x_data(middle)) then
                    left = middle
                else
                    right = middle
                end if
            end do

            interval = left
        end if

        delta = value-x_data(interval)

        interpolated_value = a(interval) + &
            delta*(b(interval) + &
            delta*(c(interval) + delta*d(interval)))
    end function evaluate_spline

end program cubic_spline_interpolation
