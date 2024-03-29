#!/bin/bash

# Enable (1) or Disable (0)

MONDAY_MOON_=0
TUESDAY_MARS_=0
WEDNESDAY_MERCURY_=0
THURSDAY_JUPITER_=1
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
    8) day_var="PLANETARY_HOURS_CHART_" 
        # Disables all variables
        MONDAY_MOON_=0
        TUESDAY_MARS_=0
        WEDNESDAY_MERCURY_=0
        THURSDAY_JUPITER_=0
        FRIDAY_VENUS_=0
        SATURDAY_SATURN_=0
        SUNDAY_SUN_=0
		DAY_OF_WEEK_=0
        ;;
    *)
      # If day_number was set but is not valid
      if [[ -n "$day_number" ]]; then
        echo "Invalid day number. Please provide a number from 1 to 8."
        exit 1
      fi
      ;;
esac


if [[ -n "$day_var" ]]; then
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

check_time() {
    # Converting hours to minutes since midnight for easier comparison
    local start_minutes=$((10#${1:0:2} * 60 + 10#${1:3:2}))
    local end_minutes=$((10#${2:0:2} * 60 + 10#${2:3:2}))
    local current_minutes=$((10#${current_time:0:2} * 60 + 10#${current_time:3:2}))

    # Handles the case of an interval that crosses midnight
    if [[ "$end_minutes" -le "$start_minutes" ]]; then
        # If the current time is before midnight and the interval ends after midnight
        if [[ "$current_minutes" -gt "$start_minutes" || "$current_minutes" -lt "$end_minutes" ]]; then
            echo -n "$3"
        fi
    else
        # Normal interval, which doesn't cross midnight
        if [[ "$current_minutes" -gt "$start_minutes" && "$current_minutes" -lt "$end_minutes" ]]; then
            echo -n "$3"
        fi
    fi
}



MONDAY_MOON(){
    # Defining the start times and the planets in arrays
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER")

    # Loop to call check_time for each pair of times and planets
    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo
}

TUESDAY_MARS() {
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS")

    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo
}

WEDNESDAY_MERCURY() {
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN")

    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo
}

THURSDAY_JUPITER() {
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN")

    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo
}

FRIDAY_VENUS() {
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON")

    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo
}


SATURDAY_SATURN() {
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS")

    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo
}

SUNDAY_SUN() {
    starts=("$start1" "$start2" "$start3" "$start4" "$start5" "$start6" "$start7" "$start8" "$start9" "$start10" "$start11" "$start12" "$start13" "$start14" "$start15" "$start16" "$start17" "$start18" "$start19" "$start20" "$start21" "$start22" "$start23" "$start24")
    planets=("$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY")


    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${planets[i]}"
    done

    echo

}

PLANETARY_HOURS_CHART(){
printf "     DAY-----------M---T---W---T---F---S---S--\n"
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
printf "%-2s   NIGHT---------M---T---W---T---F---S---S-|\n"
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

# Defining an associative array where the key is the variable name and the value is the corresponding function
declare -A day_functions=(
    ["MONDAY_MOON_"]=MONDAY_MOON
    ["TUESDAY_MARS_"]=TUESDAY_MARS
    ["WEDNESDAY_MERCURY_"]=WEDNESDAY_MERCURY
    ["THURSDAY_JUPITER_"]=THURSDAY_JUPITER
    ["FRIDAY_VENUS_"]=FRIDAY_VENUS
    ["SATURDAY_SATURN_"]=SATURDAY_SATURN
    ["SUNDAY_SUN_"]=SUNDAY_SUN
    ["PLANETARY_HOURS_CHART_"]=PLANETARY_HOURS_CHART
)

# Iterating over the array and executing the function if the corresponding variable is set to 1
for key in "${!day_functions[@]}"; do
    if [ "${!key}" -eq 1 ]; then
        "${day_functions[$key]}"
    fi
done
