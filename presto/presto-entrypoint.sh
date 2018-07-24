#!/bin/bash

# Set some sensible defaults
export FILE_NAME_PRESTO__CONF=${PRESTO_HOME}/etc/config.properties
export FILE_NAME_PRESTO__JVM=${PRESTO_HOME}/etc/jvm.config
export FILE_NAME_PRESTO__NODE=${PRESTO_HOME}/etc/node.properties
export FILE_NAME_PRESTO__HIVE=${PRESTO_HOME}/etc/catalog/hive.properties

touch $FILE_NAME_PRESTO__CONF
touch $FILE_NAME_PRESTO__JVM
touch $FILE_NAME_PRESTO__NODE
touch $FILE_NAME_PRESTO__HIVE

