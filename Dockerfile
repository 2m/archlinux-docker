FROM docker.io/archlinux/archlinux:latest

LABEL maintainer="self@2m.lt"

# Freeze Archlinux mirror to the date that the base image was built on
RUN echo -n "Server=https://archive.archlinux.org/repos/" > /etc/pacman.d/mirrorlist
RUN tail -1 /var/log/pacman.log | cut -d[ -f2 | cut -d'T' -f1 | sed s'/-/\//g' | tr -d '\n' >> /etc/pacman.d/mirrorlist
RUN echo '/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

RUN pacman -Syu --needed --noconfirm sudo namcap fakeroot audit grep diffutils

# dependencies for yay
RUN pacman -S --noconfirm git base-devel

RUN useradd --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# configure default gpg key server to a more reliable one
COPY gpg.conf /home/build/.gnupg/gpg.conf
RUN chown -R build:build /home/build/.gnupg
RUN chmod 700 /home/build/.gnupg
RUN chmod 600 /home/build/.gnupg/gpg.conf

USER build
WORKDIR /home/build

# install yay which can be used to install AUR dependencies
RUN git clone https://aur.archlinux.org/yay.git
RUN cd yay && makepkg --syncdeps --install --noconfirm
