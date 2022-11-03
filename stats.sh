#!/usr/bin/env bash


#:     Title: stats - Fetch bleague player's stats.
#:  Synopsis: stats [-t|-p] STRING
#:   Options: -t - Specify team name
#:            -p - Specify player name

## Script metadata
scriptname=${0##*/}
description="Fetch bleatue player's stats from bleague officialsite"
usage="$scriptname [-t|-p] STRING"
LANG=en_US.utf8

## File locations
idfile=$PWD/players.cfg

## Source other files
. loword

playersmenu()
{
    local IFS=$'\n' players
    local player
    local num n=0

    players=( $( < "${idfile}") )

    for elm in "${players[@]}"
    do
        n=$(( $n + 1 ))
        printf "  %3d. %s\n" "$n" "${elm}"
    done

    read -p " (1 to ${n}) ==> " $opt num

    ## Check the user entry is valid
    case $num in
        [qQ0] | "" ) return ;; ## q, Q or 0 "" exists
        *[!0-9]* | 0*)
            printf "\aInvalid response: %s\n" "$num" >&2
            return 1
            ;;
    esac
    echo

    if (( $num >= ${#players[@]} )); then
        printf "\aInvalid response: %s\n" "$num" >&2
        return 1
    fi

    unset _player_id

    player=${players[($num-1)]}
    _player_id="${player%%=*}"

}

fetch_html()
{
    local id=$1
    local url="https://www.bleague.jp/roster_detail/?PlayerID=${id}"

    curl -so "players/${id}.html" "$url"

}

# TODO Select team name

playersmenu
fetch_html ${_player_id}

printf "result: ${_player_id}\n"

# 平均得点数
ppg=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[1]/div[2]/p/span/text()' --html - 2>/dev/null)
# 平均トータルリバウンド数
rpg=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[5]/div[2]/p/span/text()' --html - 2>/dev/null)
# 平均アシスト数
apg=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[6]/div[2]/p/span/text()' --html - 2>/dev/null)
# 平均スティール数
spg=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[8]/div[2]/p/span/text()' --html - 2>/dev/null)
# 平均ブロック数
bpg=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[7]/div[2]/p/span/text()' --html - 2>/dev/null)
# フィールドゴール成功率
fgper=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[2]/div[2]/p/span/text()' --html - 2>/dev/null)
# 3Pシュート成功率
threefgper=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[3]/div[2]/p/span/text()' --html - 2>/dev/null)
# フリースロー成功率
ftper=$(cat "players/${_player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[4]/div[2]/p/span/text()' --html - 2>/dev/null)

echo "------------------------------------------------"
printf "%-28s %s\n" "平均得点数:" $ppg
printf "%-30s %s\n" "平均トータルリバウンド数:" $rpg
printf "%-31s %s\n" "平均アシスト数:" $apg
printf "%-32s %s\n" "平均スティール数:" $spg
printf "%-31s %s\n" "平均ブロック数:" $bpg
printf "%-36s %s\n" "フィールドゴール成功率:" $fgper
printf "%-31s %s\n" "3Pシュート成功率:" $threefgper
printf "%-33s %s\n" "フリースロー成功率:" $ftper
echo "------------------------------------------------"
