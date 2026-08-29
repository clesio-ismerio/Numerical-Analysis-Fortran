program lu_decomposition
    use iso_fortran_env, only: real64
    implicit none

    integer, parameter :: n = 3
    real(real64) :: A(n,n), L(n,n), U(n,n)
    real(real64) :: b(n), y(n), x(n)
    real(real64) :: sum_value
    real(real64), parameter :: pivot_tolerance = 1.0e-14_real64
    integer :: i, j, k, s

    A = reshape([ &
        2.0_real64, 3.0_real64, 3.0_real64, &
       -1.0_real64, 3.0_real64, 3.0_real64, &
        1.0_real64, 9.0_real64, 5.0_real64  &
    ], shape(A))

    b = [2.0_real64, -1.0_real64, 4.0_real64]

    L = 0.0_real64
    U = 0.0_real64

    do i = 1, n
        L(i,i) = 1.0_real64
    end do

    ! Doolittle factorization
    do k = 1, n

        ! Compute row k of U
        do j = k, n
            sum_value = 0.0_real64

            do s = 1, k - 1
                sum_value = sum_value + L(k,s) * U(s,j)
            end do

            U(k,j) = A(k,j) - sum_value
        end do

        if (abs(U(k,k)) < pivot_tolerance) then
            write(*,*) 'Error: zero or very small pivot in LU.'
            write(*,*) 'Pivoting would be required.'
            stop
        end if

        ! Compute column k of L
        do i = k + 1, n
            sum_value = 0.0_real64

            do s = 1, k - 1
                sum_value = sum_value + L(i,s) * U(s,k)
            end do

            L(i,k) = (A(i,k) - sum_value) / U(k,k)
        end do
    end do

    ! Forward substitution: L y = b
    do i = 1, n
        sum_value = 0.0_real64

        do j = 1, i - 1
            sum_value = sum_value + L(i,j) * y(j)
        end do

        y(i) = b(i) - sum_value
    end do

    ! Backward substitution: U x = y
    do i = n, 1, -1
        sum_value = 0.0_real64

        do j = i + 1, n
            sum_value = sum_value + U(i,j) * x(j)
        end do

        x(i) = (y(i) - sum_value) / U(i,i)
    end do

    write(*,'(a)') 'Matrix L:'

    do i = 1, n
        write(*,'(*(f12.6,1x))') (L(i,j), j = 1, n)
    end do

    write(*,'(/,a)') 'Matrix U:'

    do i = 1, n
        write(*,'(*(f12.6,1x))') (U(i,j), j = 1, n)
    end do

    write(*,'(/,a)') 'Solution:'

    do i = 1, n
        write(*,'(a,i0,a,es16.8)') 'x(', i, ') = ', x(i)
    end do

end program lu_decomposition
