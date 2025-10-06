# Use Maven + JDK 17 image (includes both build and runtime)
FROM maven:3.9.1-openjdk-17-slim

# Set working directory
WORKDIR /app

# Copy Maven config and source code
COPY pom.xml .
COPY src ./src

# Build the WAR
RUN mvn clean package

# Install Tomcat (inside the same image)
RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.zip && \
    unzip apache-tomcat-9.0.85.zip && \
    mv apache-tomcat-9.0.85 /tomcat && \
    rm apache-tomcat-9.0.85.zip

# Remove default Tomcat apps
RUN rm -rf /tomcat/webapps/*

# Copy WAR file to Tomcat
RUN cp target/EcommerceApp.war /tomcat/webapps/ROOT.war

# Expose Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["/tomcat/bin/catalina.sh", "run"]
