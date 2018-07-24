#!/bin/bash

# Set some sensible defaults
export FILE_NAME_CORE__CONF=/etc/hadoop/core-site.xml
export FILE_NAME_HDFS__CONF=/etc/hadoop/hdfs-site.xml
export FILE_NAME_YARN__CONF=/etc/hadoop/yarn-site.xml
export FILE_NAME_HTTPFS__CONF=/etc/hadoop/httpfs-site.xml
export FILE_NAME_KMS__CONF=/etc/hadoop/kms-site.xml
export FILE_NAME_MAPRED__CONF=/etc/hadoop/mapred-site.xml

export CORE_CONF_fs_defaultFS=${CORE_CONF_fs_defaultFS:-hdfs://`hostname -f`:8020}

if [ "$MULTIHOMED_NETWORK" = "1" ]; then
    echo "Configuring for multihomed network"

    # HDFS
    export HDFS_CONF_dfs_namenode_rpc___bind___host=0.0.0.0
    export HDFS_CONF_dfs_namenode_servicerpc___bind___host=0.0.0.0
    export HDFS_CONF_dfs_namenode_http___bind___host=0.0.0.0
    export HDFS_CONF_dfs_namenode_https___bind___host=0.0.0.0
    export HDFS_CONF_dfs_client_use_datanode_hostname=true
    export HDFS_CONF_dfs_datanode_use_datanode_hostname=true

    # YARN
    export YARN_CONF_yarn_resourcemanager_bind___host=0.0.0.0
    export YARN_CONF_yarn_nodemanager_bind___host=0.0.0.0
    export YARN_CONF_yarn_nodemanager_bind___host=0.0.0.0
    export YARN_CONF_yarn_timeline___service_bind___host=0.0.0.0

    # MAPRED
    export MAPRED_CONF_yarn_nodemanager_bind___host=0.0.0.0
fi

if [ -n "$GANGLIA_HOST" ]; then
    mv /etc/hadoop/hadoop-metrics.properties /etc/hadoop/hadoop-metrics.properties.orig
    mv /etc/hadoop/hadoop-metrics2.properties /etc/hadoop/hadoop-metrics2.properties.orig

    for module in mapred jvm rpc ugi; do
        echo "$module.class=org.apache.hadoop.metrics.ganglia.GangliaContext31"
        echo "$module.period=10"
        echo "$module.servers=$GANGLIA_HOST:8649"
    done > /etc/hadoop/hadoop-metrics.properties
    
    for module in namenode datanode resourcemanager nodemanager mrappmaster jobhistoryserver; do
        echo "$module.sink.ganglia.class=org.apache.hadoop.metrics2.sink.ganglia.GangliaSink31"
        echo "$module.sink.ganglia.period=10"
        echo "$module.sink.ganglia.supportsparse=true"
        echo "$module.sink.ganglia.slope=jvm.metrics.gcCount=zero,jvm.metrics.memHeapUsedM=both"
        echo "$module.sink.ganglia.dmax=jvm.metrics.threadsBlocked=70,jvm.metrics.memHeapUsedM=40"
        echo "$module.sink.ganglia.servers=$GANGLIA_HOST:8649"
    done > /etc/hadoop/hadoop-metrics2.properties
fi

if [ -n "$HADOOP_CUSTOM_CONF_DIR" ]; then
    if [ -d "$HADOOP_CUSTOM_CONF_DIR" ]; then
        for f in `ls $HADOOP_CUSTOM_CONF_DIR/`; do
            echo "Applying custom Hadoop configuration file: $f"
            ln -sfn "$HADOOP_CUSTOM_CONF_DIR/$f" "/etc/hadoop/$f"
        done
    else
        echo >&2 "Hadoop custom configuration directory not found or not a directory. Ignoring: $HADOOP_CUSTOM_CONF_DIR"
    fi
fi

