if exist "C:\Progra~1\AdoptOpenJDK\jdk-11.0.11.9-hotspot\release" (
  set JAVA_HOME "C:\Progra~1\AdoptOpenJDK\jdk-11.0.11.9-hotspot"
)

java --add-opens java.base/java.io=ALL-UNNAMED --add-opens java.base/java.util=ALL-UNNAMED  -Xmx8g -jar otp.jar --load graph
