bigdata/hadoop:2.8.4
====

Base bigdata/base:centos7

Applications: hadoop-2.8.4

User default: root

### 1. Config file edit rules

#### 1.1 Prefix remove

	FILE_NAME_{CONFIG_PREFIX}  => {CONFIG_PREFIX}
	
	ex: FILE_NAME_CORE__CONF   => CORE_CONF

#### 1.2 Character convert
    
 This will remove prefix first.

	___ => -
	__  => _
	_   => .

	ex: CORE_CONF_fs_defaultFS    =>    fs.defaultFS

#### 1.3 File name mapping

file name mapping starts with *FILE_NAME_* , *{CONFIG_PREFIX}* is this config file prefix, starts with this prefix will write to the file.

	FILE_NAME_{CONFIG_PREFIX}
	ex: export FILE_NAME_CORE__CONF=/etc/hadoop/core-site.xml
	ex: export CORE_CONF_fs_defaultFS=hdfs://localhost:8020
	ex: cat /etc/hadoop/core-site.xml
		<configuration>
			<property><name>fs.defaultFS</name><value>hdfs://localhost:8020</value></property>
		</configuration>

#### 1.4 Property mapping

file name mapping starts with *{CONFIG_PREFIX}* , the CONFIG_PREFIX you defined with file name mapping.

	{CONFIG_PREFIX}_{PROPERTY_NAME}=value

#### 1.5 Xml or Properties or Config file type

if file ends with .xml , will gen xml string, and add to xml file before </configuration> tag:

	<property><name>${name}</name><value>${value}</value></property>

if file is key-value style, such as properties or config file, will gen key=value string and append to file:

    ${name}=${value}

if file is value style, such as jvm.conf, will gen value string and append to file:

    ${value}


### 2. Entrypoint rule

Default entrypoint is *entrypoint.sh* , this file will create script file: */initScript.sh* , the file content read from enviroment *STARTUP_SCRIPT* , commands split by ",,," , "$" use "$$" instead .

*STARTUP_SCRIPT* content format: [1]source all entrypoint, [2]write-config, [3]start script.

    environment:
        - STARTUP_SCRIPT=source /hadoop-entrypoint.sh $$@,,,source /write-config.sh $$@,,,source /namenode.sh $$@,,,

    cat /initScript.sh
        #!/bin/bash
        cat /initScript.sh
        source /hadoop-entrypoint.sh $@
        source /write-config.sh $@
        source /namenode.sh $@


### 3. Hadoop config files

hadoop config files dir :

    /etc/hadoop

hadoop data dir:

    /data/hadoop/dfs/name
    /data/hadoop/dfs/data

for docker-compose:

    volumes:
      - /root/bigdata/data/hadoop/dfs/name:/data/hadoop/dfs/name
      - /root/bigdata/data/hadoop/dfs/data:/data/hadoop/dfs/data

if you mount with */data* dir, you have to create dirs in local file system first:

    mkdir -p /root/bigdata/data/hadoop/dfs/name
    mkdir -p /root/bigdata/data/hadoop/dfs/data

    volumes:
      - /root/bigdata/data:/data

    











