# Use the official Elasticsearch image from Docker Hub
FROM ubuntu:24.04

EXPOSE 9200/tcp

RUN apt-get update --fix-missing && apt -y upgrade
RUN apt -y install apt-transport-https
RUN apt -y install curl
RUN apt -y install vim
RUN apt -y install sudo
RUN apt -y install gnupg
RUN apt -y install net-tools
RUN apt -y install python3
RUN apt -y install python3-pip
RUN apt -y install python3-psutil
RUN apt -y install wget

RUN groupadd elasticsearch && useradd -m -s /bin/bash -g elasticsearch elasticsearch
RUN echo "alias lm='ls -rtl'" >> /home/elasticsearch/.bashrc

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
RUN apt -y update && apt -y install elasticsearch

ENV HOME=/home/elasticsearch/
ENV ELASTIC_HOME=/usr/share/elasticsearch/
ENV PATH=$PATH:$ELASTIC_HOME/bin/
ENV ELASTIC_CONFIG=/etc/elasticsearch/
ENV ELASTIC_LOGS=/var/log/elasticsearch/
ENV ELASTIC_DATA=/var/lib/elasticsearch/

ENV UDP_PORT=52635
ENV NETWORK_INTERFACE=eth0
#RUN echo "kibana ALL=(ALL) NOPASSWD:ALL" | tee /etc/sudoers.d/kibana

COPY elasticsearch.yml $ELASTIC_CONFIG

RUN chown -R elasticsearch:elasticsearch $ELASTIC_HOME
RUN chown -R elasticsearch:elasticsearch $ELASTIC_CONFIG
RUN chown -R elasticsearch:elasticsearch $ELASTIC_LOGS
RUN chown -R elasticsearch:elasticsearch $ELASTIC_DATA

COPY wait_for_elastic_to_be_ready.py $HOME
COPY inform_kibana_container_that_elastic_is_ready.py $HOME

RUN chown -R elasticsearch:elasticsearch $HOME

USER elasticsearch
WORKDIR /home/elasticsearch

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"
CMD ["sh", "-c", "elasticsearch & python3 wait_for_elastic_to_be_ready.py && python3 inform_kibana_container_that_elastic_is_ready.py && tail -f $ELASTIC_LOGS/elasticsearch.log"]
#CMD ["sleep","infinity"]
