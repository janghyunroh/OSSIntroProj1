#!/bin/bash

#========== 필요한 global 변수 목록 =========#

# 1. 파일명을 저장할 변수
# 2. 상단 배너 문자열
# 3. 각종 함수

#============================================#

# 1. 파일명 변수
# 입력 순서: teams, players, matches
# 이 입력 순서는 사용자에게 반드시 지키도록 안내할 것
teamsfile="$1"
playersfile="$2"
matchesfile="$3"

# 2. 상단 배너. 깔끔한 인터페이스를 위해 clear 명령어와 함께 사용하여 사용자 친화적으로 만들기
banner="
************OSS1 - Project1************
*        StudentID : 12191595         *
*        Name : Janghyun Roh          *
***************************************"

# 3. 7개의 기능에 각각 대응하는 함수들

#---------- 함수1: 손흥민 선수 정보 출력 ----------#
menu1() {

	# players.csv에서 손흥민 선수의 이름을 검색해, 해당 row의 요구하는 정보를 그대로 출력
	read -p "Do you want to get the Heung-Min Son's data? (y/n) : " ans
	if [ "$ans" = "y" ]; then

		clear
		echo -e "$banner"
		cat "$playersfile" | awk -F, '$1 == "Heung-Min Son" { printf "Team: %s, Appearance: %s, Goal: %s, Assist: %s\n\n", $4, $6, $7, $8}' 
	else
		clear
		echo -e "$banner"
		echo ""
		echo ""
	fi
}

#---------- 함수2: 특정 순위의 팀명과 승률----------#
menu2() { 
	
	# teams.csv 파일을 사용
	# 총 20개의 팀이 있기 때문에 1~20의 숫자만 받을 것 - until문 사용
	appropriate_input="N"
	until [ "$appropriate_input" = "Y" ] 
	do
		read -p "What do you want to get the team data of league_position[1~20] : " league_position
		if [ "$league_position" -ge 1 -a "$league_position" -le 20 ]; then
			appropriate_input="Y"
		else
			echo "invalid input. please put a number between 1 and 20."
		fi
	done

	# 제대로 된 입력이 들어오고 나면 출력을 수행
	clear
	echo -e "$banner"
	cat "$teamsfile" | awk -F, -v pos="$league_position" '$6==pos{printf("%s %s %f\n\n", pos, $1, $2/($2+$3+$4))}' 
}

#---------- 함수3: 최고 관중 수 상위 3경기 출력 ----------#
menu3() { 

#uses data from matches.csv

	# matches.csv에서 관중 수 기준으로 정렬한 뒤, 상위 3개의 데이터에서 필요한 정보만 골라 출력
	# 문제점: ',' 구분자를 때어낸 뒤 sort로 출력한 내용을 redirection하여 사용해버리면 새 구분자 space와 원래 팀명에 있던 space를 구분 못함
	# ',' 구분자를 때어내는 과정에서 별도의 임의 구분자 ';'를 삽입하여 sort 후 출력에 사용

	read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) : " ans 
	if [ "$ans" = "y" ]; then
		clear 
		echo -e "$banner"

		echo "***Top-3 Attendance Match***"
		echo ""

		cat "$matchesfile" | 
		awk -F, 'NR > 1 { print $2 ";" $3 " vs " $4 " "  "(" $1 ")" ";" $7 }' | 
		sort -nr -k1,1 | 
		head -n 3 | 
		awk -F";" '{printf "%s\n%s %s\n\n", $2, $1, $3}'
	else 
		clear
		echo -e "$banner"
		echo ""
		echo ""
	fi
}

#---------- 함수4: 각 팀 순위와 각 팀별 최고득점자 ----------#
menu4() {

#uses data from teams.csv & 

	# teams.csv, player.csv 파일 사용
	# 개인적으로 가장 난이도 있다고 생각한 기능.
	# 처음엔 awk 2번과 redirection으로 해결 가능할 줄 알았으나, 파일을 2개 사용하는데
	# 한 팀에 대한 한 번의 출력에 두 파일에서 가져오는 데이터가 모두 포함되다보니 상당히 애를 먹었음.
	# 개인적으로 공부를 하다가 awk 배열이나 FNR 변수 등, 두 입력 파일을 다루는 법에 대해 조금 알게 되었음.
	
	read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " ans
	echo ""
	if [ "$ans" = "y" ]; then

		clear
		echo -e "$banner"
		echo ""
	
		#awk내에서 사용할 배열 
		#team_name_of_rank[순위] : 해당 순위의 팀명
		#team_goals[팀명][선수명] : 해당 팀 소속 선수의 골 수

		awk -F, '
		NR == FNR && NR > 1 { team_name_of_rank[$6] = $1; next;}	# 첫번째 - teams.csv에서 $6의 순위인 팀 이름은 $1
		FNR > 1 {  team_goals[$4][$1] = $7; }						# 두번째 - players.csv에서 $4팀의 $1선수의 골 = $7
		END {														# 모든 파일에 대한 기록이 끝난 뒤 팀별 최다득점자 계산 
        
			#이중 반복문을 통해 모든 팀에 대해 각자 모든 선수를 돌면서 최다득점자 계산 및 출력

			for (rank in team_name_of_rank) { # 모든 팀에 대해
				print rank, team_name_of_rank[rank]; 

				max_goals = 0; max_scorer = "";
				
				for (player in team_goals[team_name_of_rank[rank]]) { # 그 팀의 모든 선수에 대해
					if (team_goals[team_name_of_rank[rank]][player] > max_goals) {
						max_goals = team_goals[team_rank[rank]][player];
						max_scorer = player;
					}
				}
    
				print max_scorer, max_goals;
				print ""          
			}
		}
		' "$teamsfile" "$playersfile"
	else
		clear
		echo "$banner"
		echo ""
		echo ""
	fi
}

#---------- 함수5: 날짜 정보 변경 ----------#
# 이 부분은 문제에서 파일의 원본을 변경하는 것인지, 아니면 다른 형식으로 출력만 하는 것인지 명확하지 않아서,
# 날짜의 형식만을 바꾼 matches_date_formatted.csv 파일을 만든 뒤, 해당 파일에서 날짜만을 출력하는 식으로 구현하였음.
menu5() { 
	read -p "Do you want to modify the format of date? (y/n) : " ans
	if [ "$ans" = "y" ]; then
		clear
		echo -e "$banner"
		
		# sed를 이용한 문자 stream 변경
		cat "$matchesfile" |
		sed -E 's/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2}(am|pm))/\3\/\1\/\2 \4/g' | \
		sed -E 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/' > matches_date_formatted.csv

		# 작성한 파일에서 날짜 부분만 가져와 출력
		grep -oE '[0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{1,2}:[0-9]{2}(am|pm)' matches_date_formatted.csv | head -n 10
		echo ""
		echo ""
	else
		clear
		echo -e "$banner"
		echo ""
		echo ""
	fi
	
}

#---------- 함수6: 팀의 가장 큰 득실차로 이긴 홈경기 정보를 모두 출력 ----------#
menu6() {
	
	# select문을 사용하기 위해 teams.csv에서 팀 정보만을 추출하여 배열에 저장
	# select문의 선택 결과에 대응되는 팀을 matches.csv에서 검색하여 경기 정보 출력
	# "가장 큰" 득실차의 경기여야 하고,
	# 동일한 득실차의 모든 경기 정보를 출력해야 하므로
	# awk에서 모든 row를 읽어가며 별도의 배열에 경기 정보 저장
	# 한번이라도 갱신되는 순간 배열을 버리고 새로 생성
	clear 
	echo -e "$banner"
	echo ""
	
	# 여기서 
	IFS=$'\n' read -d '' -r -a team_names < <(awk -F, 'NR > 1 {print $1}' teams.csv)
	
	#프롬프트 변경
	PS3="Enter your team number : "
	
	select team in "${team_names[@]}"
	do
		if [ -n "$team" ]; then
			
			echo ""
			break

		else
		
			echo "Invalid selection, try again."

		fi
	done
	
	# 홈 팀이 $team과 일치하는 경기를 찾고, 현재까지 최댓값과 동일하다면 배열에 저장
	# 최댓값이 갱신되었다면 지금까지의 배열을 버리고 새 배열을 생성, 해당 배열에 저장 
	# games[] : 경기 정보 배열

	#matches.csv format

	# $1 : date

	# $3 : home team name
	# $4 : away team name
	# $5 : home team score
	# $6 : away team score

	# --> 출력 형식 
	#[$1]
	#[$3] [$5] vs [$6] [$4]
	
	clear
	echo "$banner"

	awk -F, -v team="$team" '

	#훑어보기 전: 최댓값 초기화
	BEGIN {
		max_goal_diff = 0;
	}

	#훑어보기: 최댓값 갱신 및 경기 정보 배열 완성 
	$3 == team {
		goal_diff = $5 - $6;  
		if (goal_diff > max_goal_diff) {
			max_goal_diff = goal_diff;  
			delete games;  
		}
		if (goal_diff == max_goal_diff) {
			games[$1] = $3 " " $5 " vs " $6 " " $4;  
		}
	}

	#최종: 출력
	END {
		for (date in games) {
			print  date "\n"  games[date] "\n" ;
		}
	}
	' matches.csv

	echo ""
	
}

#---------- 함수7: 종료 ----------#
# 실제 종료 기능은 아래 함수 사용처에 구현
menu7() {
	echo "Bye!"
	echo ""
}

#---------- 실제 구현부 ----------#

# 1. 입력 예외 처리

# 입력은 반드시 정확하게 다음과 같아야 함.
# ./script teams.csv players.csv matches.csv

# 이 부분은 좀 고민을 많이 했고 실제로 질문도 드렸었는데, 아무래도 이렇게 하는 것이 더 안전한 개발 방식인 것 같아서
# 그냥 하드 문자열 매칭으로 강한 입력 조건을 걸었습니다.

# 과제 테스트에선 3개의 올바른 csv 파일이 주어지지 않은 경우만 예외처리를 하면 된다고 해주셨는데,
# 그러면 파일명은 모두 올바르지만 순서가 틀린 경우 등의 입력에도 올바르게 동작해야 하기 때문에
# 파라미터 조정 등의 별도의 자잘한 작업들이 너무 많이 요구될 것 같았습니다. 

# 해당 부분에 대한 질문을 드렸을 때, 올바른 입력은 항상 PPT에 주어진 형태로 들어온다고 말씀해주셨기 때문에 
# 정확하게 저 순서의 입력이 아니면 다시 입력하도록 예외 처리를 진행했습니다. 


#if not correct names or wrong order
if [ "$*" != "teams.csv players.csv matches.csv" ]; then
	echo "wrong input: you must give 3 specific csv files in following order"
	echo "usage: $0 teams.csv players.csv matches.csv"
	exit 1
fi

# 2. 배너 및 메뉴 출력
# 인터페이스는 clear 명령어를 통해 좀 더 보기 깔끔하고 사용하기 편리하도록 하였습니다.

clear
echo -e "$banner"
echo ""
echo ""

stop="N"

until [ "$stop" = "Y" ] 
do
	echo "[MENU]"
	echo "1. Get the data of Heung-Min Son's Current Club, Apperances, Goals, Assists in players.csv"
	echo "2. Get the team data to enter a league position in teams.csv"
	echo "3. Get the Top-3 Attendace matches in matches.csv"
	echo "4. Get the team's league position and team's top scorer in teams.csv & players.csv"
	echo "5. Get the modified format of date_GMT in matches.csv"
	echo "6. Get the data of the winning team by the largest differnece on home stadium in teams.csv & matches.csv"
	echo "7. EXIT"

	read -p "Enter your CHOICE(1~7) : " choice

	case "$choice" in
	1) menu1 ;;
	2) menu2 ;;
	3) menu3 ;;
	4) menu4 ;;
	5) menu5 ;;
	6) menu6 ;;
	7) menu7; stop="Y" ;;
	*) clear; echo -e "$banner"; echo ""; echo ""
	esac

done
exit 0
