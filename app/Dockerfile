FROM adoptopenjdk/openjdk11-openj9:alpine-slim
LABEL author="Sofus Albertsen"
COPY build/libs/app-*-all.jar app.jar
EXPOSE 8000
CMD java -Dcom.sun.management.jmxremote -noverify ${JAVA_OPTS} -jar app.jar
