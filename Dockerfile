# Use Maven + JDK 17 image (includes both build and runtime)
FROM maven:3.8.4-openjdk-17-slim

# Set working directory
WORKDIR /app

# Copy Maven config and source code
COPY EcommerceApp/pom.xml .
COPY EcommerceApp/src ./src

# Build the WAR (skip tests for faster build)
RUN mvn clean package -DskipTests

# Install Tomcat (inside the same image)
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.96/bin/apache-tomcat-9.0.96.zip && \
    unzip apache-tomcat-9.0.96.zip && \
    mv apache-tomcat-9.0.96 /tomcat && \
    rm apache-tomcat-9.0.96.zip && \
    rm -rf /var/lib/apt/lists/*

# Remove default Tomcat apps
RUN rm -rf /tomcat/webapps/*

# Copy WAR file to Tomcat
RUN cp target/EcommerceApp.war /tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["/tomcat/bin/catalina.sh", "run"]
