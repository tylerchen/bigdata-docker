#!/bin/bash

hdfs dfs -mkdir -p /usr/hive/warehouse
hdfs dfs -mkdir -p /usr/hive/tmp
hdfs dfs -mkdir -p /usr/hive/log
hdfs dfs -chmod g+w /usr/hive/warehouse
hdfs dfs -chmod g+w /usr/hive/tmp
hdfs dfs -chmod g+w /usr/hive/log

cd ${HIVE_HOME}/bin
./hiveserver2 --hiveconf hive.server2.enable.doAs=false

