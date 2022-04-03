FROM maven:3.8.4-jdk-11
WORKDIR /opt
COPY pom.xml /opt/
COPY src /opt/src/
COPY lib /opt/lib/
RUN mvn package -DskipTests

FROM openjdk:11.0.14.1-jre
WORKDIR /opt
COPY --from=0 /opt/target/*.jar /opt/app.jar
ENV PATH=$PATH:/usr/local/openjdk-11/bin
EXPOSE 8070
CMD [ "java", "-jar", "./app.jar" ]
