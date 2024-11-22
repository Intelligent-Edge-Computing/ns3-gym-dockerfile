# ns3-gym-dockerfile
NO responsibilities for any issues.
## 1. Install Docker
Check [ubuntu_macos_docker_installation](ubuntu_macos_docker_installation.md)

## 2. Build Docker Image
```bash
docker build --memory=16g -t ns3.43-gym:latest .
```

## 3. Run Docker Container
```bash
docker-compose up -d
```
Enjoy!
---
Disclamation: Any issues caused by the use of this Dockerfile should be resolved by yourself.
