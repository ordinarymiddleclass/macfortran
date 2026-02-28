! =============================================================================
! 範例 2: BLAS/LAPACK — 解線性方程組 Ax = b
! 使用 LAPACK 的 DGESV 求解
! 編譯: gfortran -o solve_linear solve_linear.f90 -lopenblas -llapack
! 執行: ./solve_linear
! =============================================================================
program solve_linear
    implicit none

    integer, parameter :: n = 3
    integer :: info, ipiv(n)
    double precision :: A(n, n), b(n)

    ! 定義矩陣 A (3x3)
    !     | 1  2  3 |
    ! A = | 4  5  6 |
    !     | 7  8  10|
    A(1,:) = [1.0d0, 2.0d0, 3.0d0]
    A(2,:) = [4.0d0, 5.0d0, 6.0d0]
    A(3,:) = [7.0d0, 8.0d0, 10.0d0]

    ! 定義右邊向量 b
    b = [1.0d0, 2.0d0, 3.0d0]

    print *, "=== 線性方程組求解 (LAPACK DGESV) ==="
    print *, ""
    print *, "矩陣 A:"
    print "(3F10.4)", A(1,:)
    print "(3F10.4)", A(2,:)
    print "(3F10.4)", A(3,:)
    print *, ""
    print *, "向量 b:"
    print "(3F10.4)", b
    print *, ""

    ! 呼叫 LAPACK 求解
    call dgesv(n, 1, A, n, ipiv, b, n, info)

    if (info == 0) then
        print *, "解 x:"
        print "(3F10.4)", b
    else
        print *, "求解失敗! info =", info
    end if

end program solve_linear
