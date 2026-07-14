FROM maven:3.9.16 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package && \
    mv target/shipping-1.0.jar shipping.jar 

# Java is portable not OS dependent, application built in windows can run in Linux
FROM eclipse-temurin:17-jre-alpine
EXPOSE 8080
WORKDIR /app
RUN addgroup -S flipkart && adduser -S -G flipkart flipkart && \
    chown -R flipkart:flipkart /app
COPY --from=builder /app/shipping.jar .
USER flipkart
CMD ["java", "-jar", "shipping.jar"]




# FROM maven:3.9.16
# WORKDIR /app
# COPY pom.xml .
# COPY src ./src
# RUN mvn clean package 
# RUN mv target/shipping-1.0.jar shipping.jar 
# EXPOSE 8080
# CMD ["java", "-jar", "shipping.jar"]