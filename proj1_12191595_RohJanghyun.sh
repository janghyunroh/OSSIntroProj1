#!/bin/bash

#input order: teams, players, matches
##########################################################################################

teamsfile="$1"
playersfile="$2"
matchesfile="$3"

menu1() {

# players.csv format

# 1. Full_name (lookup)
# 2. age
# 3. position
# 4. Current Club (p)
# 5. nationality
# 6. appearance_overall (p)
# 7. goals_overall (p)
# 8. assists_overall (p)

	#players.csv comes 2nd

	read -p "Do you want to get the Heung-Min Son's data? (y/n) : " ans
	if [ "$ans" = "y" ]; then
		
		cat "$playersfile" | awk -F, '$1 == "Heung-Min Son" { printf "Team: %s, Appearance: %s, Goal: %s, Assist: %s\n\n", $4, $6, $7, $8}' 
		
	fi
}

menu2() { 

# teams.csv format

# 1. common_name (p)
# 2. wins  (u)
# 3. draws (u)
# 4. losses(u)
# 5. points_per_game
# 6. league_position (lookup)
# 7. cards
# 8. shots
# 9. fouls

	read -p "What do you want to get the team data of league_position[1~20] : " league_position
	cat "$teamsfile" | awk -F, -v pos="$league_position" '$6==pos{printf("%s %s %f\n\n", pos, $1, $2/($2+$3+$4))}' 
}
menu3() { 
	read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) : " ans 
	if [ "$ans" = "y" ]; then
		echo ""
	fi
}
menu4() { 
	read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " ans
	if [ "$ans" = "y" ]; then
		echo ""
	fi
}
menu5() { 
	read -p "Do you want to modify the format of date? (y/n) : " ans
	if [ "$ans" = "y" ]; then
		echo ""
	fi
}
menu6() { 
	echo "" 
	read -p "Enter your team number : " team_no
}
menu7() {
	echo "Bye!"
}


############################################################################################

# 1. input error handling

# the input must 'speicifically' be as following
# ./script teams.csv players.csv matches.csv

# teams.csv 
# players.csv
# matches.csv


#1) if not 3 params 
#if [ $# -ne 3 ]; then
#	echo "wrong input: you must give 3 files as input."
#	echo "usage: $0 teams.csv players.csv matches.csv"
#	exit 1
#fi

#if not correct names or wrong order
if [ "$*" != "teams.csv players.csv matches.csv" ]; then
	echo "wrong input: you must give 3 specific csv files in following order"
	echo "usage: $0 teams.csv palyers.csv matches.csv"
	exit 1
fi

#for file in "$@"; do
#	if ! [[ "$file" =~ \.csv$ ]]; then
#		echo "wrong input: all files should be correct csv file in following order."
#		echo "usage: $0 teams.csv players.csv matches.csv"
#		exit 1
#	fi
#done

#if not right order or wrong file name


# 2. 
echo "************OSS1 - Project1************"
echo "*        StudentID : 12191595         *"
echo "*        Name : Janghyun Roh          *"
echo "***************************************"

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
	1)
		menu1
		;;
	2)
		menu2
		;;
	3) 
		menu3
		;;
	4) 
		menu4
		;;
	5) 
		menu5
		;;
	6)
		menu6
		;;
	7)
		menu7
		stop="Y"
		;;
	esac
done
exit 0
