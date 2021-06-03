# for development use
FROM ubuntu:20.04
RUN apt-get update

RUN apt install -y tzdata  wget apt-transport-https curl gnupg
RUN apt install -y lsof git
RUN apt install -y postgresql-client
RUN apt-get update


RUN sh -c 'wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get update
RUN apt-get install -y dart

RUN mkdir /work
WORKDIR /work

CMD bash
