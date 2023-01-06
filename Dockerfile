FROM ubuntu:22.04

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get -y update && apt-get -y upgrade && \
    apt-get install -y software-properties-common && \
    add-apt-repository restricted && \
    apt-get install -y python3 python3-pip python3-lxml aria2 \
    qbittorrent-nox tzdata p7zip-full p7zip-rar xz-utils curl wget pv jq \
    ffmpeg locales neofetch git make g++ gcc automake unzip \
    autoconf libtool libcurl4-openssl-dev \
    libsodium-dev libssl-dev libcrypto++-dev libc-ares-dev \
    libsqlite3-dev libfreeimage-dev swig libboost-all-dev \
    libpthread-stubs0-dev zlib1g-dev libpq-dev libffi-dev && \
    locale-gen en_US.UTF-8 

# Installing Mega SDK Python Binding
ENV PYTHONWARNINGS=ignore
ENV MEGA_SDK_VERSION="4.4.2"
RUN git clone https://github.com/meganz/sdk.git --depth=1 -b v$MEGA_SDK_VERSION ~/home/sdk \
    && cd ~/home/sdk && rm -rf .git \
    && autoupdate -fIv && ./autogen.sh \
    && ./configure --disable-silent-rules --enable-python --disable-examples \
    && make -j$(nproc) \
    && cd bindings/python/ && python3 setup.py bdist_wheel \
    && cd dist && ls && pip3 install --no-cache-dir megasdk-*.whl 

# Install Rclone
#RUN curl https://rclone.org/install.sh | bash 
RUN curl -O 'https://github.com/rclone/rclone/releases/download/v1.60.0/rclone-v1.60.0-linux-amd64.zip' && \
    unzip rclone-v1.60.0-linux-amd64.zip && \
    mv rclone-v1.60.0-linux-amd64/rclone rclone-v1.60.0-linux-amd64/test && cp rclone-*-linux-amd64/test /usr/bin/ && \
    chown root:root /usr/bin/test && \
    chmod 755 /usr/bin/test

RUN echo -e '#!/bin/bash\ntest' > /usr/bin/rclone && \
    chmod +x /usr/bin/rclone

WORKDIR /usr/src/app
RUN chmod 777 /usr/src/app

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash", "start.sh"]
