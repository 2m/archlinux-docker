FROM archlinux/base

MAINTAINER Martynas Mickevičius <self@2m.lt>

RUN pacman -Syu --needed --noconfirm sudo namcap fakeroot audit

RUN useradd --create-home build
RUN echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build
