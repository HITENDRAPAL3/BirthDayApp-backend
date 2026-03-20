# Build stage
FROM eclipse-temurin:17-jdk-alpine AS build
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
# Make the wrapper executable
RUN chmod +x mvnw
# Download dependencies
RUN ./mvnw dependency:go-offline -B
# Copy source
COPY src ./src
# Build application
RUN ./mvnw package -DskipTests

# Run stage
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
