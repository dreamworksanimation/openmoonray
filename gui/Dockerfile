FROM openmoonray/moonray
# docker build --format docker --tag openmoonray/moonray .
# docker build --tag openmoonray/moonray-gui .
# docker run -it --rm --publish 8080:8080 openmoonray/moonray-gui

RUN yum install -y tigervnc-server epel-release go
RUN yum groupinstall -y xfce

RUN go install github.com/geek1011/easy-novnc@v1.1.0

RUN mkdir -p /root/.vnc
RUN echo moonray | vncpasswd -f > /root/.vnc/passwd
run chmod 0600 /root/.vnc/passwd

COPY --chmod=755 xstartup /root/.vnc/
COPY config /root/.vnc/
run touch .Xauthority

COPY --chmod=755 run-vncserver /root/run-vncserver

# expose the noVNC port, run forever
EXPOSE 8080
ENTRYPOINT ["/root/run-vncserver"]
