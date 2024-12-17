
# macOS环境下基于Docker开发ns-3、ns3-gym

本文目的是指导用户基于 Docker 搭建一个支持 `ns-3` 及 `ns3-gym` 开发的环境，并通过 CLion 和 PyCharm 等集成开发工具实现高效开发流程，方便快速移植。通过这种方式，用户可以将本地代码同步到远程节点，利用 Docker 提供的纯编译和运行环境，在不同远程设备上完成代码编译和执行，特别适用于网络仿真与 `ns3-gym`  集成开发场景，且适合使用 Python 绑定（Python binding）进行进一步开发和测试。当前版本安装了 [Gymnasium](https://github.com/Farama-Foundation/Gymnasium)、[stable-baselines3](https://stable-baselines3.readthedocs.io/en/master/)、pytorch环境，因此可探索AI for Networking。

⚠️基于 Docker，理论上非 macOS 系统同样适用。

下文的远程节点指的是docker运行起来的容器。如果容器位于本机，由于通过IP访问，也叫远程节点。

# 1. 构建docker镜像

## 1.1 安装 Docker

Docker 安装参考 [Docker 官方网站](https://www.docker.com/products/docker-desktop/) ，下载 **Docker Desktop for macOS**。

通过以下命令验证安装是否成功：

```bash
docker --version
docker compose version
```

如果 Docker 安装成功，将显示版本信息。

## 1.2 构建`ns3.42-gym-sb3-rs` 镜像

本步骤构建一个包含 ns-3 和 ns3-gym 编译及运行时依赖的 Docker 镜像，为远程开发提供稳定、可复用的运行环境。假设远程节点的当前目录为 `/workspace`，并在该目录下完成 Docker 镜像的构建和相关文件的部署。

```bash
# 克隆 ns3-gym-docker
git clone https://github.com/Intelligent-Edge-Computing/ns3-gym-dockerfile.git ./dockerfiles
mv dockerfiles/docker-compose-rs.yml ./docker-compose.yml
mv dockerfiles/Dockerfile ./
```

检查并修改 \`docker-compose.yml\` 文件中的 \`password\` ，设置一个安全且易于记忆的密码，用于远程 SSH 连接和访问容器内服务。

\# 生成名为 "ns3.42-gym-sb3-rs\:latest" 的镜像，使用 --progress 查看构建过程中的详细信息。

docker compose build ns3-service --progress=plain

过程比较久，加大内存、CPU核数，因为需要编译python bindings的依赖库`cppyy` 。

## 1.3 运行容器

启动 SSH 服务的目的是本地节点与远程节点通信。当然，使用已有的`.sh` 脚本也可以。

```bash
docker compose up ns3-app  -d
docker compose exec -it ns3-app bash # 进入容器
service ssh start # 启动 SSH 服务，用于 CLion、PyCharm的远程开发
```

# 2. 编译代码

假设目前位于`WORKSPACE = Users/qijianpeng/git/ns3/remote-ns3/workspace` 目录

## 2.1 clone 代码

主要clone `ns-3` , `ns3-gym` 的代码。

```bash
export WORKSPACE = Users/qijianpeng/git/ns3/remote-ns3/workspace
mkdir -p ${WORKSPACE}
cd ${WORKSPACE}
# 1. 克隆 ns-3
git clone https://gitlab.com/nsnam/ns-3-dev.git ns-3
cd ns-3
git checkout ns-3.42 && git checkout -b ns-3.42-release
# 2. 克隆 ns3-gym
cd contrib/
git clone -b app-ns-3.42  https://github.com/rogerio-silva/ns3-gym.git ./opengym
```

现在，在目录`WORKSPACE` 下主要包含如下结构：

```
WORKSPACE/
├── ns-3/
│   ├── contrib/             
│   │   └── opengym/         # ns3-gym 源码
│   ├── examples/            # 示例代码
│   └── ...
├── ...
├── docker-compose.yml       # Docker Compose 配置
└── Dockerfile               # Docker 镜像构建文件
```

⚠️因为OpenAI的gym目前已经更改为了Gymnasium，因此需要对ns3-gym中的代码进行适当修改。根据官方的兼容代码，需要将`import gym` 改为`import gymnasium as gym` , 在一些关键的API上可能也需要适当修改，比如`step` 方法。

## 2.2.  进入容器编译代码

⚠️ 为了持久化数据，映射目录一定要在`docker-compose.yml` 文件中写好，将编译后的代码文件存储在了宿主机（macOS）上。由于每次启动的docker容器环境都一样，因此代码只需要编译一次，便永久可用。

进入容器的`/workspace` 目录（在docker-compose.yml中已与宿主机`Users/qijianpeng/git/ns3/remote-ns3/workspace` 完成了映射），编译ns-3:

```bash
docker compose exec -it ns3-app bash # 进入容器
cd ns-3
./ns3 configure --enable-python-bindings --enable-examples
```

编译完后，安装 ns3-gym：

```bash
cd contrib/opengym
python3 -m pip install --user ./model/ns3gym
```

# 3. 配置 CLion 和 PyCharm

完成Remote with local sources 配置，具体参考 [JetBrains 官方指南](https://www.jetbrains.com/help/clion/remote-projects-support.html#deployment-entry)。

注意，IP 、PORT 应当填写运行起来的docker容器的ip和暴露的PORT （在docker-compose.yml 中有写）。

⚠️ CLion 暂不支持 Python 的远程开发，因此使用PyCharm单独对ns3-gym 进行开发。

完成上述步骤后，即可在本地编辑代码并远程编译和运行 ns-3  与 ns3-gym  项目。

---

免责声明：使用此仓库引起的任何问题需自行解决。
