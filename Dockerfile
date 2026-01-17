# syntax=docker/dockerfile:1
FROM archlinux:multilib-devel
RUN mkdir -p /var/src
WORKDIR /var/src
COPY . .
RUN pacman-key --init
RUN pacman -Syu --noconfirm && pacman -S --noconfirm git make cmake gcc gcc-multilib lib32-openal lib32-libx11 lib32-libxrandr lib32-libxinerama lib32-libxcursor lib32-libxi lib32-libglvnd zenity unzip python-jinja
RUN make build-i686

FROM archlinux:multilib-devel
ENV LEVEL=world MOTD="Ninecraft Server" MAX_PLAYERS=10
COPY --from=0 /var/src/build-i686/ninecraft/ninecraft-headless /bin
RUN mkdir -p /run
WORKDIR /run
EXPOSE 19132/tcp
EXPOSE 19132/udp
CMD ["/bin/sh", "-c", "/bin/ninecraft-headless --game /run --home /run --level \"${LEVEL}\" --motd \"${MOTD}\" --port 19132 --max-players \"${MAX_PLAYERS}\""]
