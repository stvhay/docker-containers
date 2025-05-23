FROM nvidia/cuda:12.9.0-base-ubuntu24.04

# Set CUDA environment variables
ENV PATH=/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
ENV CUDA_HOME=/usr/local/cuda

# remove annoying ubuntu branding
RUN     userdel ubuntu || true \
    &&  useradd -m -s /bin/bash -u 1000 --groups sudo user

# Base dev tools, add user, group sudo
RUN     apt-get update \
    &&  apt-get upgrade -y

RUN     apt install -y \
            git build-essential sudo \
            software-properties-common \
            bash curl wget \
    &&  sed -i -e \
            "s/Defaults    requiretty.*/ #Defaults    requiretty/g" \
            /etc/sudoers \
    &&  echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN     add-apt-repository ppa:nest-simulator/nest \
    &&  apt-get update

# Installing packages
RUN     apt-get install -y \
            less \
            nano vim neovim \
            rustc cargo golang r-base gfortran \
            cmake ninja-build \
            libboost-all-dev \
            python3 python3-pip python3-venv \
            ffmpeg sox \
            nest swig \
            docker.io
RUN     usermod -aG docker user

USER user
WORKDIR /home/user

# Julia
RUN     curl -fsSL https://install.julialang.org | sh -s -- -y
ENV PATH="/home/user/.juliaup/bin:${PATH}"

# initialize user venv and jupyter
RUN     python3 -m venv .venv \
    &&  .venv/bin/python -m pip install -U \
            wheel setuptools pip \
    &&  .venv/bin/python -m pip install \
            jupyterlab notebook voila \
            ipykernel jupyterlab_widgets ipywidgets

# Julia jupyter kernel
RUN     pwd && echo $PATH && id && ls -al \
    &&  bash -c \
            "source .venv/bin/activate && echo 'using Pkg; Pkg.add(\"IJulia\")' | julia"

# R jupyter kernel
RUN     sudo bash -c \
            "source .venv/bin/activate && R -e \"install.packages('IRkernel', repos='https://cloud.r-project.org'); IRkernel::installspec(user=FALSE)\""

# python packages
RUN     .venv/bin/python -m pip install \
            numpy scipy pandas matplotlib scikit-image \
            requests \
            jinja2 \
            seaborn matplotlib plotly bokeh altair ggplot \
            jupyter-repo2docker

# CUDA ML packages
RUN     .venv/bin/python -m pip install \
            tensorflow

RUN     .venv/bin/python -m pip install \
            torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

RUN     .venv/bin/python -m pip install \
            jax[cuda12] -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html \
            cupy-cuda12x \
            xgboost lightgbm catboost keras \
            transformers accelerate diffusers

RUN     .venv/bin/python -m pip install \
            h5py joblib \
            scikit-learn-intelex \
            plenoptic \
            scikit-brain\
            statsmodels \
            nilearn mne \
            nengo brian2 neuron PyNN csa \
            odetoolbox pygsl antlr4-python3-runtime==4.10 \
            networkx[default]

COPY ./run-jupyter.sh /
ENTRYPOINT [ "/run-jupyter.sh" ]
