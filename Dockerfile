# Set the base image to Ubuntu 16.04 and NVIDIA GPU
FROM nvidia/cuda:10.2-devel-ubuntu18.04

ARG CONDA_VERSION=py38_4.9.2

WORKDIR /home

ENV PATH /opt/conda/bin:$PATH

RUN apt-get update && \
    apt-get install --yes \
                        wget \
                        libz-dev \
                        apt-transport-https \
                        git

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O miniconda.sh && \
    mkdir -p /opt && \
    sh miniconda.sh -b -p /opt/conda && \
    rm miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \

    /opt/conda/bin/conda clean -afy


RUN pip install ont-bonito && \
    bonito download --models --latest -f && \
    apt-get autoremove --purge --yes && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*