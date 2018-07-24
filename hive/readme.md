bigdata/hive:3.0.0
====

Base bigdata/hadoop:2.8.4

Applications: hive-3.0.0

User default: root

### 1. Hive config files

Hive config files :

    export FILE_NAME_HIVE__CONF=${HIVE_HOME}/conf/hive-site.xml

for docker-compose:

    hive:
      image: bigdata/hive:3.0.0
      hostname: hive
      container_name: hive
      domainname: hadoop
      net: hadoop
      environment:
        - HIVE_CONF_javax_jdo_option_ConnectionURL=jdbc:mysql://mysql:3306/metastore_db
        - HIVE_CONF_javax_jdo_option_ConnectionDriverName=com.mysql.jdbc.Driver
        - HIVE_CONF_javax_jdo_option_ConnectionUserName=iff
        - HIVE_CONF_javax_jdo_option_ConnectionPassword=iff
        - HIVE_CONF_hive_metastore_uris=thrift://hive:9083
        - HIVE_CONF_hive_metastore_schema_verification=false
        - HIVE_CONF_hive_metastore_warehouse_dir=hdfs://namenode:8020/usr/hive/warehouse
        - HIVE_CONF_datanucleus_autoCreateSchema=false
        - HIVE_CONF_hive_server2_webui_host=0.0.0.0
        - HIVE_CONF_hive_server2_webui_port=10002
        - CORE_CONF_fs_defaultFS=hdfs://namenode:8020
        - CORE_CONF_hadoop_http_staticuser_user=root
        - CORE_CONF_hadoop_proxyuser_hue_hosts=*
        - CORE_CONF_hadoop_proxyuser_hue_groups=*
        - HDFS_CONF_dfs_namenode_datanode_registration_ip___hostname___check=false
        - STARTUP_SCRIPT=sleep 10,,,source /hadoop-entrypoint.sh $$@,,,source /hive-entrypoint.sh $$@,,,source /write-config.sh $$@,,,source /hive-meta.sh &,,,source /hive.sh,,,
      ports:
        - "9083:9083"
        - "10000:10000"
        - "10002:10002"





    











