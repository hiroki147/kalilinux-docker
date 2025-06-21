FROM kalilinux/kali-rolling:latest

# ミラー変更と基本アップデート
RUN sed -i "s/http.kali.org/mirrors.ocf.berkeley.edu/g" /etc/apt/sources.list && \
    apt-get update && \
    apt-get -y upgrade

# 主要パッケージ + デスクトップ + 日本語 + ツール完全版
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
    locales \
    kali-desktop-xfce \
    xfce4-goodies \
    kali-linux-everything \
    task-japanese-desktop

# ロケール生成・有効化
RUN sed -i -e 's/# ja_JP.UTF-8 UTF-8/ja_JP.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    update-locale LANG=ja_JP.UTF-8 LANGUAGE=ja_JP:ja LC_ALL=ja_JP.UTF-8 && \
    echo 'LANG=ja_JP.UTF-8' > /etc/default/locale

# ユーザー作成・初期設定など
RUN apt-get -y autoremove && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -c "Kali Linux" -s /bin/bash -d /home/kali kali && \
    sed -i "s/#ListenAddress 0.0.0.0/ListenAddress 0.0.0.0/g" /etc/ssh/sshd_config && \
    sed -i "s/off/remote/g" /usr/share/novnc/app/ui.js || true && \
    echo "kali ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /run/dbus && \
    ln -s /usr/bin/python3 /usr/bin/python || true && \
    touch /usr/share/novnc/index.htm

# スタートアップスクリプトの追加
COPY startup.sh /startup.sh

# ユーザー環境設定（日本語IMEと仮想環境）
USER kali
WORKDIR /home/kali
RUN mkdir -p /home/kali/.config && \
    virtualenv /home/kali/.config/app && \
    echo "source /home/kali/.config/app/bin/activate" >> /home/kali/.bashrc && \
    echo "export GTK_IM_MODULE=fcitx" >> /home/kali/.bashrc && \
    echo "export QT_IM_MODULE=fcitx" >> /home/kali/.bashrc && \
    echo "export XMODIFIERS=@im=fcitx" >> /home/kali/.bashrc && \
    echo "export LANG=ja_JP.UTF-8" >> /home/kali/.bashrc && \
    echo "export LANGUAGE=ja_JP:ja" >> /home/kali/.bashrc && \
    echo "export LC_ALL=ja_JP.UTF-8" >> /home/kali/.bashrc

# 起動環境変数とポート公開
ENV PASSWORD=kalilinux
ENV SHELL=/bin/bash
EXPOSE 8080
ENTRYPOINT ["/bin/bash", "/startup.sh"]
