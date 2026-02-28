# =============================================================================
# Fortran 範例程式 Makefile
# 使用方式: make all     — 編譯所有範例
#          make clean   — 清除編譯產物
#          make run     — 執行所有範例
# =============================================================================

FC       = gfortran
MPIFC    = mpif90
H5FC     = h5fc
FFLAGS   = -Wall -Wextra -fcheck=all -fbacktrace -O2 -std=f2018
LDFLAGS  =

# 各範例的執行檔
TARGETS  = 01_hello/hello \
           02_lapack/solve_linear \
           03_mpi/mpi_pi \
           04_fftw/fftw_demo \
           05_hdf5/hdf5_demo

.PHONY: all clean run

all: $(TARGETS)

# --- 範例 1: Hello World ---
01_hello/hello: 01_hello/hello.f90
	$(FC) $(FFLAGS) -o $@ $<

# --- 範例 2: LAPACK ---
02_lapack/solve_linear: 02_lapack/solve_linear.f90
	$(FC) $(FFLAGS) -o $@ $< -lopenblas -llapack

# --- 範例 3: MPI ---
03_mpi/mpi_pi: 03_mpi/mpi_pi.f90
	$(MPIFC) -O2 -o $@ $<

# --- 範例 4: FFTW ---
04_fftw/fftw_demo: 04_fftw/fftw_demo.f90
	$(FC) $(FFLAGS) -o $@ $< -lfftw3 -lm

# --- 範例 5: HDF5 ---
05_hdf5/hdf5_demo: 05_hdf5/hdf5_demo.f90
	$(H5FC) -O2 -o $@ $<

# --- 執行所有範例 ---
run: all
	@echo ""
	@echo "====== 範例 1: Hello World ======"
	./01_hello/hello
	@echo ""
	@echo "====== 範例 2: LAPACK 線性方程求解 ======"
	./02_lapack/solve_linear
	@echo ""
	@echo "====== 範例 3: MPI 蒙特卡羅計算 Pi ======"
	mpirun --oversubscribe -np 4 ./03_mpi/mpi_pi
	@echo ""
	@echo "====== 範例 4: FFTW 傅立葉轉換 ======"
	./04_fftw/fftw_demo
	@echo ""
	@echo "====== 範例 5: HDF5 資料讀寫 ======"
	cd 05_hdf5 && ../05_hdf5/hdf5_demo
	@echo ""
	@echo "====== 所有範例執行完成 ======"

# --- 清除 ---
clean:
	rm -f $(TARGETS)
	rm -f 05_hdf5/test_data.h5
	find . -name "*.o" -delete
	find . -name "*.mod" -delete
