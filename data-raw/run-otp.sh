#!/bin/sh

if command -v /usr/libexec/java_home 2>&1 /dev/null
then
  echo "Trying to set JAVA_HOME using /usr/libexec/java_home"
  JAVA_HOME="$(/usr/libexec/java_home -v 11)"
  export JAVA_HOME
fi

java --add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED -Xmx8g -jar otp.jar --load graph
