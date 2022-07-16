FROM debian:11

ADD package /root/

RUN bash /root/install.sh ; rm -rfv /root/install.sh

CMD nohup bash /root/startapp.sh > /tmp/startapp.log 2>&1 & tail -f -n 200 /tmp/startapp.log 
