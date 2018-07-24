FROM bigdata/hadoop:2.8.4

MAINTAINER Tyler Chen <iffiff1@gmail.com>

ENV HIVE_VERSION 3.0.0
ENV HIVE_URL http://mirrors.shu.edu.cn/apache/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
ENV HIVE_HOME ${USER_HOME}/hive
ENV HIVE_JDBC_MYSQL http://maven.aliyun.com/nexus/content/groups/public/mysql/mysql-connector-java/8.0.11/mysql-connector-java-8.0.11.jar

RUN set -x \
    && curl -fSL "${HIVE_URL}" -o /tmp/hive.tar.gz \
    && tar -xvf /tmp/hive.tar.gz -C /opt \
    && mv /opt/*hive* ${HIVE_HOME} \
    && rm -rf /tmp/hive.tar.gz \
    && curl -fSL "${HIVE_JDBC_MYSQL}" -o ${HIVE_HOME}/lib/mysql-connector-java-8.0.11.jar

RUN set -x \
    && cp ${HIVE_HOME}/conf/beeline-log4j2.properties.template ${HIVE_HOME}/conf/beeline-log4j2.properties \
    && cp ${HIVE_HOME}/conf/hive-env.sh.template ${HIVE_HOME}/conf/hive-env.sh \
    && cp ${HIVE_HOME}/conf/hive-exec-log4j2.properties.template ${HIVE_HOME}/conf/hive-exec-log4j2.properties \
    && cp ${HIVE_HOME}/conf/hive-log4j2.properties.template ${HIVE_HOME}/conf/hive-log4j2.properties \
    && cp ${HIVE_HOME}/conf/llap-daemon-log4j2.properties.template ${HIVE_HOME}/conf/llap-daemon-log4j2.properties \
    && echo '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' >> ${HIVE_HOME}/conf/hive-site.xml \
    && echo '<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>' >> ${HIVE_HOME}/conf/hive-site.xml \
    && echo '<configuration>' >> ${HIVE_HOME}/conf/hive-site.xml \
    && echo '</configuration>' >> ${HIVE_HOME}/conf/hive-site.xml \
    && chmod a+x ${HIVE_HOME}/conf/hive-env.sh

ENV PATH ${HIVE_HOME}/bin/:$PATH

WORKDIR ${HIVE_HOME}

ADD hive-entrypoint.sh /hive-entrypoint.sh
ADD hive.sh /hive.sh
ADD hive-meta.sh /hive-meta.sh
RUN chmod a+x /*.sh

