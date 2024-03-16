#!/bin/bash

# Configuration to enable (1) or disable (0) specific day's functionality
MONDAY_MOON_="0"
TUESDAY_MARS_="0"
WEDNESDAY_MERCURY_="0"
THURSDAY_JUPITER_="0"
FRIDAY_VENUS_="1"
SATURDAY_SATURN_="0"
SUNDAY_SUN_="0"
PLANETARY_HOURS_CHART_="0"

DAY_OF_WEEK_="1"

# Sunrise and sunset time configuration in 24-hour format
HOUR_SUNRISE="06"
MINUTES_SUNRISE="11"
HOUR_SUNSET="18"
MINUTES_SUNSET="30"
HOUR_SUNRISE_OF_NEXT_DAY="06"
MINUTES_SUNRISE_OF_NEXT_DAY="11"

# Icons for planets
MOON="☽" 
MARS="♂" 
MERCURY="☿"
JUPITER="♃"
VENUS="♀"
SATURN="♄"
SUN="☉"

# Reset all day variables if a parameter is passed
if [[ $# -gt 0 ]]; then
    MONDAY_MOON_=0
    TUESDAY_MARS_=0
    WEDNESDAY_MERCURY_=0
    THURSDAY_JUPITER_=0
    FRIDAY_VENUS_=0
    SATURDAY_SATURN_=0
    SUNDAY_SUN_=0
    PLANETARY_HOURS_CHART_=0
    DAY_OF_WEEK_=0
fi

day_number="$1"

# Set variable for the specific day
case $day_number in
    1) echo -n "$MOON" ; day_var="MONDAY_MOON_" ;;
    2) echo -n "$MARS" ; day_var="TUESDAY_MARS_" ;;
    3) echo -n "$MERCURY" ; day_var="WEDNESDAY_MERCURY_" ;;
    4) echo -n "$JUPITER" ; day_var="THURSDAY_JUPITER_" ;;
    5) echo -n "$VENUS" ; day_var="FRIDAY_VENUS_" ;;
    6) echo -n "$SATURN" ; day_var="SATURDAY_SATURN_" ;;
    7) echo -n "$SUN" ; day_var="SUNDAY_SUN_" ;;
    8) day_var="PLANETARY_HOURS_CHART_"  ;;
	*)
      # If day_number was set but is not valid
      if [[ -n "$day_number" ]]; then
        echo "Invalid day number. Please provide a number from 1 to 8."
        exit 1
      fi
esac

# Activate the selected day's variable
if [[ -n "$day_var" ]]; then
  declare "$day_var=1"
fi

# Threshold time for day transition
# TRANSITION_THRESHOLD defines the time at which the day transitions to the next planetary day.
# This is set to the sunrise time of the current day. The script uses this threshold to determine
# if the current time (NOW_TIME) is before sunrise, which indicates that the planetary influence
# still belongs to the previous day. For example, if it is currently 5:00 AM and sunrise is at 6:11 AM,
# the planetary day is considered to be the one from the day before. This adjustment ensures
# the correct planetary day and hours are calculated based on the natural cycle of sunrise and sunset,
# aligning the script's output with traditional astrological practices.
TRANSITION_THRESHOLD="$HOUR_SUNRISE:$MINUTES_SUNRISE"

# Get current time
NOW_TIME=$(date +%H:%M)

# Calculate current day of the week (1 is Monday, 7 is Sunday)
CURRENT_WEEKDAY=$(date +%u)

# Adjust current day based on the time threshold
if [[ "$NOW_TIME" < "$TRANSITION_THRESHOLD" ]]; then
  if [[ "$CURRENT_WEEKDAY" -eq 1 ]]; then
    CURRENT_WEEKDAY=7
  else
    CURRENT_WEEKDAY=$((CURRENT_WEEKDAY - 1))
  fi
fi

day_of_week="$CURRENT_WEEKDAY"

# Assign planet symbol to current day
case $day_of_week in
    1) symbol="$MOON" ;;
    2) symbol="$MARS" ;;
    3) symbol="$MERCURY" ;;
    4) symbol="$JUPITER" ;;
    5) symbol="$VENUS" ;;
    6) symbol="$SATURN" ;;
    7) symbol="$SUN" ;;
    *) symbol="Unknown" ;;
esac

# Print the symbol if DAY_OF_WEEK_ is enabled
if [ "$DAY_OF_WEEK_" -eq 1 ]; then
    echo -n "$symbol"
fi

# Total minutes in a day
TOTAL_MINUTES_IN_DAY="1440"

# Day period calculations
SUM_1=$(echo "$HOUR_SUNRISE * 60" | bc)  # Convert sunrise hour to minutes
SUM_2=$(echo "$SUM_1 + $MINUTES_SUNRISE" | bc)  # Add sunrise minutes
SUM_3=$(echo "$HOUR_SUNSET * 60" | bc)  # Convert sunset hour to minutes
SUM_4=$(echo "$SUM_3 + $MINUTES_SUNSET" | bc)  # Add sunset minutes
SUM_5=$(echo "$SUM_4 - $SUM_2" | bc)  # Calculate total daylight minutes
DAYLIGHT_PERIOD=$(echo "$SUM_5 / 12" | bc)  # Divide by 12 for the daylight period per hour

# Night period calculations
SUM_7=$(echo "$HOUR_SUNRISE_OF_NEXT_DAY * 60" | bc)
SUM_8=$(echo "$SUM_7 + $MINUTES_SUNRISE_OF_NEXT_DAY" | bc)
SUM_9=$(echo "$SUM_4 - $SUM_8" | bc)
SUM_10=$(echo "$TOTAL_MINUTES_IN_DAY - $SUM_9" | bc)
NIGHT_PERIOD=$(echo "$SUM_10 / 12" | bc)  # Night period per hour

# Calculate hourly intervals for the day period
hour_day_1=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + 0 minutes" +'%H:%M')

for i in {2..12}; do
  minutes_x=$(echo "$DAYLIGHT_PERIOD * ($i - 1)" | bc)
  hour_day=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + ${minutes_x} minutes" +'%H:%M')
  eval "hour_day_$i='$hour_day'"
done

# Calculate hourly intervals for the night period
hour_night_1=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + 0 minutes" +'%H:%M')

for i in {2..12}; do
  minutes_nx=$(echo "$NIGHT_PERIOD * ($i - 1)" | bc)
  hour_night=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + ${minutes_nx} minutes" +'%H:%M')
  eval "hour_night_$i='$hour_night'"
done

# Assign calculated hours to variables start1 through start24
for i in {1..24}; do
  if [ "$i" -le 12 ]; then
    eval "start$i=\$hour_day_$i"
  else
    j=$((i - 12))  # Adjust index for night hours
    eval "start$i=\$hour_night_$j"
  fi
done

# Function to check the current time against start and end times to determine the governing planet
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


# Define functions for each day to check planetary hours
# Function to check planetary hours for a given day
check_planetary_hours() {
    local day_planets=("$@")  # Receives the planets for the specific day
    local starts=(
        "$start1" "$start2" "$start3" "$start4" "$start5" "$start6" 
        "$start7" "$start8" "$start9" "$start10" "$start11" "$start12"
        "$start13" "$start14" "$start15" "$start16" "$start17" "$start18"
        "$start19" "$start20" "$start21" "$start22" "$start23" "$start24"
    )

    # Loop through each time slot and check the planetary hour
    for ((i = 0; i < ${#starts[@]}; i++)); do
        next_index=$(( (i + 1 ) % ${#starts[@]} ))
        check_time "${starts[i]}" "${starts[next_index]}" "${day_planets[i]}"
    done

    echo
}

# Define planetary hours for each day of the week

MONDAY_MOON() {
    check_planetary_hours "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" \
                          "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" \
                          "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" \
                          "$MOON" "$SATURN" "$JUPITER"
}

TUESDAY_MARS() {
    check_planetary_hours "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" \
                          "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" \
                          "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" \
                          "$MARS" "$SUN" "$VENUS"
}

WEDNESDAY_MERCURY() {
    check_planetary_hours "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" \
                          "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" \
                          "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" \
                          "$MERCURY" "$MOON" "$SATURN"
}

THURSDAY_JUPITER() {
    check_planetary_hours "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" \
                          "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" \
                          "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" \
                          "$JUPITER" "$MARS" "$SUN"
}

FRIDAY_VENUS() {
    check_planetary_hours "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" \
                          "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" \
                          "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" "$SUN" \
                          "$VENUS" "$MERCURY" "$MOON"
}

SATURDAY_SATURN() {
    check_planetary_hours "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" \
                          "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" \
                          "$SATURN" "$JUPITER" "$MARS" "$SUN" "$VENUS" "$MERCURY" "$MOON" \
                          "$SATURN" "$JUPITER" "$MARS"
}

SUNDAY_SUN() {
    check_planetary_hours "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" \
                          "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" \
                          "$SUN" "$VENUS" "$MERCURY" "$MOON" "$SATURN" "$JUPITER" "$MARS" \
                          "$SUN" "$VENUS" "$MERCURY"
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

# Associative array to map day variables to their functions
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

# Execute the function associated with the enabled day variable
for key in "${!day_functions[@]}"; do
    if [ "${!key}" -eq 1 ]; then
        "${day_functions[$key]}"
    fi
done
