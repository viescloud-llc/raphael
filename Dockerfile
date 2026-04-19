# Build stage
FROM maven:3.9-eclipse-temurin-19 AS build
WORKDIR /build

# Copy project files
COPY . .

# Change spring profile from local to prod
RUN sed -i 's/spring.profiles.active: local/spring.profiles.active: prod/g' src/main/resources/application.yml

# Build the application
RUN mvn clean install -DskipTests

# Rename the built jar to a consistent name for easier copying
RUN mv /build/target/*.jar /build/target/app.jar

# Runtime stage
FROM eclipse-temurin:21-jdk-jammy
WORKDIR /app

EXPOSE 8080
EXPOSE 81
EXPOSE 82
EXPOSE 83

# Copy the built jar from build stage
COPY --from=build /build/target/app.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]