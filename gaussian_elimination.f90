program gaussian_elimination
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 3
    real(real64) :: A(n,n), b(n), x(n)
    real(real64) :: factor, sum_value
    real(real64), parameter :: pivot_tolerance = 1.0e-14_real64
    integer :: i, j, k

    A = reshape([ &
        2.0_real64, -3.0_real64, -2.0_real64, &
        1.0_real64, -1.0_real64,  1.0_real64, &
       -1.0_real64,  2.0_real64,  2.0_real64  &
    ], shape(A))

    b = [8.0_real64, -11.0_real64, -3.0_real64]

    ! Forward elimination
    do k = 1, n - 1

        if (abs(A(k,k)) < pivot_tolerance) then
            write(*,*) 'Error: zero or very small pivot.'
            stop
        end if

        do i = k + 1, n
            factor = A(i,k) / A(k,k)

            do j = k, n
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

    write(*,'(a)') 'Solution:'

    do i = 1, n
        write(*,'(a,i0,a,es16.8)') 'x(', i, ') = ', x(i)
    end do

end program gaussian_elimination
