#!/usr/bin/env bash

REPOSITORY=/home/ubuntu/app
cd $REPOSITORY

echo "> 현재 구동 중인 애플리케이션 pid 확인"

CURRENT_PID=$(pgrep -fla java | grep cidemo | awk '{print $1}')

echo "현재 구동 중인 애플리케이션 pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
  echo "> kill -9 $CURRENT_PID"
  kill -9 $CURRENT_PID

  while pgrep -fla java | grep cidemo > /dev/null; do
      echo "기존 프로세스가 종료될 때까지 대기 중..."
      sleep 3
  done
  echo "기존 프로세스가 종료되었습니다."
fi

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -t $REPOSITORY/build/libs/*-SNAPSHOT.jar | head -n 1)

echo "> JAR NAME: $JAR_NAME"
if [ ! -f "$JAR_NAME" ]; then
  echo "실행할 JAR 파일을 찾을 수 없습니다: $JAR_NAME"
  exit 1
fi

echo "> $JAR_NAME 실행"

#nohup java -jar -Duser.timezone=Asia/Seoul $JAR_NAME >> $REPOSITORY/nohup.out 2>&1 &
nohup java -jar -Duser.timezone=Asia/Seoul $JAR_NAME > /tmp/nohup.out 2>&1 &

echo "배포 스크립트가 성공적으로 완료되었습니다."
tail -n 30 /tmp/nohup.out
