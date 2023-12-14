FROM gradle:7.6-jdk17-alpine as builder
#FROM amazoncorretto:17 as builder
ENV APP_HOME=/cicd-be
WORKDIR $APP_HOME
COPY build.gradle settings.gradle gradlew $APP_HOME
COPY gradle $APP_HOME/gradle
COPY src $APP_HOME/src
#RUN ./gradlew dependencies
# Gradle 실행 파일 실행 권한 부여
RUN chmod +x ./gradlew
# Gradle clean bootJar 명령 실행
#RUN ./gradlew clean bootJar
RUN ./gradlew clean build
# Stage 2: 애플리케이션 빌드 및 실행
FROM amazoncorretto:17
COPY --from=builder /cicd-be/build/libs/cidemo-0.0.1-SNAPSHOT.jar ./app.jar
# 포트 노출
EXPOSE 8080
# 명령 실행
#CMD ["java", "-jar", "app.jar"]
ENTRYPOINT ["java", "-jar", "app.jar"]

