#!/bin/bash

#input order: teams, players, matches
# global variable - filenames

teamsfile="$1"
playersfile="$2"
matchesfile="$3"


# functions for each menu
##########################################################################################
menu1() {

#uses data from players.csv

# [players.csv format]
# 1. Full_name (lookup)
# 2. age
# 3. position
# 4. Current Club (print)
# 5. nationality
# 6. appearance_overall (print)
# 7. goals_overall (print)
# 8. assists_overall (print)

	read -p "Do you want to get the Heung-Min Son's data? (y/n) : " ans
	if [ "$ans" = "y" ]; then
		
		cat "$playersfile" | awk -F, '$1 == "Heung-Min Son" { printf "Team: %s, Appearance: %s, Goal: %s, Assist: %s\n\n", $4, $6, $7, $8}' 
		
	fi
}

menu2() { 

#uses data from teams.csv

# [teams.csv format]
# 1. common_name (print)
# 2. wins  (use)
# 3. draws (use)
# 4. losses(use)
# 5. points_per_game
# 6. league_position (lookup & print)
# 7. cards
# 8. shots
# 9. fouls

	read -p "What do you want to get the team data of league_position[1~20] : " league_position
	cat "$teamsfile" | awk -F, -v pos="$league_position" '$6==pos{printf("%s %s %f\n\n", pos, $1, $2/($2+$3+$4))}' 
}

menu3() { 

#uses data from matches.csv

# [matches.csv format]
# 1. date_GMT (print)
# 2. attendance (lookup & print)
# 3. home_team_name (print)
# 4. away_team_name (print)
# 5. home_team_goal_count
# 6. away_team_goal_count
# 7. stadium_name (print)

# seperate -> sort -> seperate again to print in a format
# need to add additional seperator before sorting for later seperation

	read -p "Do you want to know Top-3 attendance data and average attendance? (y/n) : " ans 
	if [ "$ans" = "y" ]; then
		echo "***Top-3 Attendance Match***"
		echo ""
		cat "$matchesfile" | 
		awk -F, 'NR > 1 { print $2 ";" $3 " vs " $4 " "  "(" $1 ")" ";" $7 }' | 
		sort -nr -k1,1 | 
		head -n 3 | 
		awk -F";" '{printf "%s\n%s %s\n\n", $2, $1, $3}'
	fi
}

menu4() {

#uses data from teams.csv & 

#
	read -p "Do you want to get each team's ranking and the highest-scoring player? (y/n) : " ans
	echo ""
	if [ "$ans" = "y" ]; then
	
	#awk variable that will use
	#team_rank[] : 
	#team_goals[] : 

	awk -F, '
    NR == FNR && NR > 1 { team_rank[$6] = $1; next;}
    FNR > 1 {  team_goals[$4][$1] = $7; }
    END {
        
        for (rank in team_rank) {
            print rank, team_rank[rank]; 

            max_goals = 0; max_scorer = "";
            for (player in team_goals[team_rank[rank]]) {
                if (team_goals[team_rank[rank]][player] > max_goals) {
                    max_goals = team_goals[team_rank[rank]][player];
                    max_scorer = player;
                }
            }
    
            print max_scorer, max_goals;
            print "";  
        }
    }
	' "$teamsfile" "$playersfile"
	fi
}

menu5() { 
	read -p "Do you want to modify the format of date? (y/n) : " ans
	if [ "$ans" = "y" ]; then
		
		cat "$matchesfile" |
		sed -E 's/(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([0-9]{1,2}) ([0-9]{4}) - ([0-9]{1,2}:[0-9]{2}(am|pm))/\3\/\1\/\2 \4/g' | \
		sed -E 's/Jan/01/; s/Feb/02/; s/Mar/03/; s/Apr/04/; s/May/05/; s/Jun/06/; s/Jul/07/; s/Aug/08/; s/Sep/09/; s/Oct/10/; s/Nov/11/; s/Dec/12/' > matches_date_formatted.csv

		# write a file
		# and then read from that file
		grep -oE '[0-9]{4}/[0-9]{2}/[0-9]{2} [0-9]{1,2}:[0-9]{2}(am|pm)' matches_date_formatted.csv | head -n 10

	fi
	echo ""
}

menu6() {
	
	# use select, use team names from teams.csv as a list for select statement
	# 

	echo ""
	IFS=$'\n' read -d '' -r -a team_names < <(awk -F, 'NR > 1 {print $1}' teams.csv)
	
	PS3="Enter your team number : "

	select team in "${team_names[@]}"
	do
		if [ -n "$team" ]; then
			
			# if validate input, break and search for team name
			echo ""
			break
		else
			# else, try again
			echo "Invalid selection, try again."
		fi
	done
	
	# search for team name(home) and get max goal diff games
	# games[] = 
	# when max_goal_diff is updated, erase former games array 

	#matches.csv format

	# $1 : date

	# $3 : home team name
	# $4 : away team name
	# $5 : home team score
	# $6 : away team score

	# --> format must be : 
	#[$1]
	#[$3] [$5] vs [$6] [$4]


	awk -F, -v team="$team" '

	#Before lookup : init params
	BEGIN {
		max_goal_diff = 0;
	}

	#During lookup : update max_goal_diff and create / add to array
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

	#After lookup : print
	END {
		for (date in games) {
			print  date "\n"  games[date] "\n" ;
		}
	}
	' matches.csv


}

menu7() {
	echo "Bye!"
	echo ""
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
