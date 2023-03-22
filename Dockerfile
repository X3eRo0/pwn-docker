FROM ubuntu:rolling

USER root

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_CTYPE=C.UTF-8
ENV TZ=Asia/Kolkata

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

LABEL maintainer="mishrasunny174@gmail.com"

RUN dpkg --add-architecture i386

RUN apt-get update &&\
apt-get dist-upgrade -y &&\
apt-get install -y ruby \
build-essential \
git \
python3 \
python3-pip \
ipython3 \
libc6:i386 \
libncurses5:i386 \
libstdc++6:i386 \
socat \
tmux \
strace \
ltrace \
libcapstone-dev \
seccomp \
ruby-dev \
xxd \
iproute2 \
vim \
sudo \
elfutils \
binutils-common \
python-is-python3 \
neovim && \
rm -rf /var/lib/apt/lists/*

RUN gem install one_gadget seccomp-tools

RUN cd /opt &&\
git clone --depth 1 --recurse-submodules https://github.com/pwndbg/pwndbg && \
cd pwndbg && ./setup.sh

RUN python -m pip install --upgrade pip && \
python -m pip install shellen ropgadget ropper

RUN python -m pip install git+https://github.com/Gallopsled/pwntools.git@dev

RUN git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
RUN git clone https://github.com/X3eRo0/CTFMate.git /opt/CTFMate
WORKDIR /opt/CTFMate
RUN python -m pip install -r requirements.txt
RUN chmod +x ctfmate.py
RUN ln -s /opt/CTFMate/ctfmate.py /usr/bin/ctfmate

RUN apt-get install -y autoconf

# RUN git clone https://github.com/mishrasunny174/libc-debug-build.git /opt/libc-debug-build
RUN git clone https://github.com/NixOS/patchelf.git /opt/patchelf
WORKDIR /opt/patchelf
RUN ./bootstrap.sh
RUN ./configure
RUN make -j 8
RUN make check
RUN make install

RUN pip3 install decomp2dbg && decomp2dbg --install 

WORKDIR /hack
COPY configs/ /root/
CMD ["tmux", "-u", "new"]
