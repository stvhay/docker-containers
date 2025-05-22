FROM archlinux:base

# Initialize keyring
RUN     pacman-key --init
RUN     pacman -Sy --noconfirm --noprogressbar \
            archlinux-keyring \
    &&  pacman -Su --noconfirm --noprogressbar

# Base dev tools, add user, group sudo
RUN     pacman -Syu --noconfirm --noprogressbar \
            base-devel git \
    &&  echo $DOCKER_GID \
    &&  groupadd --system sudo \
    &&  useradd -m --groups sudo user \
    &&  sed -i -e \
            "s/Defaults    requiretty.*/ #Defaults    requiretty/g" \
            /etc/sudoers \
    &&  echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER user
WORKDIR /tmp

# Install AUR manager
RUN     git clone https://aur.archlinux.org/yay.git \
    &&  cd yay \
    &&  makepkg --noconfirm --noprogressbar -si \
    &&  yay --afterclean --removemake --save

# Installing packages
RUN     sudo pacman -Syu --noconfirm --noprogressbar \
            less \
            nano nvim vim \
            rust go r gcc-fortran \
            cmake ninja \
            boost-libs \
            python-{uv,pip,distutils-extra,uv} ruff \
            ffmpeg sox \
            docker
RUN     sudo usermod -aG docker user

RUN     yay -Syi --noconfirm --noprogressbar --removemake \
            julia-bin    

WORKDIR /home/user

# initialize user venv and jupyter
RUN     uv python install --python-preference only-managed 3.13 \
    &&  uv venv --python 3.13 .venv \
    &&  source .venv/bin/activate \
    &&  uv pip install -U wheel setuptools pip \
    &&  uv pip install \
            jupyterlab notebook voila \
            ipykernel \
    &&  python -m ipykernel install \
            --user \
            --name=science \
            --display-name="Science" \
    &&  deactivate

# python packages
RUN     source .venv/bin/activate \
    &&  uv pip install \
            numpy scipy pandas matplotlib scikit-image \
            requests \
            jinja2 \
            seaborn matplotlib plotly bokeh altair ggplot \
            jupyter-repo2docker

ENTRYPOINT [ "/home/user/.venv/bin/jupyter", "lab", "--LabApp.token=''", "--allow-root", "--ip=0.0.0.0", "--port=8889"]

