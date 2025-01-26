FROM ubuntu:24.04

EXPOSE 5601/tcp

RUN apt -y update && apt -y upgrade
RUN apt -y install wget && apt -y install gnupg && apt -y install curl

RUN groupadd kibana && useradd -m -s /bin/bash -g kibana kibana

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor -o /usr/share/keyrings/elasticsearch-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-8.x.list
RUN apt -y update && apt -y install kibana

ENV HOME=/home/kibana/
ENV KIBANA_HOME=/usr/share/kibana/
ENV PATH=$PATH:$KIBANA_HOME/bin/
ENV KIBANA_CONFIG=/etc/kibana/
ENV KIBANA_LOGS=/var/log/kibana/
ENV KIBANA_DATA=/var/lib/kibana/

RUN chown -R kibana:kibana $KIBANA_HOME

COPY kibana.yml $KIBANA_CONFIG

RUN chown -R kibana:kibana $HOME
RUN chown -R kibana:kibana $KIBANA_CONFIG
RUN chown -R kibana:kibana $KIBANA_LOGS
RUN chown -R kibana:kibana $KIBANA_DATA

USER kibana
WORKDIR /home/kibana/

RUN echo "alias lm='ls -rtl'" > .bashrc

ENV ES_JAVA_OPTS="-Xms512m -Xmx512m"
CMD ["kibana"]
