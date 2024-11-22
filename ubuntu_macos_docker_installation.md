
# 在 Ubuntu 和 MacOS 上安装 Docker 和 Docker Compose

---

## Ubuntu 系统

### 1. 更新系统包

更新系统的软件包索引和现有软件：

```bash
sudo apt update
sudo apt upgrade -y
```

---

### 2. 安装依赖包

安装一些必要的依赖包，以便后续操作：

```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```

---

### 3. 添加 Docker 官方 GPG 密钥

下载并添加 Docker 的 GPG 密钥：

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

---

### 4. 添加 Docker 软件源

将 Docker 的官方软件源添加到系统中：

```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

---

### 5. 更新包索引并安装 Docker

更新包索引并安装 Docker：

```bash
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
```

---

### 6. 验证 Docker 是否安装成功

检查 Docker 服务是否正常运行：

```bash
sudo systemctl status docker
```

测试 Docker 是否安装成功：

```bash
sudo docker run hello-world
```

---

### 7. （可选）将当前用户添加到 Docker 用户组

如果希望普通用户运行 Docker（无需使用 `sudo`），执行以下操作：

```bash
sudo usermod -aG docker $USER
```

然后注销并重新登录，或者运行以下命令使更改生效：

```bash
newgrp docker
```

验证是否可以不使用 `sudo` 运行 Docker：

```bash
docker run hello-world
```

---

### 8. （可选）启用开机启动

确保 Docker 在系统启动时自动启动：

```bash
sudo systemctl enable docker
```

---

### 卸载 Docker（如需重装）

如果需要卸载 Docker，可以运行以下命令：

```bash
sudo apt purge -y docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
sudo rm -rf /etc/docker
```

---

## MacOS 系统

### 1. 安装 Homebrew（如果尚未安装）

Docker for Mac 通常使用 Homebrew 来安装。如果尚未安装 Homebrew，可以运行以下命令安装：

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### 2. 使用 Homebrew 安装 Docker

运行以下命令安装 Docker：

```bash
brew install --cask docker
```

---

### 3. 启动 Docker 应用

安装完成后，运行以下命令启动 Docker 应用：

```bash
open /Applications/Docker.app
```

首次启动时，Docker 会要求你提供权限以安装必要的组件，按照提示完成操作。

---

### 4. 验证 Docker 是否安装成功

运行以下命令验证 Docker 是否安装成功：

```bash
docker --version
docker run hello-world
```

---

### 5. （可选）设置 Docker CLI 自动启动

通过 Docker 的图形界面，可以设置开机时自动启动 Docker 应用。

---

### 卸载 Docker（如需重装）

如果需要卸载 Docker，可以运行以下命令：

```bash
brew uninstall --cask docker
rm -rf ~/.docker
```

---

## 安装 Docker Compose（Ubuntu 和 MacOS 通用）

### Ubuntu 系统

#### 1. 下载 Docker Compose 二进制文件

运行以下命令下载 Docker Compose 最新稳定版本的二进制文件：

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

---

#### 2. 赋予执行权限

将二进制文件设置为可执行：

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

---

#### 3. 验证安装是否成功

运行以下命令检查 Docker Compose 版本以验证安装成功：

```bash
docker-compose --version
```

---

#### 4. （可选）启用全局可访问性

如果 `/usr/local/bin` 不在系统的 `PATH` 中，可能需要将其移动到其他目录，例如 `/usr/bin`：

```bash
sudo mv /usr/local/bin/docker-compose /usr/bin/docker-compose
```

---

### MacOS 系统

#### 1. 使用 Homebrew 安装 Docker Compose

在 MacOS 上，Docker Compose 通常与 Docker 一起通过 Docker Desktop 提供。如果需要单独安装 Docker Compose，可以使用 Homebrew：

```bash
brew install docker-compose
```

---

#### 2. 验证安装是否成功

检查安装是否成功：

```bash
docker-compose --version
```

---

### 更新 Docker Compose

在需要更新到最新版本时，重新下载二进制文件即可：

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/v2.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

---

### 卸载 Docker Compose

如需卸载 Docker Compose，可以直接删除安装路径下的二进制文件：

```bash
sudo rm /usr/local/bin/docker-compose
```

---