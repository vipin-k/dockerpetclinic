FROM tomcat:8.0
MAINTAINER Vipin Kumar
COPY **/target/petclinic.war /usr/local/tomcat/webapps/
