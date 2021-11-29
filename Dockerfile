FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=yoichiro

RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends \
    install git wget autoconf automake build-essential bzip2 ccache device-tree-compiler \
	dfu-util g++ gcc libtool make ninja-build cmake python3-dev python3-pip \
	python3-setuptools xz-utils

RUN groupadd --gid 1000 $USERNAME && useradd -u 1000 -g 1000 -s /bin/bash -d /home/$USERNAME -m $USERNAME
USER $USERNAME

WORKDIR /home/$USERNAME

RUN pip3 install --user -U west
RUN echo 'export PATH=~/.local/bin:"$PATH"' >> ~/.bashrc
RUN export ZSDK_VERSION=0.12.4 && \
    wget -q "https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v${ZSDK_VERSION}/zephyr-toolchain-arm-${ZSDK_VERSION}-x86_64-linux-setup.run" && \
    sh "zephyr-toolchain-arm-${ZSDK_VERSION}-x86_64-linux-setup.run" --quiet -- -d ~/.local/zephyr-sdk-${ZSDK_VERSION} && \
    rm "zephyr-toolchain-arm-${ZSDK_VERSION}-x86_64-linux-setup.run"

VOLUME /home/$USERNAME/project

CMD ["/bin/bash"]
