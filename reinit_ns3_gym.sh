#!/bin/bash

# 检查 Docker 是否运行（macOS Docker Desktop 提供的服务）
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker Desktop manually."
    exit 1
fi

# 检查 Docker Compose 是否启动
if ! docker compose ps | grep -q "ns3-app"; then
    echo "Service 'ns3-app' is not running. Starting the service..."
    docker compose up -d ns3-app
fi

# 在 ns3-app 容器中启动 SSH 服务并安装 Python 包
docker-compose exec ns3-app sh -c "
    cd /workspace/ns-3/contrib/opengym &&
    python3 -m pip install --user ./model/ns3gym
"

# 提示完成
echo "ns3gym package installed in ns3-app."
