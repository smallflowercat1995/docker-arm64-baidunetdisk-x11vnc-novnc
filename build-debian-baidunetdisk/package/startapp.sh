#!/usr/bin/env bash
# 最后构建镜像的时候把以下启动的过程写到一个脚本里面并在构建镜像的时候使用 CMD 指令执行脚本
echo -e 'novnc 端口：'${NOVNC_PORT}'\nvnc 端口：'${VNC_PORT}'\n密码：'${VNC_PASSWORD}
# 判断密码环境
rm -rfv /config/passwd
if [ "${VNC_PASSWORD}x"!="x" ]
then
    # 写入密码
    
    x11vnc -storepasswd ${VNC_PASSWORD} /config/passwd
else
    export VNC_PASSWORD=123456
    # 写入密码
    x11vnc -storepasswd ${VNC_PASSWORD} /config/passwd
fi

# 创建虚拟监视器 DISPLAY=:0
nohup Xvfb :0 > /tmp/xvfb.log 2>&1 &

# 判断 VNC 端口环境
if [ "${VNC_PORT}x"!="x" ]
then
    # x11vnc 启动
    nohup x11vnc -display :0 -rfbport ${VNC_PORT} -rfbauth /config/passwd > /tmp/x11vnc.log 2>&1 &
else
    # x11vnc 启动
    eport VNC_PORT=5902
    nohup x11vnc -display :0 -rfbport ${VNC_PORT} -rfbauth /config/passwd > /tmp/x11vnc.log 2>&1 &
fi

# 判断 NOVNC 端口环境
if [ "${NOVNC_PORT}x"!="x" ]
then
    # novnc 启动 启动证书不好使？
    # nohup novnc --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} --cert novnc.pem > /tmp/novnc.log 2>&1 &
    nohup novnc --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} > /tmp/novnc.log 2>&1 &
else
    eport NOVNC_PORT=36080
    # novnc 启动证书不好使？
    # nohup novnc --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} --cert novnc.pem > /tmp/novnc.log 2>&1 &
    nohup novnc --listen ${NOVNC_PORT} --vnc localhost:${VNC_PORT} > /tmp/novnc.log 2>&1 &
fi

# 启动x终端执行
nohup x-terminal-emulator -display :0 -e '/opt/baidunetdisk/baidunetdisk --no-sandbox' > /tmp/x-terminal-emulator.log 2>&1 &
