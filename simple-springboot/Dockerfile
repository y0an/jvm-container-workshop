FROM maven:3.5-jdk-8-alpine as build
COPY . /build/
WORKDIR /build
RUN mvn package

FROM openjdk:8-jre
WORKDIR /app
COPY --from=build /build/target/*.jar /app/app.jar
EXPOSE 8080
ENTRYPOINT ["java"]
CMD ["-jar", "app.jar"]