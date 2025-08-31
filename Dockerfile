FROM archlinux:base-devel

# Install dependencies
RUN pacman -Syu --noconfirm git \
    && pacman -Scc --noconfirm

# Setup a user
RUN useradd -m docker
RUN echo "docker ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER docker
WORKDIR /home/docker

# Install the current ROCm packages
RUN sudo pacman -Syu --noconfirm rocm-ml-sdk rocm-opencl-sdk rocwmma \
    && sudo pacman -Scc --noconfirm

# Set the right environment variables for ROCm inside the container
ENV PATH="/opt/rocm/bin:${PATH}"
ENV HIP_PATH="/opt/rocm"

# Make sure we compile using all threads and don't make debug builds
RUN echo 'MAKEFLAGS="-j$(nproc)"' >> ~/.makepkg.conf
RUN echo 'OPTIONS=(strip docs !libtool !staticlibs emptydirs zipman purge !debug lto)' >> ~/.makepkg.conf

# Clone the monorepo once, so we can reuse it through symlinks
RUN git clone --mirror https://github.com/ROCm/rocm-libraries.git

# Copy the buildfiles into the container
COPY --chown=1000 ./packages packages

# Build & Install python-tensile
WORKDIR packages/python-tensile
RUN ln -s /home/docker/rocm-libraries.git rocm-libraries
RUN yes | makepkg -si
WORKDIR /home/docker

# Build & Install rocblas
WORKDIR packages/rocblas
RUN ln -s /home/docker/rocm-libraries.git rocm-libraries
RUN yes | makepkg -si
WORKDIR /home/docker

# Build & Install hipblas
WORKDIR packages/hipblas
RUN ln -s /home/docker/rocm-libraries.git rocm-libraries
RUN yes | makepkg -si
WORKDIR /home/docker

# Build & Install rocsolver
WORKDIR packages/rocsolver
RUN ln -s /home/docker/rocm-libraries.git rocm-libraries
RUN yes | makepkg -si
WORKDIR /home/docker

# Build & Install rocwmma
WORKDIR packages/rocwmma
RUN ln -s /home/docker/rocm-libraries.git rocm-libraries
RUN yes | makepkg -si
WORKDIR /home/docker

# Build llama.cpp
RUN git clone https://github.com/ggml-org/llama.cpp.git
WORKDIR ./llama.cpp
RUN sed -i 's/HIP_VERSION >= 6050000/1/g' ggml/src/ggml-cuda/vendors/hip.h

RUN HIPCXX="$(hipconfig -l)/clang" HIP_PATH="$(hipconfig -R)" \
    cmake -S . -B build -DGGML_HIP=ON -DAMDGPU_TARGETS=gfx1100,gfx1151 \
    -DGGML_HIP_ROCWMMA_FATTN=ON \
    -DGGML_CUDA_ENABLE_UNIFIED_MEMORY=1 \
    -DGGML_CUDA_FA_ALL_QUANTS=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_BUILD_TYPE=Release
RUN cmake --build build --config Release -- -j $(nproc)
