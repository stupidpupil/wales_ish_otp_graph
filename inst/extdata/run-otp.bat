@echo off

if exist "C:\Progra~1\AdoptOpenJDK\jdk-11.0.11.9-hotspot\release" (
  set JAVA_HOME "C:\Progra~1\AdoptOpenJDK\jdk-11.0.11.9-hotspot"
)

PATH %PATH%;%JAVA_HOME%\bin\

WHERE /q java
if %ERRORLEVEL% NEQ 0 (
  echo It looks like you need to install Java.
  echo Try installing OpenJDK 11 from https://adoptium.net/?variant=openjdk11 !
  pause
  exit
)

for /f tokens^=2-5^ delims^=.-_^" %%j in ('java -fullversion 2^>^&1') do set "JAVA_MAJOR_VERSION=%%j%%k%%l%%m"

if %JAVA_MAJOR_VERSION% LSS 11 (
  echo It looks like you need a newer version of Java.
  echo Try installing OpenJDK 11 from https://adoptopenjdk.net/ !
  pause
  exit
)

java --add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED  -Xmx8g -jar otp.jar --load graph

if %ERRORLEVEL% NEQ 0 (
  pause
  exit
)
