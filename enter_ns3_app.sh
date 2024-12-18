#!/bin/bash

# 检查 Docker Compose 是否启动
if ! docker compose ps | grep -q "ns3-app"; then
    echo "Service 'ns3-app' is not running. Run start_ns3_app.sh first."
fi

docker-compose exec -it  ns3-app bash
