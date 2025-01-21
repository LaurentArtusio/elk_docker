# elk_docker

This project offers a pre-configured setup of Elasticsearch and Kibana, bundled together for seamless integration. The
Elasticsearch data are stored in a Docker volume which make them persistent between two runs.

## Requirements

You need [Docker](https://docs.docker.com/engine/install/) + [Docker Compose](https://docs.docker.com/desktop/setup/install/linux/) 

## Running the stack

From the project directory, type ``docker-compose up``

This command builds both the Elasticsearch and Kibana containers before running them. So the first run can take some time.

## Project files
- The ``elasticsearch.yml`` and ``kibana.yml`` files serve as configuration files for Elasticsearch and Kibana, respectively. 
These files are copied into their corresponding container images. For simplicity, Elasticsearch security features are 
disabled, and Elasticsearch is configured to run as a single-node cluster.
- The ``elastic8.dockerfile`` and ``kibana8.dockerfile`` define the Dockerfiles used to build the container images for 
Elasticsearch and Kibana.
- The ``commands.sh`` file contains a list of commands that can be run manually for testing purposes.
