#!/bin/sh

if command -v /usr/libexec/java_home 2>&1 /dev/null
then
  echo "Trying to set JAVA_HOME using /usr/libexec/java_home"
  JAVA_HOME="$(/usr/libexec/java_home -v 11)"
  export JAVA_HOME
fi

JAVA_MAJOR_VERSION="$(java -fullversion 2>&1 | head -1 | cut -d'"' -f2 | sed '/^1\./s///' | cut -d'.' -f1)"

if [ "$JAVA_MAJOR_VERSION" -lt 11 ]
then
  echo "It looks like you need a newer version of Java."
  echo "Try installing JDK11 from https://adoptopenjdk.net/ !"
  echo "Press the [Enter] key to continue…"
  read
  exit
fi

java --add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED -Xmx8g -jar otp.jar --load graph

if [ $? -gt 0 ]
then
  echo "Press the [Enter] key to continue…"
  read
  exit
fi
