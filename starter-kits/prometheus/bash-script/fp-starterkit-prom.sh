#!/bin/bash
### This script is for Linux & Macbooks ###
create_prometheus_config() {
cat > prometheus.yml << EOF
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: "prometheus"
    static_configs:
    - targets: ["localhost:9090"]

  - job_name: "node"
    static_configs:
    - targets: ["node-exporter:9100"]
EOF
}

create_data_sources_config() {
cat > data_sources.yaml << EOF
my Prometheus:
  type: prometheus
  url: http://prometheus:9090
EOF
}

create_docker_compose() {
cat > docker-compose.yml << EOF
version: '3.9'

services:
  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    restart: unless-stopped
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    expose:
      - 9100

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
    expose:
      - 9090
    depends_on:
      - node-exporter

  fp-proxy:
    image: fiberplane/proxy:v1
    container_name: fp-proxy
    restart: unless-stopped
    volumes:
      - ./data_sources.yaml:/app/data_sources.yaml
    command:
      -  --auth-token=$token
    depends_on:
      - prometheus
      - node-exporter
EOF
}

run_docker_compose() {
  if [[ -f data_sources.yaml && -f prometheus.yml && docker-compose.yml ]]; then
    sudo docker-compose -p fp-starter-kit up -d
    echo `sudo docker ps`
  fi
}

main() {
  read -p "Pre-Requisite: Prometheus, Node Exporter and Fibeplane proxy all run as docker containers, managed by docker compose. Hence please make sure you have docker and docker-compose installed and running before executing this script further. Are you happy to proceed (y/n)? " consent
  case "$consent" in
    y|Y ) 
      read -p "Please enter your Fiberplane token : " token
      if [ "$token" = "" ]; then   
        echo "You have not entered the Fiberplane token, please make sure you have the token handy before re-running the script. To generate one, please refer - https://docs.fiberplane.com/quickstart/set-up-the-fiberplane-proxy#cae32ee6460b490a98aa0ecf7fd82a71"
        exit 1
      fi
      create_prometheus_config
      create_data_sources_config
      create_docker_compose $token
      run_docker_compose
      ;;
    n|N ) 
      echo "You have chosen to not run the Fiberplane starter kit, if it was a mistake, please re-run the script. If it was about pre-requisites, please install docker and docker-compose and ensure they are running before you re-run this script." 
      ;;
    * ) 
      echo "Invalid Choice, please enter y/Y or n/N to choose if you want to run the script or not."
      ;;
  esac
}

main