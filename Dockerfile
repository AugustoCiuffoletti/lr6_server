FROM ubuntu:focal

RUN apt-get update
RUN apt-get --quiet=2 --yes install apt-utils
RUN yes | unminimize
RUN apt-get --quiet=2 --yes upgrade

RUN apt-get --quiet=2 --yes install nano
RUN apt-get --quiet=2 --yes install bash-completion
RUN apt-get --quiet=2 --yes install openssh-server
RUN apt-get --quiet=2 --yes install sudo

# Setup the default user.
RUN useradd -rm -d /home/user -s /bin/bash -g root -G sudo user
RUN echo 'user:user' | chpasswd
RUN ssh-keygen -A -v

# Tools per esercizi networking
RUN apt-get --quiet=2 --yes install netcat iproute2 net-tools dnsutils iputils-ping traceroute nmap
# Installazione strumenti di sviluppo
RUN apt-get --quiet=2 --yes install make git
RUN apt-get --quiet=2 --yes install openssh-client openssh-server
# Installazione cattura pacchetti
RUN apt-get --quiet=2 --yes install tcpdump

# Tools per esercizi Flask
RUN apt-get -qq update \
    && apt-get -qq --no-install-recommends install pip

### Cleanup (moved)
RUN apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/*
### end moved

# Installazione flask
COPY requirements.txt .
RUN pip install -r requirements.txt
ENV FLASK_ENV=development

COPY startup.sh /startup.sh

WORKDIR /root
ENV HOME=/home/user \
    SHELL=/bin/bash

#RUN bash
    
CMD ["/startup.sh"]
