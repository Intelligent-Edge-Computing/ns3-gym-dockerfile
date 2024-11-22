# ns3-gym-dockerfile
NO responsibilities for any issues.
## 1. Install Docker
Check [ubuntu_macos_docker_installation](ubuntu_macos_docker_installation.md)

## 2. Download codes
Suppose your are in `/data1/data_1/jp/workspace`

```bash
export HOST_WORKSPACE_PATH=/data1/data_1/jp/workspace
cd ${HOST_WORKSPACE_PATH}
# 1. clone ns-3
git clone https://gitlab.com/nsnam/ns-3-dev.git ns-3
git checkout ns-3.42 && git checkout -b ns-3.42-release

# 2. clone ns3-gym
cd ns-3/contrib/
git clone -b app-ns-3.42  https://github.com/rogerio-silva/ns3-gym.git ./opengym

# 3. clone ns3-gym-docker
cd ${HOST_WORKSPACE_PATH}
git clone https://github.com/qijianpeng/ns3-gym-dockerfile.git ./dockerfiles
mv dockerfiles/.* ./
```

## 3. Build Docker Image
Before building the Docker image, make sure you have directory named `${HOST_WORKSPACE_PATH}`.

```bash
docker-compose build ns3-service --progress=plain # generate an image named "ns3.43-gym:latest", using --progress to see what is exactly happening.
```

## 4. Run Docker Container using docker-compose
```bash
docker-compose up ns3-app -d
docker-compose exec -it ns3-app bash # enter the container
#kill
docker-compose kill ns3-app # stop the container
```

## 5. Compile ns-3 and ns3-gym
Notes: I have not compiled ns-3 and ns3-gym while in the image building phase, 
because compiled files need persistence.
### 5.1 Compile ns-3
```bash
#1. compile ns-3
cd ${HOST_WORKSPACE_PATH}/ns-3
./ns3 configure --enable-examples --enable-python-bindings
./ns3 build
#2. test ns-3
```

### 5.2 Install ns3-gym
```bash
cd ${HOST_WORKSPACE_PATH}/ns-3/contrib/opengym
python3 -m pip install --user ./model/ns3gym
```

Enjoy!
---

Disclamation: Any issues caused by the use of this repo should be resolved by yourself.
