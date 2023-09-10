#!/usr/bin/env bash
rm -rfv /tmp/.X0-lock
killall websockify x11vnc Xvfb tail
# 创建虚拟监视器 DISPLAY=:0
Xvfb :0 &

# 最后构建镜像的时候把以下启动的过程写到一个脚本里面并在构建镜像的时候使用 CMD 指令执行脚本
echo -e '判断前\nnovnc 端口：'${NOVNC_PORT}'\nvnc 端口：'${VNC_PORT}'\n密码：'${VNC_PASSWORD}

export DISPLAY=:0
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

# 最后构建镜像的时候把以下启动的过程写到一个脚本里面并在构建镜像的时候使用 CMD 指令执行脚本
echo -e '经过判断后\nnovnc 端口：'${NOVNC_PORT}'\nvnc 端口：'${VNC_PORT}'\n密码：'${VNC_PASSWORD}

# 写入密码
# x11vnc -storepasswd ${VNC_PASSWORD} /config/passwd

# x11vnc 启动
x11vnc -wait 50 -noxdamage -rfbport ${VNC_PORT} -passwd ${VNC_PASSWORD} -display :0 -forever -o /tmp/startapp.log -bg

# novnc 启动证书不好使？
# nohup novnc --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} --cert novnc.pem > /tmp/startapp.log 2>&1 &
websockify -D --log-file=/tmp/startapp.log --web=/usr/share/novnc/ ${NOVNC_PORT} localhost:${VNC_PORT}

# 启动x终端执行
nohup x-terminal-emulator -display :0 -e '/opt/baidunetdisk/baidunetdisk --no-sandbox' > /tmp/startapp.log 2>&1 &

tail -f -n 200 /tmp/startapp.log
