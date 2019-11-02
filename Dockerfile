FROM archlinux/base

MAINTAINER Martynas Mickevičius <self@2m.lt>

# Freeze Archlinux mirror to the date that the base image was built on
RUN echo -n "Server=https://archive.archlinux.org/repos/" > /etc/pacman.d/mirrorlist
RUN tail -1 /var/log/pacman.log | cut -d[ -f2 | cut -d'T' -f1 | sed s'/-/\//g' | tr -d '\n' >> /etc/pacman.d/mirrorlist
RUN echo '/$repo/os/$arch' >> /etc/pacman.d/mirrorlist

RUN pacman -Syu --needed --noconfirm sudo namcap fakeroot audit grep

RUN useradd --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
