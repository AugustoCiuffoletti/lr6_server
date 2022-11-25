FROM ubuntu:jammy-20221020 as system

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get --yes install sudo ca-certificates
#RUN apt-get --quiet=2 --yes install apt-utils
#RUN yes | unminimize
#RUN apt-get --quiet=2 --yes upgrade

RUN apt-get --yes install nano openssh-client openssh-server
# RUN apt-get --quiet=2 --yes install bash-completion
# RUN apt-get --quiet=2 --yes install openssh-server
# RUN apt-get --quiet=2 --yes install sudo


# Tools per esercizi networking
RUN apt-get --yes install netcat iproute2 net-tools dnsutils iputils-ping traceroute nmap curl
# Installazione strumenti di sviluppo
RUN apt-get --yes install make git
RUN apt-get --yes install openssh-client openssh-server

# Tools per esercizi Flask
RUN apt-get -qq update \
    && apt-get -qq --no-install-recommends install pip

# Setup the default user.
#RUN useradd -rm -d /home/user -s /bin/bash -g root -G sudo user
#RUN echo 'user:user' | chpasswd
#RUN ssh-keygen -A -v

ARG username="user"
ARG password="user"

RUN useradd \
	--create-home \
	--shell /bin/bash \
	--groups adm,sudo \
	--password "$(openssl passwd -1 $password)"\
	$username
RUN mkdir /home/$username/.ssh

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

COPY entrypoint.sh /opt
    
CMD ["/opt/entrypoint.sh"]
