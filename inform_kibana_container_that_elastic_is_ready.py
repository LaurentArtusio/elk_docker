import socket
import psutil
import time
import os

# ----------------------------------------------------------------------------------------------------------------------
network_interface = os.getenv("NETWORK_INTERFACE")
udp_port = int(os.getenv("UDP_PORT"))
# ----------------------------------------------------------------------------------------------------------------------
def get_broadcast_address(interface_name):
    # Get the broadcast address for a given interface
    for iface, snics in psutil.net_if_addrs().items():
        if iface == interface_name:
            for snic in snics:
                # Look for IPv4 address with a broadcast address
                if snic.family == socket.AF_INET:
                    return snic.broadcast
    return None

# ----------------------------------------------------------------------------------------------------------------------
def udp_broadcast_request(interface_name, message):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    broadcast_address = get_broadcast_address(interface_name)

    if not broadcast_address:
        print(f"No broadcast address found for interface '{interface_name}'. Make sure the interface is active.")
        return

    for iteration in range(15):
        sock.sendto(message.encode(), (broadcast_address, udp_port))
        print(f"Broadcast request sent to {broadcast_address}: {message}")
        time.sleep(1)

# ----------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    udp_broadcast_request(network_interface, "elasticsearch")
