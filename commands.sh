# Manually muild the required images
docker build -f elastic8.dockerfile -t elastic8 .
docker build -f kibana8.dockerfile -t kibana8 .

# Only if you want to test stuff apart from docker-compose. This is not required otherwise.
docker network create --subnet=192.168.10.0/24 elastic

# Run Elasticsearch on the network whose name is "elastic" and make it available on localhost port 9200
docker run --name elastic8 --net elastic -p 9200:9200 -it -m 1GB elastic8

# Run Kibana on the network whose name is "elastic" and make it available on localhost port 5601
docker run --name kibana8 --net elastic -p 5601:5601 -m 1GB kibana8

# Docker compose commands ----------------------------------------------------------------------------------------------

# Simply run the ELK stack
docker compose up

# Force rebuild without using cache + run
docker compose build --no-cache && docker compose up
