import time
import urllib.request
from urllib.error import URLError, HTTPError


# ----------------------------------------------------------------------------------------------------------------------
def wait_for_elasticsearch(url, timeout=30, interval=1):
    start_time = time.time()
    while True:
        try:
            # Open the URL and check the status
            with urllib.request.urlopen(url) as response:
                if response.status == 200:
                    print(f"Elasticsearch is ready at {url}")
                    return True
        except HTTPError as e:
            print(f"HTTPError: {e.code} {e.reason}")
        except URLError as e:
            print(f"URLError: {e.reason}")
        except ConnectionResetError:
            print("Connection reset by peer, retrying...")


        # Check if timeout is reached
        elapsed_time = time.time() - start_time
        if elapsed_time >= timeout:
            print(f"Timeout reached after {timeout} seconds. Elasticsearch is not ready.")
            return False

        time.sleep(interval)

# ----------------------------------------------------------------------------------------------------------------------
if __name__ == "__main__":
    elastic_url = "http://localhost:9200"
    if wait_for_elasticsearch(elastic_url):
        exit(0)
    else:
        exit(1)
