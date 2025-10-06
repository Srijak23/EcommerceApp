# Use Tomcat with Java 17
FROM tomcat:9.0.96-jdk17-slim

# Remove default webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Set working directory
WORKDIR /app

# Copy Maven project files
COPY EcommerceApp/pom.xml .
COPY EcommerceApp/src ./src

# Install Maven (to build inside container)
RUN apt-get update && apt-get install -y maven && rm -rf /var/lib/apt/lists/*

# Build the WAR
RUN mvn clean package -DskipTests

# Copy WAR to Tomcat webapps
RUN cp target/EcommerceApp.war /usr/local/tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
