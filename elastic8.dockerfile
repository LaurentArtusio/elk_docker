# Use the official Elasticsearch image from Docker Hub
FROM ubuntu:24.04

EXPOSE 9200/tcp

RUN apt-get update --fix-missing && apt -y upgrade
RUN apt -y install gnupg && apt -y install wget && apt -y install curl

RUN groupadd elasticsearch && useradd -m -s /bin/bash -g elasticsearch elasticsearch
RUN echo "alias lm='ls -rtl'" >> /home/elasticsearch/.bashrc

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
RUN apt -y update && apt -y install elasticsearch

ENV HOME=/home/elasticsearch/
ENV ELASTIC_HOME=/usr/share/elasticsearch/
ENV PATH=$PATH:$ELASTIC_HOME/bin/
ENV ELASTIC_CONFIG=/etc/elasticsearch/
ENV ELASTIC_LOGS=/var/log/elasticsearch/
ENV ELASTIC_DATA=/var/lib/elasticsearch/

ENV UDP_PORT=52635

COPY elasticsearch.yml $ELASTIC_CONFIG

RUN chown -R elasticsearch:elasticsearch $ELASTIC_HOME
RUN chown -R elasticsearch:elasticsearch $ELASTIC_CONFIG
RUN chown -R elasticsearch:elasticsearch $ELASTIC_LOGS
RUN chown -R elasticsearch:elasticsearch $ELASTIC_DATA

RUN chown -R elasticsearch:elasticsearch $HOME

USER elasticsearch
WORKDIR /home/elasticsearch

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"
CMD ["elasticsearch"]

