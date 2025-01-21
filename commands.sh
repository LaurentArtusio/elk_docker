# Build the required images
docker build -t -f elastic8.dockerfile . -t elastic8
docker build -t -f kibana8.dockerfile . -t kibana8


# Only if you want to test stuff apart from docker-compose. This is not required otherwise.
docker network create --subnet=192.168.10.0/24 elastic


#
docker run --name elastic8 --net elastic -p 9200:9200 -it -m 1GB elastic8
docker run --name kibana8 --net elastic -p 5601:5601 -m 1GB kibana8
