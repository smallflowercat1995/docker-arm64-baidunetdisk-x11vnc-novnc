#!/usr/bin/env bash
mkdir_update_install(){
# 改时区
date '+%Y-%m-%d %H:%M:%S'
cp -rv /etc/localtime /etc/localtime.bak.`date '+%Y-%m-%d_%H-%M-%S'`
rm -rfv /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
date '+%Y-%m-%d %H:%M:%S'

# 
for((i=1;i<4;i++)) ; do
        echo "try $i"
        # 更新软件列表源
        apt update
        # 防止遇到无法拉取 https 源的情况，先使用 http 源并安装
        apt-get -y install apt-transport-https ca-certificates apt-utils
done

# 备份源
cp -rv /etc/apt/sources.list /etc/apt/sources.list.bak

# 写入清华源
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

# 更新源执行三次避免失败
for((i=1;i<4;i++)) ; do
    echo "try $i"
    # 更新软件列表源
    apt update ; apt-get -y install locales
done

# 使用locale-gen命令生成中文本地支持
sed -i 's;# zh_CN.UTF-8 UTF-8;zh_CN.UTF-8 UTF-8;g' /etc/locale.gen
locale-gen zh_CN ; locale-gen zh_CN.UTF-8

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
# 执行三次避免失败
for((i=1;i<4;i++)) ; do
    echo "try $i"
    # 安装虚拟监视器、x11vnc、中文字体、本地字符集管理和 novnc 
    apt-get -y install xvfb x11vnc fonts-noto-cjk novnc net-tools

    # 安装并解决依赖问题
    apt-get -y install libgbm-dev libasound2 ; dpkg -i /root/*.deb ; apt-get -y install -f
done

#  novnc 软连接
ln -sv /usr/share/novnc/utils/launch.sh /usr/bin/novnc

# 证书百年
# openssl req -x509 -nodes -newkey rsa:3072 -keyout novnc.pem -out /config/novnc.pem -days 36500
}

clean_remove(){
# 清理
apt-get -y autoremove ; apt-get -y autopurge ; apt-get clean ; rm -rfv  /var/lib/apt/lists/* /root/*.deb

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
