# Getting Started

네트워크 모니터링을 위한 Getting Started 패키지를 통해 기본 구성을 해봅니다. 

<br>

## 1. All in One 구성도

<img src=https://github.com/chupark/Monitoring/blob/master/Images/gettingStarted/01_drawing.png />

<br>

## 2. 요구사항
1. 모니터링 대상 서버 (Slave 서버)
2. 모니터링 담당 서버 (Master 서버)
3. 모든 서버의 Private IP가 같은 주소공간 내 존재
4. PowerShell 실행정책 변경
````
Set-ExecutionPolicy Bypass
````

<br>

## 3. 구성 방법
1. C:\Users\$env:USERNAME\netmon 디렉토리를 만듭니다.
2. 만들어진 netmon 디렉토리에 모든 파일을 복사합니다.
3. 01_makeEnv.ps1 스크립트를 실행합니다.

+ 01_makeEnv.ps1 스크립트를 실행하면 아래와 같이 환경이 차례대로 구성됩니다.
   - PsTools 설치 & 환경변수 설정
   - influxDB Binary 설치
   - NSSM 설치
   - Grafana Binary 설치
   - InfluxDB, Grafana 프로세스 등록 & 시작 <br>
      InfluxDB -> influxdb, Grafana -> grafana
   - InfluxDB에 network database 생성

4. PowerShell 세션을 새로 열어 02_launchNetworkMonitoring.ps1 스크립트를 실행합니다.

<br>

## 4. Grafana 데이터 소스 연결

http://localhost:3000 에 접속하여 로그인을 합니다. <br>
Grafana 최초 로그인 계정 

<table>
   <tr>
      <td>ID</td><td>admin</td>
   </tr>
   <tr>
      <td>PW</td><td>admin</td>
   </tr>
</table>

<img src=https://github.com/chupark/Monitoring/blob/master/Images/gettingStarted/02_influxdb.png />

<br>

## 5. 쿼리 작성

<img src=https://github.com/chupark/Monitoring/blob/master/Images/gettingStarted/03_query.png />

Alias By 절을 아래와 같이 작성합니다.<br>
Host: [[tag_destination_ip]] : [[tag_destination_port]] <br>

<br>

## 6. 기타 설정

데이터의 정보를 더 추가합니다.

<img src=https://github.com/chupark/Monitoring/blob/master/Images/gettingStarted/05_etc.png />

<br>

## 7. 그래프 확인

<img src=https://github.com/chupark/Monitoring/blob/master/Images/gettingStarted/06_graph.png />

<br>
