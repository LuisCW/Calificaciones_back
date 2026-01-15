# Build stage
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn -DskipTests clean package

# Runtime stage
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
COPY cli_menu.py /app/cli_menu.py
RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*
EXPOSE 8081
ENV SERVER_PORT=8081
ENTRYPOINT ["java","-jar","app.jar"]
