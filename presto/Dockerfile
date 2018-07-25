FROM bigdata/hive:3.0.0

MAINTAINER Tyler Chen <iffiff1@gmail.com>

ENV PRESTO_VERSION 0.206
ENV PRESTO_URL http://maven.aliyun.com/nexus/content/groups/public/com/facebook/presto/presto-server/$PRESTO_VERSION/presto-server-$PRESTO_VERSION.tar.gz
ENV PRESTO_JDBC_CLI https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.206/presto-cli-0.206-executable.jar
ENV PRESTO_HOME ${USER_HOME}/presto

COPY presto-entrypoint.sh presto.sh /

RUN set -x \
    ### Install presto ###
    && curl -fSL "${PRESTO_URL}" -o /tmp/presto.tar.gz \
    && tar -xvf /tmp/presto.tar.gz -C /opt \
    && mv /opt/*presto* ${PRESTO_HOME} \
    && rm -rf /tmp/presto.tar.gz \
    ### Install presto cli ###
    && curl -fSL "${PRESTO_JDBC_CLI}" -o ${PRESTO_HOME}/presto-cli-0.206-executable.jar \
    && chmod a+x ${PRESTO_HOME}/presto-cli-0.206-executable.jar \
    ### Create data dir ###
    && mkdir -p ${PRESTO_HOME}/data \
    && mkdir -p ${PRESTO_HOME}/etc/catalog \
    ### Add exec auth ###
    && chmod a+x /*.sh

ENV PATH ${PRESTO_HOME}/bin/:$PATH

WORKDIR ${PRESTO_HOME}
