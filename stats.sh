#!/usr/bin/env bash


#:     Title: stats - Fetch bleague player's stats.
#:  Synopsis: stats [-t|-p] STRING
#:   Options: -t - Specify team name
#:            -p - Specify player name

## Script metadata
scriptname=${0##*/}
description="Fetch bleatue player's stats from bleague officialsite"
usage="$scriptname [-t|-p] STRING"

## File locations
idfile=$PWD/players.cfg

## Source other files
. loword

playersmenu()
{
    local IFS=$'\n' players
    local player=$1
    local num n=0

    players=( $( < "${idfile}") )
    case "${players[*]}" in
        *"$player"*) ;;
        *) echo "指定した選手名が存在しません"; exit 1 ;;
    esac

    for elm in "${players[@]}"
    do
        n=$(( $n + 1 ))
        printf "  %3d. %s\n" "$n" "${elm}"
    done

    read -p " (1 to ${n}) ==> " $opt num

}

# TODO main code
if [ $# -ne 1 ]; then
    echo "選手名を指定してください"
    exit 1
fi

player=$(loword "$1")

playersmenu "$player"

# players_dict="
# 9055 YukiTogashi
# 18440 JoshDuncan
# 30465 RaitaAkaho
# 8653 HiromasaOmiya
# 51000112 HikaruFutagami
# 8580 FumioNishimura
# 30351 SotaOkura
# 15811 TakumaSato
# 8736 YoshiakiFujinaga
# 8593 GavinEdwards
# 30521 FarazRashid
# 8584 ShutaHara
# 5100000054 JohnMooney
# 5100000055 ChristopherSmith
# "

# fetch_html()
# {
#     local id=$(echo "$players" | grep -i $1 | cut -f 1 -d ' ')
#     local url="https://www.bleague.jp/roster_detail/?PlayerID=${id}"

#     # player_id=$(echo "$players_dict" | grep -i $1 | cut -f 1 -d ' ')
#     # player_url="https://www.bleague.jp/roster_detail/?PlayerID=${player_id}"
#     curl -so "players/${id}.html" "$player_url"

# }


# # 平均得点数
# ppg=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[1]/div[2]/p/span/text()' --html - 2>/dev/null)
# # 平均トータルリバウンド数
# rpg=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[5]/div[2]/p/span/text()' --html - 2>/dev/null)
# # 平均アシスト数
# apg=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[6]/div[2]/p/span/text()' --html - 2>/dev/null)
# # 平均スティール数
# spg=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[8]/div[2]/p/span/text()' --html - 2>/dev/null)
# # 平均ブロック数
# bpg=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[7]/div[2]/p/span/text()' --html - 2>/dev/null)
# # フィールドゴール成功率
# fgper=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[2]/div[2]/p/span/text()' --html - 2>/dev/null)
# # 3Pシュート成功率
# threefgper=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[3]/div[2]/p/span/text()' --html - 2>/dev/null)
# # フリースロー成功率
# ftper=$(cat "players/${player_id}.html" | xmllint --xpath '//*[@id="page_roster_detail"]/div/main/div[3]/div/section[2]/div[1]/div/div[4]/div[2]/p/span/text()' --html - 2>/dev/null)

# echo "------------------------------------------------"
# printf "%-30s %s\n" "平均得点数:" $ppg
# printf "%-30s %s\n" "平均トータルリバウンド数:" $rpg
# printf "%-32s %s\n" "平均アシスト数:" $apg
# printf "%-33s %s\n" "平均スティール数:" $spg
# printf "%-32s %s\n" "平均ブロック数:" $bpg
# printf "%-36s %s\n" "フィールドゴール成功率:" $fgper
# printf "%-32s %s\n" "3Pシュート成功率:" $threefgper
# printf "%-34s %s\n" "フリースロー成功率:" $ftper
# echo "------------------------------------------------"
