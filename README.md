# OSSIntroProj1
인하대학교 24-1학기 오픈소스 소프트웨어개론 프로젝트1 저장소

이하의 내용은 과제 제출란에 DOCS 파일의 형태로도 제출되어 있습니다. 

# About this repository

 해당 리포지터리는 인하대학교 오픈소스SW개론 24 – 1 중간고사 프로젝트 과제입니다. 
잉글랜드 프리미어 리그(EPL) 18/19 시즌의 선수, 클럽, 경기 정보에 대한 데이터 파일이 3개 주어지며, 제시된 3개의 데이터 파일에서 유저가 필요로 하는 정보를 추출해 출력해줍니다.

# 사용 방법 
## 실행 방법
 이 저장소를 clone하여 데이터와 스크립트를 다운받은 뒤 터미널 상에서 다음을 입력하여 스크립트를 시작합니다.
```
./proj1_12191595_RohJanghyun.sh teams.csv players.csv matches.csv
```
 이 저장소엔 스크립트가 필요로 하는 csv 파일이 모두 주어집니다. 저장소에 주어지는 3개의 파일을 "정확히" 위 순서대로 입력하여야 합니다. 
스크립트 실행 시 배너와 함께 필요로 하는 동작을 입력 받도록 합니다. 동작은 다음과 같이 7종류입니다. 
1. 손흥민 선수에 대한 데이터를 출력합니다.
2. 입력한 팀 순위에 따른 팀 이름과 팀 승률을 출력합니다. 
3. 관중 수가 가장 많았던 상위 3개의 경기 정보를 출력합니다.
4. 모든 팀의 순위와 팀별 최고득점자, 해당 선수의 득점 수를 출력합니다. 
5. 경기 정보 데이터에 기록된 날짜 형식을 [yyyy/mm/dd h:mm(am|pm)]로 바꾸어 출력합니다.
6. 입력한 팀에 대한 최고 득실 차 홈 경기 정보를 출력합니다. 
7. 스크립트를 종료합니다. 

 <img width="452" alt="image" src="https://github.com/janghyunroh/OSSIntroProj1/assets/113655323/e213b5fd-2067-41a1-84b4-c964784fc6cf">

 다음과 같은 화면에서 숫자를 입력해 동작을 수행할 수 있습니다. 각 기능에 대한 출력이 완료되면 메뉴 창이 반복해서 등장하며, 이는 사용자가 스크립트를 종료할 때까지 반복됩니다. 
## 기능 1. 
 확인 여부를 물어보는 프롬프트가 뜬 뒤, 확인이 완료되면(‘y’가 입력되면) 손흥민 선수의 해당 시즌 참여 경기, 득점, 어시스트 횟수를 차례대로 출력해줍니다. 확인이 완료되지 않으면 아무것도 출력하지 않습니다. 
## 기능 2.
 출력할 팀 순위를 입력 받도록 합니다. 유효한 순위가 입력되면 해당 순위인 팀의 팀 명과 승률을 출력합니다. 유효하지 않은 숫자가 들어오면 입력을 반복해서 받습니다. 
## 기능 3.
 확인 여부를 물어보는 프롬프트가 뜬 뒤, 확인이 완료되면(‘y’가 입력되면) 해당 시즌의 모든 경기 중 관중 수가 가장 많았던 상위 세 경기의 정보가 출력됩니다. 경기 정보는 홈 팀 명, 원정 팀 명, 경기 날짜, 관중 수 및 경기장 이름으로 이루어져 있습니다. 확인이 완료되지 않으면 아무것도 출력하지 않습니다.
## 기능 4.
 확인 여부를 물어보는 프롬프트가 뜬 뒤, 확인이 완료되면(‘y’가 입력되면) 1위부터 20위까지의 팀 명과 각 팀의 최다 득점자를 출력합니다. 확인이 완료되지 않으면 아무것도 출력하지 않습니다.


## 기능 5.
 확인 여부를 물어보는 프롬프트가 뜬 뒤, 확인이 완료되면(‘y’가 입력되면) 경기 정보 파일의 날짜 정보의 형식을 지정된 형식으로 변경시킨 내용의 파일을 matches_formatted_date.csv라는 이름으로 디렉토리 내에 생성합니다. 그러고 난 뒤 변경된 형식의 날짜 정보를 차례대로 출력합니다. 확인이 완료되지 않으면 아무것도 출력하지 않습니다.
## 기능 6. 
 모든 팀의 리스트가 넘버링과 함께 주어집니다. 출력할 팀 번호를 입력 받으면 해당 팀이 홈 팀으로 진행한 모든 경기 중 가장 큰 득실차로 이긴 경기 정보를 출력합니다. 경기 정보는 경기 날짜, 홈 팀 명, 홈 팀 득점,  어웨이 팀 득점, 어웨이 팀 명으로 이루어져 있으며, 해당되는 경기가 여러 개인 경우 모든 경기의 정보를 출력합니다. 팀 번호가 유효하지 않은 경우 유효한 입력을 받을 때까지 반복합니다. 
## 기능 7. 
 “Bye!” 라는 문구와 함께 스크립트를 종료합니다. 

# 기타 사항
 자세한 구현 사항은 소스 코드 상에 주석으로 남겨두었습니다. 

# License
Apache License Version 2.0, January 2004 http://www.apache.org/licenses/
