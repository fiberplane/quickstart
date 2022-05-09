# Example setup: Docker with Nginx, Loki, Prometheus, and Fiberplane

This is a sample setup that provisions Nginx, Loki, Prometheus, and Fiberplane Proxy using Docker. Once up and running the program will send container logs to the Loki data source which can be accessed via Fiberplane.

Pre-requisites:

-   Get a Fiberplane account (currently in Closed Beta: sign up at fiberplane.com).
-   Make sure you have Docker installed the machine you intend to run this on.

**Setup**:

1. Pull down this repo and navigate to the root folder of the example.
2. Install the [Loki Docker Driver client](https://grafana.com/docs/loki/latest/clients/docker-driver/) that will send Docker logs to our Loki instance:

    `docker plugin install grafana/loki-docker-driver:latest --alias loki --grant-all-permissions`

3. Create a Fiberplane Proxy token:
    - in the app: navigate to Profile > Settings > + New Proxy
    - in the CLI: `fp proxies create`
4. Copy the generated token to a `.env` file in the root of this example setup (`./examples/docker-nginx-prometheus-loki-fiberplane/`) as such:

    `PROXY_API_TOKEN=<add_token_here>`

5. Start the Docker setup `docker compose up -d`

Docker will automatically download and install the required images and Fiberplane will connect to two data sources:

-   _Our dockerized Loki server_
-   _Our dockerized Prometheus server_

You can then verify that your notebook is connected to the above data sources and test out a few queries:

-   for Prometheus: `node_scrape_collector_duration_seconds`
-   for Loki: `{job=docker}`
