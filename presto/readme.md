bigdata/presto:0.206
====

Base bigdata/hive:3.0.0

Applications: presto-0.206

User default: root

### 1. Presto config files

Presto config files :

    export FILE_NAME_PRESTO__CONF=${PRESTO_HOME}/etc/config.properties
    export FILE_NAME_PRESTO__JVM=${PRESTO_HOME}/etc/jvm.config
    export FILE_NAME_PRESTO__NODE=${PRESTO_HOME}/etc/node.properties
    export FILE_NAME_PRESTO__HIVE=${PRESTO_HOME}/etc/catalog/hive.properties

for docker-compose:

    presto:
      image: bigdata/presto:0.206
      hostname: presto
      container_name: presto
      domainname: hadoop
      net: hadoop
      environment:
        - PRESTO_CONF_coordinator=true
        - PRESTO_CONF_node___scheduler_include___coordinator=true
        - PRESTO_CONF_http___server_http_port=8080
        - PRESTO_CONF_query_max___memory=5GB
        - PRESTO_CONF_query_max___memory___per___node=1GB
        - PRESTO_CONF_discovery___server_enabled=true
        - PRESTO_CONF_discovery_uri=http://presto:8080
        - PRESTO_JVM_ESC_jvm0=-server
        - PRESTO_JVM_ESC_jvm1=-Xmx16G
        - PRESTO_JVM_ESC_jvm2=-XX:+UseG1GC
        - PRESTO_JVM_ESC_jvm3=-XX:G1HeapRegionSize=32M
        - PRESTO_JVM_ESC_jvm4=-XX:+UseGCOverheadLimit
        - PRESTO_JVM_ESC_jvm5=-XX:+ExplicitGCInvokesConcurrent
        - PRESTO_JVM_ESC_jvm6=-XX:+HeapDumpOnOutOfMemoryError
        - PRESTO_JVM_ESC_jvm7=-XX:OnOutOfMemoryError=kill -9 %p
        - PRESTO_NODE_node_environment=development
        - PRESTO_NODE_node_id=presto-coordinator
        - PRESTO_NODE_node_data___dir=/opt/presto/data
        - PRESTO_HIVE_connector_name=hive-hadoop2
        - PRESTO_HIVE_hive_metastore_uri=thrift://hive:9083
        - PRESTO_HIVE_hive_allow___drop___table=true
        - PRESTO_HIVE_hive_config_resources=/etc/hadoop/core-site.xml,/etc/hadoop/hdfs-site.xml
        - CORE_CONF_fs_defaultFS=hdfs://namenode:8020
        - CORE_CONF_hadoop_http_staticuser_user=root
        - CORE_CONF_hadoop_proxyuser_hue_hosts=*
        - CORE_CONF_hadoop_proxyuser_hue_groups=*
        - HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check=false
        - STARTUP_SCRIPT=sleep 15,,,source /hadoop-entrypoint.sh $$@,,,source /hive-entrypoint.sh $$@,,,source /presto-entrypoint.sh $$@,,,source /write-config.sh $$@,,,source /presto.sh,,,
      ports:
        - "8080:8080"

### 2. Presto usage

    docker-compose up -d

    docker exec -it presto bash
    
    ./presto-cli-0.206-executable.jar --server localhost:8080 --catalog hive --schema default
    
    CREATE SCHEMA test WITH (location = 'hdfs://namenode:8020/usr/hive/warehouse');
    use test;
    CREATE TABLE pokes (foo bigint, bar varchar(256));
    insert into pokes values(1, 'test');
    select * from pokes;




    











