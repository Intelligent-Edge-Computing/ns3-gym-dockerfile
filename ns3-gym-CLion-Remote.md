# Operations on your remote server
This way will let you sync your local codes with your remote server, and run your 
codes on your remote server, i.e., remote server just provides a pure compile and 
runtime environment.

## 1. Install Docker
Check [ubuntu_macos_docker_installation](ubuntu_macos_docker_installation.md)

## 2. Build Docker image

```bash
# clone ns3-gym-docker
git clone https://github.com/qijianpeng/ns3-gym-dockerfile.git ./dockerfiles
mv dockerfiles/docker-compose-rs.yml ./
mv dockerfiles/Dockerfile ./
# generate an image named "ns3.43-gym-rs:latest", using --progress to see what is exactly happening.
docker-compose -f docker-compose-rs.yml build  ns3-service --progress=plain 
```

## 3. Run Docker container using docker-compose and start ssh
```bash
docker-compose -f docker-compose-rs.yml up ns3-app  -d
docker-compose -f docker-compose-rs.yml exec -it ns3-app bash # enter the container
service ssh start # start ssh service, used in Remote Development in CLion
```

# Operations on local machine
## 1. Download codes

```bash
# 1. clone ns-3
git clone https://gitlab.com/nsnam/ns-3-dev.git ns-3
cd ns-3
git checkout ns-3.42 && git checkout -b ns-3.42-release

# 2. clone ns3-gym
cd contrib/
git clone -b app-ns-3.42  https://github.com/rogerio-silva/ns3-gym.git ./opengym
```

## Configure CLion and PyCharm
Check CLion official site, [Remote with local sources](https://www.jetbrains.com/help/clion/remote-projects-support.html).
The same with PyCharm (may be used in `ns3-gym` development).

Note: Remote Development for Python in CLion is not supported yet, just use PyCharm's Remote Development instead.

For a short note, Settings | Build, Execution, Deployment | `Deployment` and `Toolchains` needed to be configured.

IMPORTANT: You need to wait for the loading process of both CLion and PyCharm to be done.

# Install ns3-gym on your Remote Server
```bash
cd ns-3/contrib/opengym
python3 -m pip install --user ./model/ns3gym
```

Enjoy!
---

Disclamation: Any issues caused by the use of this repo should be resolved by yourself.
