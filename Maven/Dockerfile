FROM maven:3-adoptopenjdk-8 as mvn_build

COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM tomcat:8.0
COPY --from=mvn_build /home/app/target/*.jar /usr/local/tomcat/webapps
