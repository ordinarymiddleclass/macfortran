# Fortran 開發環境 (Docker + VS Code Dev Container)

> 針對 **Mac Mini M2 (Apple Silicon ARM64)** 優化的完整 Fortran 科學計算開發環境

---

## 📋 目錄

- [環境概覽](#環境概覽)
- [前置需求](#前置需求)
- [快速開始](#快速開始)
- [包含的函式庫](#包含的函式庫)
- [專案結構](#專案結構)
- [使用方式](#使用方式)
- [VS Code 功能](#vscode-功能)
- [範例程式](#範例程式)
- [常見問題](#常見問題)

---

## 環境概覽

| 項目 | 內容 |
|------|------|
| 基礎映像 | Ubuntu 24.04 LTS (ARM64) |
| Fortran 編譯器 | GFortran (GNU Fortran) |
| C/C++ 編譯器 | GCC / G++ |
| 建構工具 | Make, CMake, Ninja |
| 平行計算 | OpenMPI |
| 除錯器 | GDB, Valgrind |
| 程式碼格式化 | fprettify |
| 語言伺服器 | fortls |

---

## 前置需求

在 Mac Mini M2 上，請先安裝以下軟體：

### 1. Docker Desktop

```bash
# 從官網下載 Docker Desktop for Mac (Apple Silicon)
# https://www.docker.com/products/docker-desktop/

# 或使用 Homebrew 安裝
brew install --cask docker
```

安裝完成後，啟動 Docker Desktop 並確認正在運行：

```bash
docker --version
docker compose version
```

### 2. VS Code + Dev Containers 擴充套件

```bash
# 安裝 VS Code (如尚未安裝)
brew install --cask visual-studio-code

# 安裝 Dev Containers 擴充套件
code --install-extension ms-vscode-remote.remote-containers
```

---

## 快速開始

### 方法一：VS Code Dev Container (推薦)

1. **開啟專案資料夾**

   ```bash
   code /path/to/this/folder
   ```

2. **啟動 Dev Container**

   - VS Code 會自動偵測到 `.devcontainer/` 資料夾
   - 左下角會出現提示：「Reopen in Container」
   - 點擊它，或按 `Cmd+Shift+P` → 輸入 `Dev Containers: Reopen in Container`
   - **首次建構約需 5-10 分鐘**（下載映像 + 安裝套件）

3. **驗證環境**

   開啟 VS Code 終端機 (`` Ctrl+` ``)，執行：

   ```bash
   gfortran --version
   mpif90 --version
   cmake --version
   ```

### 方法二：純 Docker 命令列

```bash
# 進入專案根目錄
cd /path/to/this/folder

# 建構映像
docker compose -f .devcontainer/docker-compose.yml build

# 啟動容器
docker compose -f .devcontainer/docker-compose.yml up -d

# 進入容器
docker compose -f .devcontainer/docker-compose.yml exec fortran-dev bash

# 停止容器
docker compose -f .devcontainer/docker-compose.yml down
```

---

## 包含的函式庫

### 數值計算核心

| 函式庫 | 用途 | 連結旗標 |
|--------|------|----------|
| **OpenBLAS** | 基礎線性代數 (矩陣乘法等) | `-lopenblas` |
| **LAPACK** | 進階線性代數 (特徵值、SVD 等) | `-llapack` |
| **ScaLAPACK** | 分散式平行線性代數 | `-lscalapack-openmpi` |

### 信號處理

| 函式庫 | 用途 | 連結旗標 |
|--------|------|----------|
| **FFTW3** | 快速傅立葉轉換 | `-lfftw3` |
| **FFTW3-MPI** | 平行 FFT | `-lfftw3_mpi -lfftw3` |

### 科學資料 I/O

| 函式庫 | 用途 | 編譯指令 |
|--------|------|----------|
| **HDF5** | 高效二進位資料格式 | `h5fc` (包裝編譯器) |
| **NetCDF** | 網格狀科學資料 | `-lnetcdff -lnetcdf` |

### 平行計算

| 函式庫 | 用途 | 編譯指令 |
|--------|------|----------|
| **OpenMPI** | 訊息傳遞平行計算 | `mpif90` (包裝編譯器) |

### 進階數值

| 函式庫 | 用途 | 連結旗標 |
|--------|------|----------|
| **PETSc** | PDE 求解框架 | 依安裝路徑 |
| **GSL** | GNU 科學計算庫 | `-lgsl -lgslcblas` |
| **SuiteSparse** | 稀疏矩陣分解 | `-lumfpack -lamd` |

### 工具

| 工具 | 用途 |
|------|------|
| **Gnuplot** | 命令列繪圖 |
| **fprettify** | Fortran 程式碼格式化 |
| **fortls** | Fortran 語言伺服器 (LSP) |
| **GDB** | GNU 除錯器 |
| **Valgrind** | 記憶體錯誤偵測 |

---

## 專案結構

```
.
├── .devcontainer/
│   ├── Dockerfile           # Docker 映像定義
│   ├── docker-compose.yml   # Docker Compose 設定
│   └── devcontainer.json    # VS Code Dev Container 設定
├── .vscode/
│   ├── launch.json          # 除錯組態
│   └── tasks.json           # 建構任務
├── examples/
│   ├── Makefile              # 統一建構腳本
│   ├── 01_hello/             # Hello World
│   ├── 02_lapack/            # LAPACK 線性代數
│   ├── 03_mpi/               # MPI 平行計算
│   ├── 04_fftw/              # FFTW 傅立葉轉換
│   └── 05_hdf5/              # HDF5 資料讀寫
└── README.md                 # 本說明文件
```

---

## 使用方式

### 編譯單一檔案

```bash
# 基本編譯
gfortran -o myprogram myprogram.f90

# 帶除錯資訊
gfortran -g -Wall -fcheck=all -fbacktrace -o myprogram myprogram.f90

# 帶最佳化
gfortran -O3 -march=native -o myprogram myprogram.f90

# 連結 LAPACK
gfortran -o myprogram myprogram.f90 -lopenblas -llapack

# MPI 程式
mpif90 -o myprogram myprogram.f90

# HDF5 程式
h5fc -o myprogram myprogram.f90
```

### 執行範例程式

```bash
cd examples

# 編譯所有範例
make all

# 執行所有範例
make run

# 清除編譯產物
make clean
```

### 執行 MPI 程式

```bash
# 使用 4 個 process
mpirun -np 4 ./mpi_pi

# 允許超額配置 (process 數 > CPU 核數)
mpirun --oversubscribe -np 8 ./mpi_pi
```

### 除錯

```bash
# 使用 GDB
gfortran -g -fcheck=all -fbacktrace -o myprogram myprogram.f90
gdb ./myprogram

# GDB 常用指令
# (gdb) break main          # 設定中斷點
# (gdb) run                 # 開始執行
# (gdb) next                # 下一行
# (gdb) step                # 進入子程序
# (gdb) print variable      # 印出變數值
# (gdb) backtrace           # 顯示呼叫堆疊
# (gdb) quit                # 離開

# 使用 Valgrind 檢查記憶體
valgrind --leak-check=full ./myprogram
```

### 程式碼格式化

```bash
# 格式化單一檔案
fprettify myprogram.f90

# 格式化整個目錄
fprettify -r ./src/
```

---

## VS Code 功能

### 建構任務 (Ctrl+Shift+B)

已預設的建構任務：

| 任務名稱 | 說明 |
|----------|------|
| **Fortran: Build Current File** | 編譯目前開啟的 .f90 檔案 (預設) |
| **Fortran: Build with LAPACK** | 編譯並連結 LAPACK |
| **Fortran: Build with MPI** | 使用 mpif90 編譯 |
| **Fortran: Build with HDF5** | 使用 h5fc 編譯 |
| **Fortran: Build with FFTW** | 編譯並連結 FFTW3 |
| **Make: Build All Examples** | 編譯所有範例 |
| **Make: Run All Examples** | 執行所有範例 |

使用方式：
- `Cmd+Shift+B` → 選擇建構任務
- 或 `Cmd+Shift+P` → 「Tasks: Run Task」

### 除錯 (F5)

已預設的除錯組態：

1. **Fortran: 編譯並除錯目前檔案** — 自動編譯並啟動 GDB 除錯
2. **Fortran: 除錯已編譯程式** — 除錯指定的執行檔

使用方式：
1. 在程式碼左側點擊設定中斷點 (紅點)
2. 按 `F5` 啟動除錯
3. 使用除錯工具列控制執行流程

### 已安裝的擴充套件

- **Fortran 語言支援** — 語法高亮、自動完成
- **fortls** — Fortran 語言伺服器 (跳轉定義、懸停提示)
- **fprettify** — 儲存時自動格式化
- **C/C++ Tools** — GDB 除錯整合
- **CMake Tools** — CMake 專案支援
- **Makefile Tools** — Makefile 專案支援

---

## 範例程式

### 範例 1: Hello World
最基本的 Fortran 程式，驗證編譯器正常運作。

```bash
cd examples/01_hello
gfortran -o hello hello.f90
./hello
```

### 範例 2: LAPACK 線性方程求解
使用 LAPACK 的 `DGESV` 求解 3×3 線性方程組 Ax = b。

```bash
cd examples/02_lapack
gfortran -o solve_linear solve_linear.f90 -lopenblas -llapack
./solve_linear
```

### 範例 3: MPI 蒙特卡羅計算 Pi
使用 OpenMPI 平行化蒙特卡羅法，估算圓周率 π。

```bash
cd examples/03_mpi
mpif90 -o mpi_pi mpi_pi.f90
mpirun -np 4 ./mpi_pi
```

### 範例 4: FFTW 傅立葉轉換
使用 FFTW3 對正弦波進行快速傅立葉轉換。

```bash
cd examples/04_fftw
gfortran -o fftw_demo fftw_demo.f90 -lfftw3 -lm
./fftw_demo
```

### 範例 5: HDF5 資料讀寫
使用 HDF5 函式庫寫入與讀取二維陣列資料。

```bash
cd examples/05_hdf5
h5fc -o hdf5_demo hdf5_demo.f90
./hdf5_demo
```

---

## 常見問題

### Q: 首次建構很慢？
**A:** 正常現象。首次需下載 Ubuntu 24.04 映像並編譯安裝所有套件，約需 5-10 分鐘。後續啟動會使用快取，幾秒內即可完成。

### Q: Docker Desktop 需要多少資源？
**A:** 建議在 Docker Desktop → Settings → Resources 中分配：
- **CPU:** 至少 2 核（建議 4 核）
- **Memory:** 至少 4 GB（建議 8 GB）
- **Disk:** 至少 20 GB

### Q: MPI 程式在容器內跑不起來？
**A:** 確認 `docker-compose.yml` 中有設定足夠的 `shm_size`。預設為 2GB，大型程式可能需要增加：
```yaml
shm_size: "4gb"
```

### Q: 如何新增更多函式庫？
**A:** 編輯 `.devcontainer/Dockerfile`，在適當位置加入 `apt-get install` 或原始碼編譯指令，然後重新建構容器：
- `Cmd+Shift+P` → 「Dev Containers: Rebuild Container」

### Q: 如何使用 CMake 專案？
**A:** 範例 CMakeLists.txt：
```cmake
cmake_minimum_required(VERSION 3.20)
project(MyFortranProject Fortran)

# 啟用 Fortran
enable_language(Fortran)

# 尋找套件
find_package(LAPACK REQUIRED)
find_package(BLAS REQUIRED)

# 新增執行檔
add_executable(myprogram main.f90 module1.f90 module2.f90)
target_link_libraries(myprogram ${LAPACK_LIBRARIES} ${BLAS_LIBRARIES})
```

建構指令：
```bash
mkdir build && cd build
cmake .. -G Ninja
ninja
```

### Q: 如何持久化資料？
**A:** 工作區已透過 Docker volume 掛載，所有在 `/workspace` 下的檔案變更都會直接反映在主機上。

### Q: 容器內的效能如何？
**A:** 由於 Mac Mini M2 是 ARM64 架構，Docker 使用 `linux/arm64` 映像，**無需模擬層**，效能接近原生。

### Q: 如何更新環境？
**A:**
```bash
# 方法 1: VS Code 中
Cmd+Shift+P → Dev Containers: Rebuild Container

# 方法 2: 命令列
docker compose -f .devcontainer/docker-compose.yml build --no-cache
docker compose -f .devcontainer/docker-compose.yml up -d
```

---

## 授權

本開發環境設定檔為自由使用，不限用途。
