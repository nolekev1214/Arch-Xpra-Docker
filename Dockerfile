FROM archlinux:base-devel

LABEL maintainer="nolekev1214"

RUN pacman-key --init

# Modify configuration files
RUN printf "\n%s\n%s\n" "[multilib]" "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Sy
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
RUN locale-gen

# Set up dependencies
RUN yes | pacman -Syyu
RUN yes | pacman -S wine lib32-mesa \
    git xterm xorg-server \
    pipewire-jack wireplumber xpra \
    mesa-demos lib32-mesa mesa-utils \
    rustup

# Set up user account
ENV HOME /home/build
RUN useradd -m --create-home --home-dir $HOME build \
    && chown -R build:build $HOME
RUN echo "build ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/build
WORKDIR $HOME
USER build

# Set up AUR and additional dependencies
RUN rustup toolchain install stable
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -si --noconfirm && \
    cd .. && \
    rm -rf yay
RUN yes | yay -S xpra-html5-git python-xdg dbus-x11
RUN yes | yay -S rustlings sublime-text-4
RUN git clone https://github.com/rust-lang/rustlings.git

# Set environment variables
ENV DISPLAY=:100
# ENV LIBGL_ALWAYS_SOFTWARE=true
EXPOSE 8080

# Launch final command
CMD xpra start --bind-tcp=0.0.0.0:8080 --html=on --start=xterm --daemon=no ${DISPLAY}