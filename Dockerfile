FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
# 为了避免失败，要加大内存至10GB以上。
RUN apt-get update && apt-get install -y \
    g++ \
    tar \
    clang \
    wget \
    python3 \
    python3-dev \
    python3-distutils \
    python3-pip \
    cmake \
    ninja-build \
    git \
    libzmq5 \
    libzmq3-dev \
    libprotobuf-dev \
    protobuf-compiler \
    pkg-config \
    ccache \
    gir1.2-goocanvas-2.0 \
    python3-gi \
    python3-gi-cairo \
    python3-pygraphviz \
    gir1.2-gtk-3.0 \
    ipython3 \
    qtbase5-dev \
    qtchooser \
    qt5-qmake \
    qtbase5-dev-tools \
    openmpi-bin \
    openmpi-common \
    openmpi-doc \
    libopenmpi-dev \
    mercurial \
    unzip \
    gdb \
    valgrind \
    clang-format \
    doxygen \
    graphviz \
    imagemagick \
    texlive \
    texlive-extra-utils \
    texlive-latex-extra \
    texlive-font-utils \
    dvipng \
    latexmk \
    python3-sphinx \
    dia \
    gsl-bin \
    libgsl-dev \
    libgslcblas0 \
    tcpdump \
    sqlite \
    sqlite3 \
    libsqlite3-dev \
    libxml2 \
    libxml2-dev \
    libboost-all-dev \
    rsync \
    xinetd \
    sudo

# 更新 pip 到最新版本
RUN python3 -m pip install --upgrade pip

# 安装 cppyy. 这个过程会编译依赖包cppyy_backend，耐心等待
RUN python3 -m pip install cppyy -i https://pypi.tuna.tsinghua.edu.cn/simple --verbose

#fix for "strip_trailing_zero" error
RUN python3 -m pip install --upgrade packaging
RUN apt-get install -y openssh-server && mkdir /var/run/sshd
ARG ROOT_PASSWORD=password
RUN echo ${ROOT_PASSWORD}
RUN echo root:${ROOT_PASSWORD} | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# other tools you may want to use.
RUN apt-get update && apt-get install -y vim
RUN python3 -m pip install tensorflow
RUN python3 -c "import sympy; print(sympy.__file__)" | xargs -I {} sh -c 'rm -rf $(dirname "{}")'
RUN rm -rf /usr/lib/python3/dist-packages/sympy-1.9.egg-info
RUN python3 -m pip install torch torchvision
RUN python3 -m pip install gymnasium
RUN python3 -m pip install stable-baselines3
RUN python3 -m pip uninstall -y numpy scipy
RUN python3 -m pip install numpy==1.24.4 scipy

# Accept build argument for the aoi password
ARG AOI_PASSWORD=password
# Create user 'aoi' and set up password
RUN echo "aoi:${AOI_PASSWORD}" 
RUN useradd -m aoi && echo "aoi:${AOI_PASSWORD}" | chpasswd
# Add 'aoi' to sudoers (optional, if you need sudo access for 'aoi')
RUN usermod -aG sudo aoi
# Set default user as 'aoi' (this makes 'aoi' the default user for the container)
USER aoi
# Set working directory
WORKDIR /workspace
