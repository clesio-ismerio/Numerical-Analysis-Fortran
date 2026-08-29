program gaussian_partial_pivoting
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 3
    real(real64) :: A(n,n), b(n), x(n)
    real(real64) :: factor, sum_value
    real(real64) :: pivot_value, temporary
    real(real64), parameter :: pivot_tolerance = 1.0e-14_real64
    integer :: i, j, k, pivot_row

    A = reshape([ &
        0.0_real64,  1.0_real64,  2.0_real64, &
        2.0_real64, -2.0_real64,  3.0_real64, &
        3.0_real64,  1.0_real64, -1.0_real64  &
    ], shape(A))

    b = [8.0_real64, 1.0_real64, 1.0_real64]

    ! Forward elimination with partial pivoting
    do k = 1, n - 1

        pivot_row = k
        pivot_value = abs(A(k,k))

        do i = k + 1, n
            if (abs(A(i,k)) > pivot_value) then
                pivot_value = abs(A(i,k))
                pivot_row = i
            end if
        end do

        if (pivot_value < pivot_tolerance) then
            write(*,*) 'Error: singular or nearly singular matrix.'
            stop
        end if

        ! Exchange rows when necessary
        if (pivot_row /= k) then

            do j = 1, n
                temporary = A(k,j)
                A(k,j) = A(pivot_row,j)
                A(pivot_row,j) = temporary
            end do

            temporary = b(k)
            b(k) = b(pivot_row)
            b(pivot_row) = temporary
        end if

        ! Elimination
        do i = k + 1, n
            factor = A(i,k) / A(k,k)
            A(i,k) = 0.0_real64

            do j = k + 1, n
                A(i,j) = A(i,j) - factor * A(k,j)
            end do

            b(i) = b(i) - factor * b(k)
        end do
    end do

    if (abs(A(n,n)) < pivot_tolerance) then
        write(*,*) 'Error: singular or nearly singular matrix.'
        stop
    end if

    ! Backward substitution
    x(n) = b(n) / A(n,n)

    do i = n - 1, 1, -1
        sum_value = 0.0_real64

        do j = i + 1, n
            sum_value = sum_value + A(i,j) * x(j)
        end do

        if (abs(A(i,i)) < pivot_tolerance) then
            write(*,*) 'Error: singular or nearly singular matrix.'
            stop
        end if

        x(i) = (b(i) - sum_value) / A(i,i)
    end do

    write(*,'(a)') 'Solution obtained with partial pivoting:'

    do i = 1, n
        write(*,'(a,i0,a,es16.8)') 'x(', i, ') = ', x(i)
    end do

end program gaussian_partial_pivoting
