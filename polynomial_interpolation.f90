program polynomial_interpolation
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 4
    integer, parameter :: number_plot_points = 401

    real(real64) :: x(n), y(n)
    real(real64) :: vandermonde(n,n)
    real(real64) :: coefficients(n)
    real(real64) :: x_value, y_value
    real(real64) :: x_plot, x_min, x_max, dx
    integer :: i, j, unit_data, unit_curve

    x = [0.0_real64, 1.0_real64, 2.0_real64, 3.0_real64]
    y = [1.0_real64, 2.0_real64, 5.0_real64, 10.0_real64]

    ! Construct the Vandermonde matrix.
    do i = 1, n
        vandermonde(i,1) = 1.0_real64

        do j = 2, n
            vandermonde(i,j) = vandermonde(i,j-1)*x(i)
        end do
    end do

    call solve_linear_system(vandermonde, y, coefficients, n)

    print '(a)', 'Polynomial coefficients:'
    do i = 1, n
        print '(a,i0,a,es16.8)', 'a(', i-1, ') = ', coefficients(i)
    end do

    x_value = 1.5_real64
    y_value = evaluate_polynomial(coefficients, x_value, n)

    print *
    print '(a,f10.5)', 'Evaluation point:  x = ', x_value
    print '(a,f10.5)', 'Interpolated value: y = ', y_value

    ! Save the original data.
    open(newunit=unit_data, file='polynomial_points.dat', status='replace', action='write')

    do i = 1, n
        write(unit_data,'(2es24.14)') x(i), y(i)
    end do

    close(unit_data)

    ! Save the interpolating curve.
    x_min = minval(x)
    x_max = maxval(x)
    dx = (x_max-x_min)/real(number_plot_points-1,real64)

    open(newunit=unit_curve, file='polynomial_curve.dat', status='replace', action='write')

    do i = 1, number_plot_points
        x_plot = x_min + real(i-1,real64)*dx
        write(unit_curve,'(2es24.14)') x_plot, &
            evaluate_polynomial(coefficients,x_plot,n)
    end do

    close(unit_curve)

contains

    subroutine solve_linear_system(matrix, rhs, solution, order)
        integer, intent(in) :: order
        real(real64), intent(in) :: matrix(order,order)
        real(real64), intent(in) :: rhs(order)
        real(real64), intent(out) :: solution(order)

        real(real64) :: augmented(order,order+1)
        real(real64) :: factor, temporary_row(order+1)
        real(real64) :: pivot_tolerance
        integer :: i, j, k, pivot_row

        augmented(:,1:order) = matrix
        augmented(:,order+1) = rhs

        pivot_tolerance = 100.0_real64*epsilon(1.0_real64)

        ! Gaussian elimination with partial pivoting.
        do k = 1, order-1
            pivot_row = k

            do i = k+1, order
                if (abs(augmented(i,k)) > &
                    abs(augmented(pivot_row,k))) then
                    pivot_row = i
                end if
            end do

            if (abs(augmented(pivot_row,k)) < pivot_tolerance) then
                error stop 'Singular or nearly singular matrix.'
            end if

            if (pivot_row /= k) then
                temporary_row = augmented(k,:)
                augmented(k,:) = augmented(pivot_row,:)
                augmented(pivot_row,:) = temporary_row
            end if

            do i = k+1, order
                factor = augmented(i,k)/augmented(k,k)
                augmented(i,k:order+1) = augmented(i,k:order+1) - factor*augmented(k,k:order+1)
            end do
        end do

        if (abs(augmented(order,order)) < pivot_tolerance) then
            error stop 'Singular or nearly singular matrix.'
        end if

        ! Back substitution.
        solution(order) = augmented(order,order+1)/ augmented(order,order)

        do i = order-1, 1, -1
            solution(i) = augmented(i,order+1)

            do j = i+1, order
                solution(i) = solution(i) - augmented(i,j)*solution(j)
            end do

            solution(i) = solution(i)/augmented(i,i)
        end do
    end subroutine solve_linear_system

    function evaluate_polynomial(coefficients, value, order) result(result_value)
        integer, intent(in) :: order
        real(real64), intent(in) :: coefficients(order)
        real(real64), intent(in) :: value
        real(real64) :: result_value
        integer :: i

        result_value = coefficients(order)

        do i = order-1, 1, -1
            result_value = result_value*value + coefficients(i)
        end do
    end function evaluate_polynomial

end program polynomial_interpolation
