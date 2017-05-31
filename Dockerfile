FROM centos:7

# Define Apache Qpid version 
ENV QPID_WORK /var/qpidwork
ENV QPID_VERSION 6.1.2
ENV QPID_USER qpid
ENV QPID_SHA512 48394b7edd4e7f855fc1ed9ddd0b83d4c13d51c02c727c72704e32ed76592a5ffae612701080da0522b7e77b8ff0017cc4cdfd2b4effee0e994e234c435509c7

USER root

WORKDIR /opt

# Install Java
RUN yum clean all && yum -y install java-1.7.0-openjdk-devel && yum clean all
RUN adduser $QPID_USER
 
# Extract the Apache Qpid to Opt
RUN mkdir $QPID_WORK
RUN curl -O http://www-us.apache.org/dist/qpid/java/$QPID_VERSION/binaries/qpid-broker-$QPID_VERSION-bin.tar.gz
RUN sha512sum  qpid-broker-$QPID_VERSION-bin.tar.gz | grep $QPID_SHA512
RUN tar zxvf qpid-broker-$QPID_VERSION-bin.tar.gz
RUN chown -R $QPID_USER:$QPID_USER /opt/qpid-broker-$QPID_VERSION-bin.tar.gz 
RUN chown -R $QPID_USER:$QPID_USER $QPID_WORK
# Open Web Mangement, JMS ports
EXPOSE 8181 5672

USER $QPID_USER

CMD [ "/opt/qpid-broker/6.1.2/bin/qpid-server", "-prop", "qpid.http_port=8181" ]
