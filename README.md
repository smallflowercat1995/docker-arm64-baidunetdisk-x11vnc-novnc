
# 在 arm64 树莓派 4 B 1.1 上使用 docker 容器启动百度网盘使用 novnc 远程访问
## dockerhub
<a href="https://hub.docker.com/r/smallflowercat1995/debian-baidunetdisk" title="链接">https://hub.docker.com/r/smallflowercat1995/debian-baidunetdisk</a>  
![Watchers](https://img.shields.io/github/watchers/smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc) ![Stars](https://img.shields.io/github/stars/smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc) ![Forks](https://img.shields.io/github/forks/smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc) ![Vistors](https://visitor-badge.laobi.icu/badge?page_id=smallflowercat1995.docker-arm64-baidunetdisk-x11vnc-novnc) ![LICENSE](https://img.shields.io/badge/license-CC%20BY--SA%204.0-green.svg)
<a href="https://star-history.com/#smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc&type=Date" />
  </picture>
</a>

## 用途
1、当你有了一个 arm64 的设备，你又不想让它吃灰  
2、当你不是会员，却还想每天开着电脑下载  
3、为了省电，毕竟你的 x86_64 台式电脑可不是一天24小时开机的，那得多费电，在我老家黑龙江，省电省水很重要。。。  
5、其实稍微改改在替换几个安装包 x86_64 的系统也可以使用呢！！好神奇啊！！！  
6、emm，以后想到再说，现在，我要去想想再构建点什么有意思的东西 @_@ ...  

## 目录结构
    .
    ├── Dockerfile                                           # 这个是 docker 构建文件    
    ├── docker-compose.yml                                   # 这个是 docker-compose.yml 文件  
    ├── .env                                                 # 默认 novnc 端口号:36080 x11vnc 端口号:5902  x11vnc 密码:123456 这个是环境配置文件 
    └── package                                              # 这个是二进制文件、脚本、配置文件所在目录   
        ├── baidunetdisk_4.3.0_arm64_2022-06-28.tar.xz.00    # 这个是百度网盘 arm64 安装包拆分00  
        ├── baidunetdisk_4.3.0_arm64_2022-06-28.tar.xz.01    # 这个是百度网盘 arm64 安装包拆分01  
        ├── baidunetdisk_4.3.0_arm64_2022-06-28.tar.xz.02    # 这个是百度网盘 arm64 安装包拆分02  
        ├── baidunetdisk_4.3.0_arm64_2022-06-28.tar.xz.03    # 这个是百度网盘 arm64 安装包拆分03  
        ├── install.sh                                       # 这个是构建镜像的时候在容器内执行流程的脚本   
        ├── libappindicator3-1_0.4.92-7_arm64.deb            # 这个是百度网盘 arm64 依赖   
        ├── libindicator3-7_0.5.0-4_arm64.deb                # 这个是百度网盘 arm64 依赖   
        └── startapp.sh                                      # 这个是启动服务的脚本  


## 依赖
    arm64 设备
    docker 程序
    docker-compose python程序
    我目前能想到的必要程序就这些吧

## 构建命令
    # clone 项目
    git clone https://github.com/smallflowercat1995/docker-arm64-baidunetdisk-x11vnc-novnc.git
    # 进入目录
    cd docker-arm64-baidunetdisk-x11vnc-novnc
    # 无缓存构建
    docker-compose build --no-cache

## 修改 .env 和 docker-compose.yml 文件后检查
    docker-compose config

## 构建完成后 后台启动
    docker-compose up -d

## 新增
1、新增百度安装包压缩并拆分小于 50M 逃避 github 超过 50M 大小文件触发 git lfs 限制  

## 注意
1、百度网盘可能启动过慢，可以稍微等个1分钟看看，超过一分钟可能是寄寄了  
2、启动百度网盘登陆后需要将默认下载路径修改为 /baidunetdiskdownload 配置始终  
3、设置弹窗无法消除，经过测试可以通过拖动设置弹窗后面的文件夹使设置弹窗消失，虽然这么描述，但是我觉得可能还是有人会不理解，哈哈>V<  
<img src="https://user-images.githubusercontent.com/94947393/179397315-5ecfe497-95ba-454e-bfe2-c1aa5c85bec0.png" title="使设置弹窗消失" alt="使设置弹窗消失" style="zoom: 50%;" />

## 缺点  
~~如果断电了，容器重新启动，那么服务可能都被干掉了，不过没关系，至少容器会正常运行，就是里面的程序都不行，这个时候你就需要进入容器重新启动那些服务~~  

~~# 进入容器目录，我的目录是 /mnt/sdb1/build-debian-baidunetdisk~~  
~~cd /mnt/sdb1/build-debian-baidunetdisk~~  
~~# 进入容器~~  
~~docker-compose exec -it baidunetdisk-app bash~~  
~~# 执行服务启动脚本~~   
~~bash /root/startapp.sh~~  
~~# 退出容器，ctrl + D ，这次总该可以了吧？~~  

镜像太大，我觉得就是百度网盘需要的依赖太多，我没办法了，真的没办法了老天爷救命啊  
<img src="https://user-images.githubusercontent.com/94947393/179397747-3b30864d-db24-4ebf-9b8b-9d59965a52e1.png" title="镜像太大" alt="镜像太大" style="zoom: 50%;" />

# 制作思路
## 获取基础镜像
    docker pull debian:11

## 启动个容器测试可以持久化到 docker-compose 
    docker create -it \
                --name 'debian-baidunetdisk-latest-container' \
                --restart 'always' \
                --env NOVNC_PORT=36080 --env VNC_PORT=5902 --env VNC_PASSWORD=123456 \
                -p 36080:36080 -p 5902:5902 \
                -v ../docker-container/baidunetdisk/baidunetdiskdownload:/baidunetdiskdownload:rw \
                -v ../docker-container/baidunetdisk/config:/config:rw \
                debian:11 \
                bash

## 复制安装包
    docker cp package/baidunetdisk_4.3.0_arm64.deb 'debian-baidunetdisk-latest-container':/root/  
    docker cp package/libindicator3-7_0.5.0-4_arm64.deb 'debian-baidunetdisk-latest-container':/root/  
    docker cp package/libappindicator3-1_0.4.92-7_arm64.deb 'debian-baidunetdisk-latest-container':/root/  

##  启动容器
    docker start 'debian-baidunetdisk-latest-container'

## 进入容器
    docker exec -it 'debian-baidunetdisk-latest-container' bash

## 容器内操作这部分可以作为构建镜像流程
    ## 检查环境变量传入情况
    echo -e 'novnc 端口：'${NOVNC_PORT}'\nvnc 端口：'${VNC_PORT}'\n密码：'${VNC_PASSWORD}
    ## 改时区
    date '+%Y-%m-%d %H:%M:%S'
    cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
    rm -rfv /etc/localtime
    ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
    echo "Asia/Shanghai" > /etc/timezone
    date '+%Y-%m-%d %H:%M:%S'

    ## 更新源安装 https 支持执行三次避免失败
    for((i=1;i<4;i++)) ; do
        echo "try $i"
        ## 更新软件列表源
        apt update
        ## 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
        apt-get -y install apt-transport-https ca-certificates apt-utils
    done

    ## 备份源
    cp -rv /etc/apt/sources.list /etc/apt/sources.list.bak

    ## 写入清华源
    cat << EOF > /etc/apt/sources.list
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
    deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
    deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
    deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
    deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
    deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
    deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
    EOF

    ## 更新源执行三次避免失败
    for((i=1;i<4;i++)) ; do
        echo "try $i"
        ## 更新软件列表源
        apt update ; apt-get -y install locales
    done

    ## 使用locale-gen命令生成中文本地支持
    sed -i 's;## zh_CN.UTF-8 UTF-8;zh_CN.UTF-8 UTF-8;g' /etc/locale.gen
    locale-gen zh_CN ; locale-gen zh_CN.UTF-8

    ## 写入环境变量
    cat << EOF >> /root/.bashrc
    export LANG=zh_CN.UTF-8
    export LC_ALL=zh_CN.UTF-8
    export LANGUAGE=zh_CN.UTF-8
    EOF

    cat << EOF >> /root/.profile
    export LANG=zh_CN.UTF-8
    export LC_ALL=zh_CN.UTF-8
    export LANGUAGE=zh_CN.UTF-8
    EOF

    source /root/.bashrc /root/.profile

    locale ; locale -a

    ## 持久化
    update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8

    ## 看看当前启用的本地支持
    cat /etc/default/locale
    
    # 安装
    dpkg -i /root/*.deb
    
    ## 执行三次避免失败
    for((i=1;i<4;i++)) ; do
        echo "try $i"
        apt-get -y install -f
        ## 安装虚拟监视器、x11vnc、中文字体、本地字符集管理、novnc 和 依赖包
        apt-get -y install xvfb x11vnc fonts-noto-cjk  novnc net-tools libgbm-dev libasound2
    done

    ##  novnc 软连接
    ln -sv /usr/share/novnc/utils/launch.sh /usr/bin/novnc
    ## 证书百年
    ## openssl req -x509 -nodes -newkey rsa:3072 -keyout novnc.pem -out /config/novnc.pem -days 36500

    ## 清理
    apt-get -y autoremove ; apt-get -y autopurge ; apt-get clean ; rm -rfv  /var/lib/apt/lists/* /root/*.deb

    ## 解除环境变量
    unset NOVNC_PORT
    unset VNC_PORT
    unset VNC_PASSWORD

    ## 还原源
    mv -v /etc/apt/sources.list.bak /etc/apt/sources.list

    ## 清除记录
    history -c ; echo '' > /root/.bash_history

    ## 以上如果作为构建流程那已经走完

    # 最后构建镜像的时候把以下启动的过程写到一个脚本里面并在构建镜像的时候使用 CMD 指令执行脚本
    echo -e '判断前\nnovnc 端口：'${NOVNC_PORT}'\nvnc 端口：'${VNC_PORT}'\n密码：'${VNC_PASSWORD}

    # 判断密码环境
    # rm -rfv /config/passwd

    if [ "${VNC_PASSWORD}x" = "x" ]
    then
        export VNC_PASSWORD=123456
    fi

    # 判断 VNC 端口环境
    if [ "${VNC_PORT}x" = "x" ]
    then
        export VNC_PORT=5902
    fi

    # 判断 NOVNC 端口环境
    if [ "${NOVNC_PORT}x" = "x" ]
    then
        export NOVNC_PORT=36080
    fi

    echo -e '经过判断后\nnovnc 端口：'${NOVNC_PORT}'\nvnc 端口：'${VNC_PORT}'\n密码：'${VNC_PASSWORD}

    # 创建虚拟监视器 DISPLAY=:0
    Xvfb :0  &

    # 写入密码
    # x11vnc -storepasswd ${VNC_PASSWORD} /config/passwd
    export DISPLAY=:0
    
    # x11vnc 启动
    x11vnc -wait 50 -noxdamage -rfbport ${VNC_PORT} -passwd ${VNC_PASSWORD} -display :0 -forever -o /tmp/startapp.log -bg

    # novnc 启动证书不好使？
    # nohup novnc --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} --cert novnc.pem > /tmp/startapp.log 2>&1 &
    websockify -D --log-file=/tmp/startapp.log --web=/usr/share/novnc/ ${NOVNC_PORT} localhost:${VNC_PORT}

    # 启动x终端执行
    nohup x-terminal-emulator -display :0 -e '/opt/baidunetdisk/baidunetdisk --no-sandbox' > /tmp/startapp.log 2>&1 &

    ##  干掉所有进程 
    ## procps
    ## rm -rfv /tmp/.X0-lock
    ## killall -v websockify x11vnc baidunetdisk xterm Xvfb
## 访问测试 ok
    http://主机IP:36080/vnc.html

## 清理测试容器，最后按照这个流程原封不动的编写构建文件构建镜像即可
    docker stop 'debian-baidunetdisk-latest-container' ; docker rm -f 'debian-baidunetdisk-latest-container'


## 感谢
2moe 大佬的 tmoe 项目脚本作为参考，经过反复的实践和分析，我终于找到了简单的部署步骤  
感谢 Arch Linux 百度网盘开发者提供的 arm64 版本安装包，虽然最新版本已经没了，好在官方提供了旧的版本包  
感谢 Debian Linux 的依赖包  

## 参考
tmoe：https://github.com/2moe/tmoe  
百度网盘 arm64 安装包：http://wppkg.baidupcs.com/issue/netdisk/Linuxguanjia/4.10.5/baidunetdisk_4.10.5_arm64.deb  
arm64 百度网盘依赖包 libindicator3-7 ：https://packages.debian.org/buster/libindicator3-7  
arm64 百度网盘依赖包 libappindicator3-1 ：https://packages.debian.org/buster/libappindicator3-1  
Diagnosing "cannot open display" type issues with WSLg：https://github.com/microsoft/wslg/wiki/Diagnosing-%22cannot-open-display%22-type-issues-with-WSLg  
百度官网更新日志：https://pan.baidu.com/disk/version  
如何编写优雅的Dockerfile：https://zhuanlan.zhihu.com/p/79949030  
Compose specification：https://docs.docker.com/compose/compose-file/  
docker run：https://docs.docker.com/engine/reference/commandline/run/  
if command in linux with examples：https://www.geeksforgeeks.org/if-command-in-linux-with-examples/  
Password problem x11vnc：https://unix.stackexchange.com/questions/405185/password-problem-x11vnc#405324  
Docker、ShutIt and The Perfect 2048 Game：https://zwischenzugs.com/2014/05/09/docker-shutit-and-the-perfect-2048-game/  
ps command does not work in docker container：https://stackoverflow.com/questions/26982274/ps-command-doesnt-work-in-docker-container  
Automation framework for programmers：https://ianmiell.github.io/shutit/  
Running a GUI application in a Docker container：https://linuxmeerkat.wordpress.com/2014/10/17/running-a-gui-application-in-a-docker-container/  
X11vnc：https://wiki.archlinux.org/title/X11vnc#Installation  

