FROM ubuntu:xenial
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
RUN locale-gen --purge en_US.UTF-8 && /bin/echo -e  "LANG=$LANG\nLANGUAGE=$LANGUAGE\n" | tee /etc/default/locale && locale-gen $LANGUAGE && dpkg-reconfigure locales

RUN apt-get update -qq && apt-get install -y apt-transport-https curl ca-certificates openssh-server software-properties-common python-dev python-pip python3-dev python3-pip weechat git tmux sudo zsh htop screen dialog
RUN curl -o /usr/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.5.4/bin/linux/amd64/kubectl && chmod +x /usr/bin/kubectl
RUN add-apt-repository ppa:neovim-ppa/stable && apt-get update && apt-get install -y neovim && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
RUN update-alternatives --config vi
RUN update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
RUN update-alternatives --config vim
RUN update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
RUN update-alternatives --config editor
RUN pip3 install neovim && pip install neovim
RUN mkdir /var/run/sshd
RUN useradd -d /home/armando -m -G sudo -s /bin/zsh armando
RUN usermod -p '*' armando
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config
RUN echo 'AuthorizedKeysFile  %h/.ssh/authorized_keys' >> /etc/ssh/sshd_config
RUN sed -i "s/UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config

USER root
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D", "-e"]
