FROM openjdk:18-jdk-alpine
RUN mkdir app
COPY <filename>.jar /app/app.jar
EXPOSE 6039
EXPOSE 27017
ENTRYPOINT ["java","-jar","/app/app.jar"] 