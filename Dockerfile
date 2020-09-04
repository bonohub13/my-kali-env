FROM kalilinux/kali-rolling:latest

# Install components
RUN apt update && apt upgrade -y
RUN apt install -y \
    vim \
    zsh \
    git \
    hub \
    sudo \
    wget

# Environmental settings
ENV USER username
ENV HOME /home/${USER}
ENV SHELL /usr/bin/bash

# Setting password for root
RUN echo "root:root_passwd" | chpasswd

# Adding user and setting up password
RUN useradd -m ${USER}
RUN echo "${USER}:user_passwd" | chpasswd
RUN echo "${USER}   ALL=(ALL:ALLL)   ALL" >> /etc/sudoers
RUN chsh -s /usr/bin/zsh ${USER}
RUN chsh -s /usr/bin/zsh root

USER ${USER}
WORKDIR ${HOME}

# install default packages to use
RUN mkdir .repos .vim
RUN git clone https://github.com/bonohub13/vim_settings .repos/vim_settings
RUN git clone https://github.com/morhetz/gruvbox .repos/gruvbox
RUN cp .repos/vim_settings/.vimrc ${HOME}
RUN cp -r .repos/gruvbox/colors ${HOME}/.vim
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN sed -i.bak -e 's#ZSH_THEME="robbyrussell"#ZSH_THEME="bureau"' .zshrc

CMD ["zsh"]