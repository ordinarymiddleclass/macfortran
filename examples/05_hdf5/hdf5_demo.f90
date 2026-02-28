! =============================================================================
! 範例 5: HDF5 — 科學資料讀寫
! 編譯: h5fc -o hdf5_demo hdf5_demo.f90
! 執行: ./hdf5_demo
! =============================================================================
program hdf5_demo
    use hdf5
    implicit none

    character(len=*), parameter :: filename = "test_data.h5"
    character(len=*), parameter :: dsetname = "temperature"

    integer(HID_T) :: file_id, dset_id, dspace_id
    integer(HSIZE_T) :: dims(2)
    integer :: hdferr, i, j
    integer, parameter :: NX = 4, NY = 6
    double precision :: data_out(NX, NY), data_in(NX, NY)

    ! 產生測試資料
    do j = 1, NY
        do i = 1, NX
            data_out(i, j) = dble(i-1) * 10.0d0 + dble(j-1) * 0.1d0
        end do
    end do

    dims = [NX, NY]

    print *, "=== HDF5 資料讀寫範例 ==="
    print *, ""

    ! 初始化 HDF5
    call h5open_f(hdferr)

    ! --- 寫入 ---
    print *, "寫入資料到 ", filename
    call h5fcreate_f(filename, H5F_ACC_TRUNC_F, file_id, hdferr)
    call h5screate_simple_f(2, dims, dspace_id, hdferr)
    call h5dcreate_f(file_id, dsetname, H5T_NATIVE_DOUBLE, dspace_id, dset_id, hdferr)
    call h5dwrite_f(dset_id, H5T_NATIVE_DOUBLE, data_out, dims, hdferr)
    call h5dclose_f(dset_id, hdferr)
    call h5sclose_f(dspace_id, hdferr)
    call h5fclose_f(file_id, hdferr)
    print *, "寫入完成!"
    print *, ""

    ! --- 讀取 ---
    print *, "從 ", filename, " 讀取資料"
    call h5fopen_f(filename, H5F_ACC_RDONLY_F, file_id, hdferr)
    call h5dopen_f(file_id, dsetname, dset_id, hdferr)
    call h5dread_f(dset_id, H5T_NATIVE_DOUBLE, data_in, dims, hdferr)
    call h5dclose_f(dset_id, hdferr)
    call h5fclose_f(file_id, hdferr)

    print *, "讀取的資料:"
    do i = 1, NX
        print "(6F8.1)", data_in(i, :)
    end do

    ! 驗證
    if (all(abs(data_in - data_out) < 1.0d-10)) then
        print *, ""
        print *, "✅ 資料驗證通過！讀寫一致。"
    end if

    call h5close_f(hdferr)

end program hdf5_demo
