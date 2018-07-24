#!/bin/bash

cd ${HIVE_HOME}/bin
schematool --dbType mysql -initSchema &
./hive --service metastore

