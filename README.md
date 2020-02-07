# dotfiles

我个人的配置文件。用于在各种实体机/虚拟机/VPS上快速恢复环境。


## 平台和系统

我常用的平台和系统：
 - Windows + Debian (WLS)
 - Windows + Debian (VirtualBox)
 - Windows + Alpine (VirtualBox)
 - macOS
 - Debian (物理机)
 - Debian (VPS)
脚本需要在上述平台（系统）上均能成功运行。


## 问题和解决

- 没有 `sudo`。

  如果在安装 Debian 的时候输入了 root 账户的密码，没有安装 `sudo`。

  **【应对】**

  所以配置文件首先得安装 `sudo` 并且把常用账户添加到 `/etc/soduers` 文件中。

- 网络连接不稳定。

  因为 GFW 的存在，在国内访问 docker、docker-compose 以及 GitHub 下载的时候往往出现网络错误。Debian 包因为有国内镜像反而比较可靠。

  **【应对】**

  将涉及到 docker、docker-compose 和 GitHub 的操作分离成单独的脚本，避免因为网络错误导致自动化执行失败。


## 使用方法

1. 安装 `sudo`。

    - 用普通账户登录：

      ```
      # su -l -s /usr/bin/bash -c "$(wget -O- https://raw.github.com/BruceFrankWong/dotfiles/master/bootstrap.sh)"
      ```

    - 用 root 账户登录：

      ```
      # /usr/bin/bash -c "$(wget -O- https://raw.github.com/BruceFrankWong/dotfiles/master/bootstrap.sh)"
      ```

1. 安装其它软件并配置设定。
    ```
    # setup.sh
    ```

## 详细说明


## TODO

需要持续的更新。

