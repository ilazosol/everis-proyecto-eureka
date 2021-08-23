#FROM openjdk:18
#VOLUME /tmp
#EXPOSE 8080
#ADD ./target/springboot-eureka-server-0.0.1-SNAPSHOT.jar eureka-server.jar
#ENTRYPOINT ["java","-jar","/eureka-server.jar"]
FROM maven:3.6.3-openjdk:18 AS build
RUN mkdir -p /workspace
WORKDIR /workspace
COPY pom.xml /workspace
COPY src /workspace/src
RUN mvn -B package --file pom.xml -DskipTests

FROM openjdk:18

RUN adduser --system --group spring
USER spring:spring
EXPOSE 8761
ARG JAR_FILE=/workspace/target/*.jar
COPY --from=build ${JAR_FILE} app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]