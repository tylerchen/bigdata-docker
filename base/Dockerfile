FROM centos:7

MAINTAINER Tyler Chen <iffiff1@gmail.com>

ENV CENTOS_VERSION 7
ENV USER_HOME /opt/bigdata

RUN set -x \
    && rm -rf /etc/yum.repos.d/* \
    && curl -fSL "http://mirrors.aliyun.com/repo/Centos-7.repo" -o /etc/yum.repos.d/CentOS-Base.repo \
    && yum clean all \
    && yum makecache \
    && yum install -y epel-release \
    && yum clean all \
    && yum makecache

RUN set -x \
    && yum -y install net-tools which perl xmlstarlet saxon augeas bsdtar unzip java-1.8.0-openjdk-devel

RUN groupadd -r bigdata -g 1000 && useradd -u 1000 -r -g bigdata -m -d ${USER_HOME} -s /sbin/nologin -c "Bigdata user" bigdata \
    && chmod 755 ${USER_HOME}

ENV JAVA_HOME /usr/lib/jvm/java

WORKDIR ${USER_HOME}

