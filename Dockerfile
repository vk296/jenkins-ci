FROM amazonlinux
MAINTAINER VK
WORKDIR /opt
ADD https://dlcdn.apache.org/tomcat/tomcat-8/v8.5.78/bin/apache-tomcat-8.5.78.zip /opt/
RUN yum install unzip -y
RUN yum install vim -y
RUN unzip /opt/apache-tomcat-8.5.78.zip
RUN chmod +x /opt/apache-tomcat-8.5.78/bin/*
RUN amazon-linux-extras install java-openjdk11 -y
COPY app/target/dptweb-1.0.war /opt/apache-tomcat-8.5.78/webapps/
CMD ["/opt/apache-tomcat-8.5.76/bin/catalina.sh", "run"]