# ----------- Stage 1: Maven + JDK 21 -----------
FROM eclipse-temurin:21 AS builder

WORKDIR /app

# Install Maven manually (to avoid old versions)
RUN apt-get update && \
    apt-get install -y curl unzip && \
    curl -fsSL https://downloads.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip -o maven.zip && \
    unzip maven.zip && mv apache-maven-3.9.6 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME=/opt/maven
ENV PATH="$MAVEN_HOME/bin:$PATH"

# Copy files
COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline -B

COPY src ./src

# 🔥 This will now compile with Java 21 + Maven 3.9
RUN ./mvnw clean package -DskipTests

# ----------- Stage 2: Runtime Image -----------
FROM eclipse-temurin:21-jre

WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
