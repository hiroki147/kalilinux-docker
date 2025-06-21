FROM kalilinux/kali-rolling:latest
LABEL maintainer="admin@csalab.id"
RUN sed -i "s/http.kali.org/mirrors.ocf.berkeley.edu/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade

# 日本語フォント・ロケール・入力環境の追加
RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    sudo \
    openssh-server \
    python2 \
    python3-pip \
    python3-virtualenv \
    dialog \
    firefox-esr \
    inetutils-ping \
    htop \
    nano \
    net-tools \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    tigervnc-viewer \
    novnc \
    dbus-x11 \
    fonts-noto-cjk \
    fcitx-mozc \
    locales

# ロケール（日本語）を有効化
RUN sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

RUN DEBIAN_FRONTEND=noninteractive apt-get -yq install \
    xfce4-goodies \
    kali-desktop-xfce && \
    apt-get -y full-upgrade

RUN apt-get -y autoremove && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -c "Kali Linux" -s /bin/bash -d /home/kali kali && \
    sed -i "s/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g" /etc/ssh/sshd_config && \
    sed -i "s/off/remote/g" /usr/share/novnc/app/ui.js && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir /run/dbus && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    touch /usr/share/novnc/index.htm

COPY startup.sh /startup.sh

USER kali
WORKDIR /home/kali
RUN mkdir -p /home/kali/.config && \
    virtualenv /home/kali/.config/app && \
    echo "source /home/kali/.config/app/bin/activate" >> /home/kali/.bashrc && \
    # fcitx設定: 日本語入力を有効化するための環境変数
    echo "export GTK_IM_MODULE=fcitx" >> /home/kali/.bashrc && \
    echo "export QT_IM_MODULE=fcitx" >> /home/kali/.bashrc && \
    echo "export XMODIFIERS=@im=fcitx" >> /home/kali/.bashrc && \
    # デフォルトロケールを日本語に
    echo "export LANG=ja_JP.UTF-8" >> /home/kali/.bashrc && \
    echo "export LANGUAGE=ja_JP:ja" >> /home/kali/.bashrc && \
    echo "export LC_ALL=ja_JP.UTF-8" >> /home/kali/.bashrc

ENV PASSWORD=kalilinux
ENV SHELL=/bin/bash
EXPOSE 8080
ENTRYPOINT ["/bin/bash", "/startup.sh"]
