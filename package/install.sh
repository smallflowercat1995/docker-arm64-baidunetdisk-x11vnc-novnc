#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

echo "$DEBIAN_FRONTEND"

mkdir_update_install(){
# 改时区
date '+%Y-%m-%d %H:%M:%S'
cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
rm -rfv /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# for((i=1;i<4;i++)) ; do
#       echo "try $i"
#       # 更新软件列表源
#       apt-get update
#       # 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
#       apt-get -y install apt-transport-https ca-certificates apt-utils
# done

# dpkg -i $HOME/apt-utils_2.2.4_arm64.deb
# dpkg -i $HOME/openssl_1.1.1n-0+deb11u3_arm64.deb
# dpkg -i $HOME/ca-certificates_20210119_all.deb
# dpkg -i $HOME/apt-transport-https_2.2.4_all.deb

# 备份源
# cp -rv /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入清华源
# cat << EOF > /etc/apt/sources.list
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# EOF

# 更新源执行三次避免失败
# for((i=1;i<4;i++)) ; do
#     echo "try $i"
#     # 更新软件列表源
#     apt update ; apt-get -y install locales pv xz-utils
# done

# 备份源
cp -rfv /etc/apt/sources.list{,.backup}
cp -rfv /etc/apt/sources.list.d{,.backup}

# 恢复源
#mkdir -pv /etc/apt/sources.list.d
#cp -fv /usr/share/doc/apt/examples/sources.list /etc/apt/sources.list

# 写入 http 清华源
cat << EOF | tee /etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
deb http://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
deb http://security.debian.org/debian-security bullseye-security main contrib non-free
EOF

# 更新软件列表源
apt update

# 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
apt-get -y install apt-transport-https ca-certificates apt-utils eatmydata aptitude

# 写入 https 清华源
sed -i 's;http;https;g' /etc/apt/sources.list

# 更新软件列表源
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y update

# 安装中文支持和解压工具
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true -y install locales pv xz-utils \
                                                                                 libasound2 xvfb x11vnc \
                                                                                 fonts-noto-cjk novnc net-tools \
                                                                                 procps libgbm-dev xterm
# 使用locale-gen命令生成中文本地支持
sed -i 's;# zh_CN.UTF-8 UTF-8;zh_CN.UTF-8 UTF-8;g;s;en_GB.UTF-8 UTF-8;# en_GB.UTF-8 UTF-8;g' /etc/locale.gen ; locale-gen zh_CN ; locale-gen zh_CN.UTF-8

# 写入环境变量
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

# 持久化
update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 LANGUAGE=zh_CN.UTF-8

# 看看当前启用的本地支持
cat /etc/default/locale
}

install_baidunetdisk(){
# 压缩拆分流程
# tar -PJpcf - baidunetdisk_4.3.0_arm64.deb | (pv -p --timer --rate --bytes > baidunetdisk_4.3.0_arm64.tar.xz)
# split -d -b 47m baidunetdisk_4.3.0_arm64.tar.xz baidunetdisk_4.3.0_arm64.tar.xz.
# rm -rfv baidunetdisk_4.3.0_arm64.deb baidunetdisk_4.3.0_arm64.tar.xz

# 将差分压缩包合并解压
cat $HOME/baidunetdisk_4.3.0_arm64.tar.xz.* > $HOME/baidunetdisk_4.3.0_arm64.tar.xz
pv $HOME/baidunetdisk_4.3.0_arm64.tar.xz | tar -PpJxv -C $HOME/

# 安装依赖
dpkg -i $HOME/libindicator3-7_0.5.0-4_arm64.deb
dpkg -i $HOME/libappindicator3-1_0.4.92-7_arm64.deb
dpkg -i $HOME/baidunetdisk_4.3.0_arm64.deb

# 修复依赖
eatmydata aptitude --without-recommends -o APT::Get::Fix-Missing=true install -fy

#  novnc 软连接
ln -sv /usr/share/novnc/utils/launch.sh /usr/bin/novnc

# 证书百年
# openssl req -x509 -nodes -newkey rsa:3072 -keyout novnc.pem -out /config/novnc.pem -days 36500
}

clean_remove(){
# 清理
apt-get -y autoremove ; apt-get -y autopurge ; apt-get clean ; rm -rfv  /var/lib/apt/lists/* $HOME/*.deb $HOME/install.sh
rm -rfv $HOME/baidunetdisk_4.3.0_arm64.tar.xz*

# 解除环境变量
unset NOVNC_PORT
unset VNC_PORT
unset VNC_PASSWORD

# 还原源
mv -v /etc/apt/sources.list.bak /etc/apt/sources.list

# 清除记录
history -c ; echo '' > /root/.bash_history
}

cd $HOME
mkdir_update_install
install_baidunetdisk
clean_remove
