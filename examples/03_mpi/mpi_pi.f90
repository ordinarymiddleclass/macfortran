! =============================================================================
! 範例 3: OpenMPI — 平行計算 Pi (蒙特卡羅法)
! 編譯: mpif90 -o mpi_pi mpi_pi.f90
! 執行: mpirun -np 4 ./mpi_pi
! =============================================================================
program mpi_pi
    use mpi
    implicit none

    integer :: ierr, rank, nprocs
    integer :: i, local_count, global_count
    integer, parameter :: num_samples = 10000000
    integer :: local_samples
    double precision :: x, y, pi_estimate
    real :: harvest(2)

    call MPI_Init(ierr)
    call MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
    call MPI_Comm_size(MPI_COMM_WORLD, nprocs, ierr)

    ! 每個 process 分配的樣本數
    local_samples = num_samples / nprocs
    local_count = 0

    ! 設定亂數種子 (每個 rank 不同)
    call random_seed()

    ! 蒙特卡羅採樣
    do i = 1, local_samples
        call random_number(harvest)
        x = dble(harvest(1))
        y = dble(harvest(2))
        if (x*x + y*y <= 1.0d0) then
            local_count = local_count + 1
        end if
    end do

    ! 歸約所有 process 的結果
    call MPI_Reduce(local_count, global_count, 1, MPI_INTEGER, &
                    MPI_SUM, 0, MPI_COMM_WORLD, ierr)

    if (rank == 0) then
        pi_estimate = 4.0d0 * dble(global_count) / dble(num_samples)
        print *, "=== MPI 蒙特卡羅法計算 Pi ==="
        print *, "使用 Process 數:", nprocs
        print *, "總樣本數:      ", num_samples
        print "(A, F12.8)", "  估算 Pi =       ", pi_estimate
        print "(A, F12.8)", "  實際 Pi =       ", acos(-1.0d0)
        print "(A, ES12.4)","  誤差 =          ", abs(pi_estimate - acos(-1.0d0))
    end if

    call MPI_Finalize(ierr)

end program mpi_pi
