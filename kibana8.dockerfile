FROM ubuntu:24.04

EXPOSE 5601/tcp

RUN apt -y update && apt -y upgrade
RUN apt -y install wget
RUN apt -y install curl
RUN apt update && apt -y install vim
RUN apt -y install sudo
RUN apt -y install gnupg
RUN apt -y install apt-transport-https
RUN apt -y install net-tools
RUN apt -y install python3

RUN groupadd kibana && useradd -m -s /bin/bash -g kibana kibana

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-8.x.list
RUN sudo apt-get update && sudo apt-get install kibana

ENV HOME=/home/kibana/
ENV KIBANA_HOME=/usr/share/kibana/
ENV PATH=$PATH:$KIBANA_HOME/bin/
ENV KIBANA_CONFIG=/etc/kibana/
ENV KIBANA_LOGS=/var/log/kibana/
ENV KIBANA_DATA=/var/lib/kibana/

ENV UDP_PORT=52635
ENV NETWORK_INTERFACE=eth0
#RUN echo "kibana ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/kibana

RUN chown -R kibana:kibana $KIBANA_HOME

COPY wait_for_elastic_ip_address.py $HOME
RUN chmod +x $HOME/wait_for_elastic_ip_address.py
COPY kibana.yml $KIBANA_CONFIG

RUN chown -R kibana:kibana $HOME
RUN chown -R kibana:kibana $KIBANA_CONFIG
RUN chown -R kibana:kibana $KIBANA_LOGS
RUN chown -R kibana:kibana $KIBANA_DATA

USER kibana
WORKDIR /home/kibana/

RUN echo "alias lm='ls -rtl'" > .bashrc

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"
CMD ["sh", "-c", "python3 -u wait_for_elastic_ip_address.py && kibana"]
#CMD ["sleep", "infinity"]

