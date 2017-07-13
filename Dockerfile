FROM centos

#Install wget
RUN yum -y update && yum install -y wget expect

RUN mkdir /usr/local/src/axigen
WORKDIR /usr/local/src/axigen

RUN wget https://www.axigen.com/usr/files/axigen-10.1.0/axigen-10.1.0.x86_64.rpm.run;\
chmod +x axigen-10.1.0.x86_64.rpm.run;

#Run the installer
COPY ./install-script.exp ./
RUN expect ./install-script.exp;

#Clean up installation files
RUN rm -rf /usr/local/src/axigen

#Set the default password
RUN /opt/axigen/bin/axigen -A password
#Modify the default config to listen on all interfaces
RUN sed -i /var/opt/axigen/run/axigen.cfg -e 's/address = 127.0.0.1/address = 0.0.0.0/'
#Expose the admin port, additional ports should be opened on sub images
EXPOSE 9000

CMD /opt/axigen/bin/axigen --foreground
