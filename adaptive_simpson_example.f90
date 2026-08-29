program adaptive_simpson_example
    use, intrinsic :: iso_fortran_env, only: real64
    implicit none

    real(real64) :: a
    real(real64) :: b
    real(real64) :: tolerance
    real(real64) :: integral
    real(real64) :: exact_value

    integer :: maximum_depth

    a = 0.0_real64
    b = 1.0_real64

    tolerance = 1.0e-10_real64
    maximum_depth = 30

    integral = adaptive_simpson( f, a, b, tolerance, maximum_depth)

    exact_value = 0.7468241328124271_real64

    write(*,'(A,ES24.14)') 'Adaptive Simpson value = ', integral

    write(*,'(A,ES24.14)') 'Reference value        = ', exact_value

    write(*,'(A,ES24.14)') 'Absolute error         = ', abs(exact_value-integral)

contains

    function f(x) result(y)
        real(real64), intent(in) :: x
        real(real64) :: y

        y = exp(-x*x)
    end function f

    function adaptive_simpson(func, a, b, tolerance, maximum_depth) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        real(real64), intent(in) :: tolerance

        integer, intent(in) :: maximum_depth

        real(real64) :: c
        real(real64) :: fa
        real(real64) :: fb
        real(real64) :: fc
        real(real64) :: value
        real(real64) :: whole

        c = 0.5_real64*(a+b)

        fa = func(a)
        fb = func(b)
        fc = func(c)

        whole = simpson_estimate(a,b,fa,fc,fb)

        value = adaptive_step( func,a,b,fa,fc,fb,whole, tolerance,maximum_depth)
    end function adaptive_simpson

    recursive function adaptive_step( func,a,b,fa,fc,fb,whole,tolerance,depth) result(value)

        interface
            function func(x) result(y)
                import :: real64
                real(real64), intent(in) :: x
                real(real64) :: y
            end function func
        end interface

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        real(real64), intent(in) :: fa
        real(real64), intent(in) :: fc
        real(real64), intent(in) :: fb
        real(real64), intent(in) :: whole
        real(real64), intent(in) :: tolerance

        integer, intent(in) :: depth

        real(real64) :: c
        real(real64) :: d
        real(real64) :: difference
        real(real64) :: e
        real(real64) :: fd
        real(real64) :: fe
        real(real64) :: left
        real(real64) :: right
        real(real64) :: value

        c = 0.5_real64*(a+b)
        d = 0.5_real64*(a+c)
        e = 0.5_real64*(c+b)

        fd = func(d)
        fe = func(e)

        left = simpson_estimate(a,c,fa,fd,fc)
        right = simpson_estimate(c,b,fc,fe,fb)

        difference = left+right-whole

        if (depth <= 0 .or. abs(difference) <= 15.0_real64*tolerance) then

            value = left+right+difference/15.0_real64
            return
        end if

        value = adaptive_step( func,a,c,fa,fd,fc,left, tolerance/2.0_real64,depth-1) + &
                adaptive_step( func,c,b,fc,fe,fb,right, tolerance/2.0_real64,depth-1)
    end function adaptive_step

    pure function simpson_estimate( a,b,fa,fm,fb) result(value)

        real(real64), intent(in) :: a
        real(real64), intent(in) :: b
        real(real64), intent(in) :: fa
        real(real64), intent(in) :: fm
        real(real64), intent(in) :: fb

        real(real64) :: value

        value = (b-a) * (fa+4.0_real64*fm+fb) / 6.0_real64
    end function simpson_estimate

end program adaptive_simpson_example 
