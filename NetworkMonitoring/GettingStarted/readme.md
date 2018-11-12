# Getting Started

네트워크 모니터링을 위한 Getting Started 패키지를 통해 기본 구성을 해봅니다.

## 1. All in One 구성도
이미지 src

## 2. 요구사항
1. 모니터링 대상 서버 (Slave 서버)
2. 모니터링 담당 서버 (Master 서버)

## 3. 구성 방법
1. C:\Users\$env:USERNAME\netmon 디렉토리를 만듭니다.
2. 만들어진 netmon 디렉토리에 모든 파일을 복사합니다.
3. 01_makeEnv.ps1 스크립트를 실행합니다.
````
01_makeEnv.ps1 스크립트를 실행하면 설정이 아래와 같이 차례대로 구성됩니다.
a. PsTools 설치 & 환경변수 설정
b. influxDB Binary 설치
c. NSSM 설치
d. Grafana Binary 설치
e. InfluxDB, Grafana 프로세스 등록 & 시작 <br>
   InfluxDB -> influxdb, Grafana -> grafana
f. InfluxDB에 network database 생성
````
