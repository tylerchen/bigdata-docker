#!/bin/bash

### env name starts with ESC will be just set the value
ESCAPE_PREFIX="ESC"
### xml file will set the name and value property
XML_SUBFIX=".xml"

declare -A fileMap=()

function argsToMap() {
  echo "===argsToMap==="
  local envPrefix='FILE_NAME'
  local var
  local value
  for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
    name=`echo ${c} | perl -pe 's/___/-/g; s/__/=/g; s/_/./g; s/=/_/g'`
    var="${envPrefix}_${c}"
    value=${!var}
    fileMap["$name"]="$value"
    echo "file name: $value, key: $name"
  done
}

function addProperty() {
  local type=$1
  local path=$2
  local name=$3
  local value=$4

  local entry="<property><name>$name</name><value>${value}</value></property>"
  if [ "$type" == "XML" ]; then
    local escapedEntry=$(echo $entry | sed 's/\//\\\//g')
    sed -i "/<\/configuration>/ s/.*/${escapedEntry}\n&/" $path
  fi
  if [ "$type" == "PROP" ]; then
    entry="${name}=${value}"
    if [[ $name == $ESCAPE_PREFIX* ]]; then
      entry="${value}"
    fi
    echo ${entry} >> $path
  fi
}

function configure() {
  local path
  local envPrefix
  local var
  local value
    
  for key in ${!fileMap[@]}; do
    envPrefix=$key
    path=${fileMap[$key]}
    echo "Configuring $path, envPrefix: $envPrefix"
    for c in `printenv | perl -sne 'print "$1 " if m/^${envPrefix}_(.+?)=.*/' -- -envPrefix=$envPrefix`; do
      name=`echo ${c} | perl -pe 's/___/-/g; s/__/=/g; s/_/./g; s/=/_/g'`
      var="${envPrefix}_${c}"
      value=${!var}
      echo " - Setting $name=$value"
      if [[ $path == *$XML_SUBFIX ]]; then
        addProperty XML $path $name "$value"
      else
        addProperty PROP $path $name "$value"
      fi
    done
    #echo "======= $path ======="
    #cat $path
  done
}

function configureHostResolver() {
    sed -i "/hosts:/ s/.*/hosts: $*/" /etc/nsswitch.conf
}

case $HOST_RESOLVER in
    "")
        echo "No host resolver specified. Using distro default. (Specify HOST_RESOLVER to change)"
        ;;
    
    files_only)
        echo "Configure host resolver to only use files"
        configureHostResolver files
        ;;

    dns_only)
        echo "Configure host resolver to only use dns"
        configureHostResolver dns
        ;;

    dns_files)
        echo "Configure host resolver to use in order dns, files"
        configureHostResolver dns files
        ;;

    files_dns)
        echo "Configure host resolver to use in order files, dns"
        configureHostResolver files dns
        ;;

    *)
        echo "Unrecognised network resolver configuration [${HOST_RESOLVER}]: allowed values are files_only, dns_only, dns_files, files_dns. Ignoring..."
        ;;        
esac

if [ -e '~/.writeconfig' ]; then
  echo 'config has wrote!'
else
  argsToMap
  configure
  echo 'OK' > ~/.writeconfig
fi

