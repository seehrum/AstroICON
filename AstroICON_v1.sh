#!/bin/bash

# 1=ON 0=FF

MONDAY_MOON_=0
TUESDAY_MARS_=1
WEDNESDAY_MERCURY_=0
THURSDAY_JUPITER_=0
FRIDAY_VENUS_=0
SATURDAY_SATURN_=0
SUNDAY_SUN_=0
PLANETARY_HOURS_CHART_=0

DAY_OF_WEEK_=1

# CONFIGURE
# Use the 24-hour time format

HOUR_SUNRISE="06"
MINUTES_SUNRISE="11"
HOUR_SUNSET="18"
MINUTES_SUNSET="30"
HOUR_SUNRISE_OF_NEXT_DAY="06"
MINUTES_SUNRISE_OF_NEXT_DAY="11"


# ICONS PLANETS
MOON="☽" 
MARS="♂" 
MERCURY="☿"
JUPITER="♃"
VENUS="♀"
SATURN="♄"
SUN="☉"

if [[ "$1" == "-d" ]]; then
  day_number="$2"
else
  day_number="$1"
fi

case $day_number in
    1) day_var="MONDAY_MOON_" ;;
    2) day_var="TUESDAY_MARS_" ;;
    3) day_var="WEDNESDAY_MERCURY_" ;;
    4) day_var="THURSDAY_JUPITER_" ;;
    5) day_var="FRIDAY_VENUS_" ;;
    6) day_var="SATURDAY_SATURN_" ;;
    7) day_var="SUNDAY_SUN_" ;;
    8) day_var="PLANETARY_HOURS_CHART_" ;;
    *)
      # Se day_number foi definido mas não é válido
      if [[ ! -z "$day_number" ]]; then
        echo "Invalid day number. Please provide a number from 1 to 8."
        exit 1
      fi
      ;;
esac

if [[ ! -z "$day_var" ]]; then
  declare "$day_var=1"
fi

# Define the threshold time to determine the day transition
TRANSITION_THRESHOLD="$HOUR_SUNRISE:$MINUTES_SUNRISE"

# Capture the current system time in HH:MM format
NOW_TIME=$(date +%H:%M)

# Determine the current day of the week numerically (1 is Monday, 7 is Sunday)
CURRENT_WEEKDAY=$(date +%u)

# Check if the current time precedes the transition threshold
if [[ "$NOW_TIME" < "$TRANSITION_THRESHOLD" ]]; then
  # Adjust to the previous day if before the threshold
  # Special case: If it's Monday (1), switch to Sunday (7)
  if [[ "$CURRENT_WEEKDAY" -eq 1 ]]; then
    CURRENT_WEEKDAY=7
  else
    # For any other day, decrease the weekday number by one
    CURRENT_WEEKDAY=$((CURRENT_WEEKDAY - 1))
  fi
fi

day_of_week="$CURRENT_WEEKDAY"

# Match the day of the week to its corresponding symbol
case $day_of_week in
    1) symbol="$MOON" ;; # Monday
    2) symbol="$MARS" ;; # Tuesday
    3) symbol="$MERCURY" ;; # Wednesday & Friday
    4) symbol="$JUPITER" ;; # Thursday
    5) symbol="$VENUS" ;; # Wednesday & Friday
    6) symbol="$SATURN" ;; # Saturday
    7) symbol="$SUN" ;; # Sunday
    *) symbol="Unknown" ;; # Just in case
esac

if [ "$DAY_OF_WEEK_" -eq 1 ]; then
    echo -n "$symbol"
fi

TOTAL_MINUTES_IN_DAY="1440"

# DAY

SUM_1=$(echo "$HOUR_SUNRISE * 60" | bc)             # pega hora do nascimento do sol e transforma em minutos
SUM_2=$(echo "$SUM_1 + $MINUTES_SUNRISE" | bc)      # adiciona os minutos do nascimento do sol

SUM_3=$(echo "$HOUR_SUNSET * 60" | bc)              # pega a hora do por do sol e transforma em minutos
SUM_4=$(echo "$SUM_3 + $MINUTES_SUNSET" | bc)       # adiciona os minutos do por do sol
SUM_5=$(echo "$SUM_4 - $SUM_2" |bc)                 # soma por do sol - nascer do sol
DAYLIGHT_PERIOD=$(echo "$SUM_5 / 12" |bc)                     # soma por do sol - nascer do sol e divide por 12

# NIGHT

SUM_7=$(echo "$HOUR_SUNRISE_OF_NEXT_DAY * 60" | bc)
SUM_8=$(echo "$SUM_7 + $MINUTES_SUNRISE_OF_NEXT_DAY" | bc)
SUM_9=$(echo "$SUM_4 - $SUM_8" | bc)
SUM_10=$(echo "$TOTAL_MINUTES_IN_DAY - $SUM_9" | bc)
NIGHT_PERIOD=$(echo "$SUM_10 / 12" | bc)


# DAY
hour_day_1=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + 0 minutes" +'%H:%M')

minutes_x_1=$(echo "$DAYLIGHT_PERIOD * 1" | bc)
hour_day_2=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_1  minutes" +'%H:%M')

minutes_x_2=$(echo "$DAYLIGHT_PERIOD * 2" | bc)
hour_day_3=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_2  minutes" +'%H:%M')

minutes_x_3=$(echo "$DAYLIGHT_PERIOD * 3" | bc)
hour_day_4=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_3  minutes" +'%H:%M')

minutes_x_4=$(echo "$DAYLIGHT_PERIOD * 4" | bc)
hour_day_5=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_4  minutes" +'%H:%M')

minutes_x_5=$(echo "$DAYLIGHT_PERIOD * 5" | bc)
hour_day_6=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_5  minutes" +'%H:%M')

minutes_x_6=$(echo "$DAYLIGHT_PERIOD * 6" | bc)
hour_day_7=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_6  minutes" +'%H:%M')

minutes_x_7=$(echo "$DAYLIGHT_PERIOD * 7" | bc)
hour_day_8=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_7  minutes" +'%H:%M')

minutes_x_8=$(echo "$DAYLIGHT_PERIOD * 8" | bc)
hour_day_9=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_8  minutes" +'%H:%M')

minutes_x_9=$(echo "$DAYLIGHT_PERIOD * 9" | bc)
hour_day_10=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_9  minutes" +'%H:%M')

minutes_x_10=$(echo "$DAYLIGHT_PERIOD * 10" | bc)
hour_day_11=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_10  minutes" +'%H:%M')

minutes_x_11=$(echo "$DAYLIGHT_PERIOD * 11" | bc)
hour_day_12=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + $minutes_x_11  minutes" +'%H:%M')

# NIGHT
hour_night_1=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + 0 minutes" +'%H:%M')

minutes_nx_1=$(echo "$NIGHT_PERIOD * 1" | bc)
hour_night_2=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_1  minutes" +'%H:%M')

minutes_nx_2=$(echo "$NIGHT_PERIOD * 2" | bc)
hour_night_3=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_2  minutes" +'%H:%M')

minutes_nx_3=$(echo "$NIGHT_PERIOD * 3" | bc)
hour_night_4=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_3  minutes" +'%H:%M')

minutes_nx_4=$(echo "$NIGHT_PERIOD * 4" | bc)
hour_night_5=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_4  minutes" +'%H:%M')

minutes_nx_5=$(echo "$NIGHT_PERIOD * 5" | bc)
hour_night_6=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_5  minutes" +'%H:%M')

minutes_nx_6=$(echo "$NIGHT_PERIOD * 6" | bc)
hour_night_7=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_6  minutes" +'%H:%M')

minutes_nx_7=$(echo "$NIGHT_PERIOD * 7" | bc)
hour_night_8=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_7  minutes" +'%H:%M')

minutes_nx_8=$(echo "$NIGHT_PERIOD * 8" | bc)
hour_night_9=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_8  minutes" +'%H:%M')

minutes_nx_9=$(echo "$NIGHT_PERIOD * 9" | bc)
hour_night_10=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_9  minutes" +'%H:%M')

minutes_nx_10=$(echo "$NIGHT_PERIOD * 10" | bc)
hour_night_11=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_10  minutes" +'%H:%M')

minutes_nx_11=$(echo "$NIGHT_PERIOD * 11" | bc)
hour_night_12=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + $minutes_nx_11  minutes" +'%H:%M')

# Define start times
start1="$hour_day_1"
start2="$hour_day_2"
start3="$hour_day_3"
start4="$hour_day_4"
start5="$hour_day_5"
start6="$hour_day_6"
start7="$hour_day_7"
start8="$hour_day_8"
start9="$hour_day_9"
start10="$hour_day_10"
start11="$hour_day_11"
start12="$hour_day_12"
start13="$hour_night_1"
start14="$hour_night_2"
start15="$hour_night_3"
start16="$hour_night_4"
start17="$hour_night_5"
start18="$hour_night_6"
start19="$hour_night_7"
start20="$hour_night_8"
start21="$hour_night_9"
start22="$hour_night_10"
start23="$hour_night_11"
start24="$hour_night_12"

# Get current time in HH:MM format
current_time=$(date +%H:%M)

# Function to check if current time is within a time interval
check_time() {
    if [[ "$current_time" > $1 ]] && [[ "$current_time" < $2 ]]; then
        echo -n $3
    fi
}

MONDAY_MOON(){
check_time $start1 $start2 $MOON
check_time $start2 $start3 $SATURN
check_time $start3 $start4 $JUPITER
check_time $start4 $start5 $MARS
check_time $start5 $start6 $SUN
check_time $start6 $start7 $VENUS
check_time $start7 $start8 $MERCURY
check_time $start8 $start9 $MOON
check_time $start9 $start10 $SATURN
check_time $start10 $start11 $JUPITER
check_time $start11 $start12 $MARS
check_time $start12 $start13 $SUN
check_time $start13 $start14 $VENUS
check_time $start14 $start15 $MERCURY
check_time $start15 $start16 $MOON
check_time $start16 $start17 $SATURN
check_time $start17 $start18 $JUPITER
check_time $start18 $start19 $MARS
check_time $start19 $start20 $SUN
check_time $start20 $start21 $VENUS
check_time $start21 $start22 $MERCURY
check_time $start22 $start23 $MOON
check_time $start23 $start24 $SATURN
check_time $start24 $start1 $JUPITER
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

TUESDAY_MARS(){
check_time $start1 $start2 $MARS
check_time $start2 $start3 $SUN
check_time $start3 $start4 $VENUS
check_time $start4 $start5 $MERCURY
check_time $start5 $start6 $MOON
check_time $start6 $start7 $SATURN
check_time $start7 $start8 $JUPITER
check_time $start8 $start9 $MARS
check_time $start9 $start10 $SUN
check_time $start10 $start11 $VENUS
check_time $start11 $start12 $MERCURY
check_time $start12 $start13 $MOON
check_time $start13 $start14 $SATURN
check_time $start14 $start15 $JUPITER
check_time $start15 $start16 $MARS
check_time $start16 $start17 $SUN
check_time $start17 $start18 $VENUS
check_time $start18 $start19 $MERCURY
check_time $start19 $start20 $MOON
check_time $start20 $start21 $SATURN
check_time $start21 $start22 $JUPITER
check_time $start22 $start23 $MARS
check_time $start23 $start24 $SUN
check_time $start24 $start1 $VENUS
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

WEDNESDAY_MERCURY(){
check_time $start1 $start2 $MERCURY
check_time $start2 $start3 $MOON
check_time $start3 $start4 $SATURN
check_time $start4 $start5 $JUPITER
check_time $start5 $start6 $MARS
check_time $start6 $start7 $SUN
check_time $start7 $start8 $VENUS
check_time $start8 $start9 $MERCURY
check_time $start9 $start10 $MOON
check_time $start10 $start11 $SATURN
check_time $start11 $start12 $JUPITER
check_time $start12 $start13 $MARS
check_time $start13 $start14 $SUN
check_time $start14 $start15 $VENUS
check_time $start15 $start16 $MERCURY
check_time $start16 $start17 $MOON
check_time $start17 $start18 $SATURN
check_time $start18 $start19 $JUPITER
check_time $start19 $start20 $MARS
check_time $start20 $start21 $SUN
check_time $start21 $start22 $VENUS
check_time $start22 $start23 $MERCURY
check_time $start23 $start24 $MOON
check_time $start24 $start1 $SATURN
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

THURSDAY_JUPITER(){
check_time $start1 $start2 $JUPITER
check_time $start2 $start3 $MARS
check_time $start3 $start4 $SUN
check_time $start4 $start5 $VENUS
check_time $start5 $start6 $MERCURY
check_time $start6 $start7 $MOON
check_time $start7 $start8 $SATURN
check_time $start8 $start9 $JUPITER
check_time $start9 $start10 $MARS
check_time $start10 $start11 $SUN
check_time $start11 $start12 $VENUS
check_time $start12 $start13 $MERCURY
check_time $start13 $start14 $MOON
check_time $start14 $start15 $SATURN
check_time $start15 $start16 $JUPITER
check_time $start16 $start17 $MARS
check_time $start17 $start18 $SUN
check_time $start18 $start19 $VENUS
check_time $start19 $start20 $MERCURY
check_time $start20 $start21 $MOON
check_time $start21 $start22 $SATURN
check_time $start22 $start23 $JUPITER
check_time $start23 $start24 $MARS
check_time $start24 $start1 $SUN
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

FRIDAY_VENUS(){
check_time $start1 $start2 $VENUS
check_time $start2 $start3 $MERCURY
check_time $start3 $start4 $MOON
check_time $start4 $start5 $SATURN
check_time $start5 $start6 $JUPITER
check_time $start6 $start7 $MARS
check_time $start7 $start8 $SUN
check_time $start8 $start9 $VENUS
check_time $start9 $start10 $MERCURY
check_time $start10 $start11 $MOON
check_time $start11 $start12 $SATURN
check_time $start12 $start13 $JUPITER
check_time $start13 $start14 $MARS
check_time $start14 $start15 $SUN
check_time $start15 $start16 $VENUS
check_time $start16 $start17 $MERCURY
check_time $start17 $start18 $MOON
check_time $start18 $start19 $SATURN
check_time $start19 $start20 $JUPITER
check_time $start20 $start21 $MARS
check_time $start21 $start22 $SUN
check_time $start22 $start23 $VENUS
check_time $start23 $start24 $MERCURY
check_time $start24 $start1 $MOON
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

SATURDAY_SATURN(){
check_time $start1 $start2 $SATURN
check_time $start2 $start3 $JUPITER
check_time $start3 $start4 $MARS
check_time $start4 $start5 $SUN
check_time $start5 $start6 $VENUS
check_time $start6 $start7 $MERCURY
check_time $start7 $start8 $MOON
check_time $start8 $start9 $SATURN
check_time $start9 $start10 $JUPITER
check_time $start10 $start11 $MARS
check_time $start11 $start12 $SUN
check_time $start12 $start13 $VENUS
check_time $start13 $start14 $MERCURY
check_time $start14 $start15 $MOON
check_time $start15 $start16 $SATURN
check_time $start16 $start17 $JUPITER
check_time $start17 $start18 $MARS
check_time $start18 $start19 $SUN
check_time $start19 $start20 $VENUS
check_time $start20 $start21 $MERCURY
check_time $start21 $start22 $MOON
check_time $start22 $start23 $SATURN
check_time $start23 $start24 $JUPITER
check_time $start24 $start1 $MARS
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

SUNDAY_SUN(){
check_time $start1 $start2 $SUN
check_time $start2 $start3 $VENUS
check_time $start3 $start4 $MERCURY
check_time $start4 $start5 $MOON
check_time $start5 $start6 $SATURN
check_time $start6 $start7 $JUPITER
check_time $start7 $start8 $MARS
check_time $start8 $start9 $SUN
check_time $start9 $start10 $VENUS
check_time $start10 $start11 $MERCURY
check_time $start11 $start12 $MOON
check_time $start12 $start13 $SATURN
check_time $start13 $start14 $JUPITER
check_time $start14 $start15 $MARS
check_time $start15 $start16 $SUN
check_time $start16 $start17 $VENUS
check_time $start17 $start18 $MERCURY
check_time $start18 $start19 $MOON
check_time $start19 $start20 $SATURN
check_time $start20 $start21 $JUPITER
check_time $start21 $start22 $MARS
check_time $start22 $start23 $SUN
check_time $start23 $start24 $VENUS
check_time $start24 $start1 $MERCURY # Looping back to start for 05:08 - 06:11
# If no icons have been printed, it means the current time is outside of the specified intervals
echo
}

PLANETARY_HOURS_CHART(){
printf "     DAY-----------M---T---W---T---F---S---S-\n"
printf "%-2s - %-11s | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ |\n" "1" "$hour_day_1"
printf "%-2s - %-11s | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ |\n" "2" "$hour_day_2"
printf "%-2s - %-11s | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ |\n" "3" "$hour_day_3"
printf "%-2s - %-11s | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ | ☽ |\n" "4" "$hour_day_4"
printf "%-2s - %-11s | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ |\n" "5" "$hour_day_5"
printf "%-2s - %-11s | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ |\n" "6" "$hour_day_6"
printf "%-2s - %-11s | ☿ | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ |\n" "7" "$hour_day_7"
printf "%-2s - %-11s | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ |\n" "8" "$hour_day_8"
printf "%-2s - %-11s | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ |\n" "9" "$hour_day_9"
printf "%-2s - %-11s | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ |\n" "10" "$hour_day_10"
printf "%-2s - %-11s | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ | ☽ |\n" "11" "$hour_day_11"
printf "%-2s - %-11s | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ |\n" "12" "$hour_day_12"
printf "%-2s   NIGHT---------S---M---T---W---T---F---S-|\n"
printf "%-2s - %-11s | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ |\n" "1" "$hour_night_1"
printf "%-2s - %-11s | ☿ | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ |\n" "2" "$hour_night_2"
printf "%-2s - %-11s | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ |\n" "3" "$hour_night_3"
printf "%-2s - %-11s | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ |\n" "4" "$hour_night_4"
printf "%-2s - %-11s | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ |\n" "5" "$hour_night_5"
printf "%-2s - %-11s | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ | ☽ |\n" "6" "$hour_night_6"
printf "%-2s - %-11s | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ |\n" "7" "$hour_night_7"
printf "%-2s - %-11s | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ |\n" "8" "$hour_night_8"
printf "%-2s - %-11s | ☿ | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ |\n" "9" "$hour_night_9"
printf "%-2s - %-11s | ☽ | ♂ | ☿ | ♃ | ♀ | ♄ | ☉ |\n" "10" "$hour_night_10"
printf "%-2s - %-11s | ♄ | ☉ | ☽ | ♂ | ☿ | ♃ | ♀ |\n" "11" "$hour_night_11"
printf "%-2s - %-11s | ♃ | ♀ | ♄ | ☉ | ☽ | ♂ | ☿ |\n" "12" "$hour_night_12"
}


if [ "$MONDAY_MOON_" -eq 1 ]; then
    MONDAY_MOON
fi

if [ "$TUESDAY_MARS_" -eq 1 ]; then
    TUESDAY_MARS
fi

if [ "$WEDNESDAY_MERCURY_" -eq 1 ]; then
    WEDNESDAY_MERCURY
fi

if [ "$THURSDAY_JUPITER_" -eq 1 ]; then
    THURSDAY_JUPITER
fi

if [ "$FRIDAY_VENUS_" -eq 1 ]; then
    FRIDAY_VENUS
fi

if [ "$SATURDAY_SATURN_" -eq 1 ]; then
    SATURDAY_SATURN
fi

if [ "$SUNDAY_SUN_" -eq 1 ]; then
    SUNDAY_SUN
fi

if [ "$PLANETARY_HOURS_CHART_" -eq 1 ]; then
    PLANETARY_HOURS_CHART
fi
