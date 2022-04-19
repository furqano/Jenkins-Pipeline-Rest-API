FROM openjdk:18-jdk-alpine
RUN mkdir app
COPY *.jar /app/app.jar
EXPOSE 3065
EXPOSE 27017
ENTRYPOINT ["java","-jar","/app/app.jar"] 
