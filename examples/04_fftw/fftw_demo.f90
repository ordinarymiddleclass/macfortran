! =============================================================================
! 範例 4: FFTW — 快速傅立葉轉換
! 編譯: gfortran -o fftw_demo fftw_demo.f90 -lfftw3 -lm
! 執行: ./fftw_demo
! =============================================================================
program fftw_demo
    use, intrinsic :: iso_c_binding
    implicit none
    include 'fftw3.f03'

    integer, parameter :: N = 8
    complex(C_DOUBLE_COMPLEX) :: in(N), out(N)
    type(C_PTR) :: plan
    integer :: i

    ! 建立輸入信號: 簡單的正弦波
    do i = 1, N
        in(i) = cmplx(sin(2.0d0 * acos(-1.0d0) * dble(i-1) / dble(N)), 0.0d0, C_DOUBLE_COMPLEX)
    end do

    print *, "=== FFTW 快速傅立葉轉換範例 ==="
    print *, ""
    print *, "輸入信號 (時域):"
    do i = 1, N
        print "(A, I2, A, F10.6, A, F10.6, A)", "  x(", i, ") = (", &
            real(in(i)), ", ", aimag(in(i)), ")"
    end do

    ! 建立 FFT 計畫並執行
    plan = fftw_plan_dft_1d(N, in, out, FFTW_FORWARD, FFTW_ESTIMATE)
    call fftw_execute_dft(plan, in, out)
    call fftw_destroy_plan(plan)

    print *, ""
    print *, "FFT 結果 (頻域):"
    do i = 1, N
        print "(A, I2, A, F10.6, A, F10.6, A)", "  X(", i, ") = (", &
            real(out(i)), ", ", aimag(out(i)), ")"
    end do

end program fftw_demo
