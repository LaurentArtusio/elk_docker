import os
import socket

udp_port = int(os.getenv("UDP_PORT"))
kibana_config_path = os.getenv("KIBANA_CONFIG")

# ----------------------------------------------------------------------------------------------------------------------
# This function is blocking and wait for the Elastic container to send its IP address
def wait_for_udp_listener(expected_message):
    # Set up the socket for UDP broadcasting
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

    # Enable broadcasting
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

    # Bind to all interfaces (0.0.0.0) on a specific port
    sock.bind(("0.0.0.0", udp_port))  # Port
    print(f"Listening for UDP broadcast on port {udp_port} ...")

    while True:
        # Listen for incoming broadcast messages
        data, addr = sock.recvfrom(1024)  # Buffer size of 1024 bytes
        message = data.decode()
        print(f"Received message: {data.decode()} from {addr}")
        if message == expected_message:
            return addr[0]
# ----------------------------------------------------------------------------------------------------------------------
def set_elastic_hosts(elastic_host_ip_address):
    kibana_yml_path = kibana_config_path + "/kibana.yml"
    elasticsearch_hosts_config = f"elasticsearch.hosts: [\"http://{elastic_host_ip_address}:9200\"]"
    with open(kibana_yml_path, "a") as file:
        file.write(elasticsearch_hosts_config + "\n")

# ----------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    elastic_node_address = wait_for_udp_listener("elasticsearch")
    print(f"OK : received expected message from elasticsearch container. Let's configure Kibana with Elastic node ip {elastic_node_address}")
    set_elastic_hosts(elastic_node_address)


