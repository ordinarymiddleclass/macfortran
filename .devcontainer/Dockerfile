# =============================================================================
# Fortran 開發環境 Dockerfile (ARM64 / Apple Silicon 優化)
# 基於 Ubuntu 24.04 LTS，包含 GFortran、OpenMPI、常用數值計算函式庫
# =============================================================================
FROM ubuntu:24.04

# 避免互動式對話
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Taipei

# ---- 1. 基礎工具 & 編譯器 ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    # 編譯器 & 建構工具
    gfortran \
    gcc \
    g++ \
    make \
    cmake \
    ninja-build \
    autoconf \
    automake \
    libtool \
    pkg-config \
    # 版本控制 & 工具
    git \
    curl \
    wget \
    ca-certificates \
    gnupg \
    # 編輯器 / 除錯
    vim \
    gdb \
    valgrind \
    strace \
    # Python (用於輔助腳本 / 繪圖)
    python3 \
    python3-pip \
    python3-venv \
    python3-numpy \
    python3-matplotlib \
    # 其他
    locales \
    sudo \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# ---- 2. 設定語系 ----
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# ---- 3. MPI 平行計算 ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libopenmpi-dev \
    openmpi-bin \
    openmpi-common \
    && rm -rf /var/lib/apt/lists/*

# ---- 4. 數值計算核心函式庫 (BLAS / LAPACK / ScaLAPACK) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libopenblas-dev \
    liblapack-dev \
    libscalapack-mpi-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- 5. FFTW (快速傅立葉轉換) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libfftw3-dev \
    libfftw3-mpi-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- 6. HDF5 & NetCDF (科學資料 I/O) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libhdf5-dev \
    libhdf5-mpi-dev \
    libnetcdf-dev \
    libnetcdff-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- 7. PETSc (偏微分方程求解框架) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    petsc-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- 8. GSL (GNU 科學計算庫) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgsl-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- 9. SuiteSparse (稀疏矩陣) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/*

# ---- 10. Gnuplot (繪圖) ----
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnuplot \
    && rm -rf /var/lib/apt/lists/*

# ---- 11. fprettify (Fortran 程式碼格式化工具) ----
RUN pip3 install --break-system-packages fprettify fortls

# ---- 12. 建立非 root 使用者 (與 VS Code devcontainer 相容) ----
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN if getent group $USER_GID > /dev/null 2>&1; then \
        groupmod -n $USERNAME $(getent group $USER_GID | cut -d: -f1); \
    else \
        groupadd --gid $USER_GID $USERNAME; \
    fi \
    && if id -u $USER_UID > /dev/null 2>&1; then \
        usermod -l $USERNAME -d /home/$USERNAME -m $(getent passwd $USER_UID | cut -d: -f1); \
    else \
        useradd --uid $USER_UID --gid $USER_GID -m $USERNAME -s /bin/bash; \
    fi \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ---- 13. 環境變數 ----
ENV PATH="/usr/lib/x86_64-linux-gnu/openmpi/bin:/usr/lib/aarch64-linux-gnu/openmpi/bin:${PATH}"
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu:/usr/lib/aarch64-linux-gnu:${LD_LIBRARY_PATH}"

# 允許 OpenMPI 以 root 執行 (容器內常用)
ENV OMPI_ALLOW_RUN_AS_ROOT=1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
# OpenMPI 在容器內的相容性設定
ENV OMPI_MCA_btl_vader_single_copy_mechanism=none

WORKDIR /workspace

USER $USERNAME
