FROM bigdata/base:centos7

MAINTAINER Tyler Chen <iffiff1@gmail.com>

ENV HADOOP_VERSION 2.8.4
ENV HADOOP_URL http://mirrors.tuna.tsinghua.edu.cn/apache/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
ENV HADOOP_HOME ${USER_HOME}/hadoop
ENV HADOOP_PREFIX ${HADOOP_HOME}
ENV HADOOP_CONF_DIR /etc/hadoop
ENV MULTIHOMED_NETWORK 1
ENV USER root

ENV HDFS_CONF_dfs_namenode_name_dir file:///data/hadoop/dfs/name
ENV HDFS_CONF_dfs_datanode_data_dir file:///data/hadoop/dfs/data
ENV YARN_CONF_yarn_timeline___service_leveldb___timeline___store_path /data/hadoop/yarn/timeline

COPY entrypoint.sh hadoop-entrypoint.sh  write-config.sh nodemanager.sh resourcemanager.sh namenode.sh datanode.sh historyserver.sh namenode-checkpoint.sh /

RUN set -x \
    ### Install hadoop ###
    && curl -fSL "${HADOOP_URL}" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt \
    && mv /opt/*hadoop* ${HADOOP_HOME} \
    && rm -rf /tmp/hadoop.tar.gz \
    && rm -rf ${HADOOP_HOME}/share/doc \
    ### Setup hadoop config ###
    && ln -s ${HADOOP_HOME}/etc/hadoop ${HADOOP_CONF_DIR} \
    && cp ${HADOOP_CONF_DIR}/mapred-site.xml.template ${HADOOP_CONF_DIR}/mapred-site.xml \
    ### Create data and logs dir ###
    && mkdir -p ${HADOOP_HOME}/logs \
    && mkdir -p /data/hadoop \
    && mkdir -p /data/hadoop/dfs/name \
    && mkdir -p /data/hadoop/dfs/data \
    && mkdir -p /data/hadoop/yarn/timeline \
    && mkdir -p /data/hadoop/dfs/checkpoint \
    ### Add exec auth ###
    && chmod a+x /*.sh

ENV PATH ${HADOOP_PREFIX}/bin/:$PATH

WORKDIR ${HADOOP_HOME}

ENTRYPOINT ["/entrypoint.sh"]
