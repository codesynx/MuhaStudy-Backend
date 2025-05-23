FROM maven:3.8.5-openjdk-17 AS build

# Set working directory
WORKDIR /app

# Copy the project files
COPY pom.xml .
COPY src ./src
COPY .mvn ./.mvn
COPY mvnw .
COPY mvnw.cmd .
COPY system.properties .

# Build the application
RUN mvn clean package -DskipTests

# Second stage: run the application
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Environment variable for the port
ENV PORT=8080

# Expose the port
EXPOSE ${PORT}

# Run the application
CMD ["java", "-jar", "app.jar"] 