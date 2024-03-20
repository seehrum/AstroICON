#!/bin/bash

# Configuration section: Enables or disables functionality for each day of the week and for the planetary hours chart.
# Set to 1 to enable or 0 to disable the functionality for the respective day or feature. 
#IMPORTANT (The day variables must not exceed line 15): this version of the program is automatic and uses sed to configure the variables according to the day of the week, it does not require manual configuration, only the sunrise, sunset and next sunrise times must be configured manually.
MONDAY_MOON_=0
TUESDAY_MARS_=0
WEDNESDAY_MERCURY_=0
THURSDAY_JUPITER_=0
FRIDAY_VENUS_=0
SATURDAY_SATURN_=0
SUNDAY_SUN_=0
PLANETARY_HOURS_CHART_=0

# The name defined by the FILE variable must be the same as the file name
FILE="AstroICON_v1.2A.sh"

# Variable to control the display of the current day's planet symbol.
DAY_OF_WEEK_=1

# Time configuration: Define sunrise and sunset times in 24-hour format.
HOUR_SUNRISE="06"
MINUTES_SUNRISE="11"
HOUR_SUNSET="18"
MINUTES_SUNSET="30"
HOUR_SUNRISE_OF_NEXT_DAY="06"
MINUTES_SUNRISE_OF_NEXT_DAY="11"

# Planet symbols: Assigns icons for each planet.
MOON="☽" 
MARS="♂" 
MERCURY="☿"
JUPITER="♃"
VENUS="♀"
SATURN="♄"
SUN="☉"

# always resets variables to 0
sed -i '1,15s/MONDAY_MOON_=1/MONDAY_MOON_=0/' "$FILE"
sed -i '1,15s/TUESDAY_MARS_=1/TUESDAY_MARS_=0/' "$FILE"
sed -i '1,15s/WEDNESDAY_MERCURY_=1/WEDNESDAY_MERCURY_=0/' "$FILE"
sed -i '1,15s/THURSDAY_JUPITER_=1/THURSDAY_JUPITER_=0/' "$FILE"
sed -i '1,15s/FRIDAY_VENUS_=1/FRIDAY_VENUS_=1/' "$FILE" 
sed -i '1,15s/SATURDAY_SATURN_=1/SATURDAY_SATURN_=0/' "$FILE"
sed -i '1,15s/SUNDAY_SUN_=1/SUNDAY_SUN_=0/' "$FILE"

# Conditional reset: Checks if any command-line argument is passed and resets the configuration.
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

# Total minutes in a day
TOTAL_MINUTES_IN_DAY=1440

# Convert sunrise and sunset times to total minutes from midnight
MINUTES_SUNRISE_TOTAL=$((HOUR_SUNRISE * 60 + MINUTES_SUNRISE))
MINUTES_SUNSET_TOTAL=$((HOUR_SUNSET * 60 + MINUTES_SUNSET))

# Calculate total daylight minutes
DAYLIGHT_MINUTES=$((MINUTES_SUNSET_TOTAL - MINUTES_SUNRISE_TOTAL))
# Calculate daylight period per hour
DAYLIGHT_PERIOD=$((DAYLIGHT_MINUTES / 12))

# Calculate total night minutes
# Note: This calculation assumes that the sunrise of the next day is the end of the night period
MINUTES_SUNRISE_NEXT_DAY_TOTAL=$((HOUR_SUNRISE_OF_NEXT_DAY * 60 + MINUTES_SUNRISE_OF_NEXT_DAY))
NIGHT_MINUTES=$((TOTAL_MINUTES_IN_DAY - MINUTES_SUNSET_TOTAL + MINUTES_SUNRISE_NEXT_DAY_TOTAL))
# Calculate night period per hour
NIGHT_PERIOD=$((NIGHT_MINUTES / 12))

# Calculate hourly intervals for the day period
hour_day_1=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + 0 minutes" +'%H:%M')

for i in {2..12}; do
  minutes_x=$(( "$DAYLIGHT_PERIOD" * ($i - 1) ))
  hour_day=$(date -d "$HOUR_SUNRISE:$MINUTES_SUNRISE today + ${minutes_x} minutes" +'%H:%M')
  eval "hour_day_$i='$hour_day'"
done

# Calculate hourly intervals for the night period
hour_night_1=$(date -d "$HOUR_SUNSET:$MINUTES_SUNSET today + 0 minutes" +'%H:%M')

for i in {2..12}; do
  minutes_nx=$(( "$NIGHT_PERIOD" * ($i - 1) ))
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

# Transition threshold: Determines when the day transitions to the next in terms of planetary influence.
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

# Assign the corresponding planet symbol to the current day.
# Use sed to set the variable corresponding to the current day to 1 within the first 15 lines
case $day_of_week in
    1) symbol="$MOON" ; sed -i '1,15s/MONDAY_MOON_=0/MONDAY_MOON_=1/' ;;
    2) symbol="$MARS" ; sed -i '1,15s/TUESDAY_MARS_=0/TUESDAY_MARS_=1/' "$FILE" ;;
    3) symbol="$MERCURY" ; sed -i '1,15s/WEDNESDAY_MERCURY_=0/WEDNESDAY_MERCURY_=1/' "$FILE" ;;
    4) symbol="$JUPITER" ; sed -i '1,15s/THURSDAY_JUPITER_=0/THURSDAY_JUPITER_=1/' "$FILE" ;;
    5) symbol="$VENUS" ; sed -i '1,15s/FRIDAY_VENUS_=0/FRIDAY_VENUS_=1/' "$FILE" ;;
    6) symbol="$SATURN" ; sed -i '1,15s/SATURDAY_SATURN_=0/SATURDAY_SATURN_=1/' "$FILE" ;;
    7) symbol="$SUN" ; sed -i '1,15s/SUNDAY_SUN_=0/SUNDAY_SUN_=1/' "$FILE" ;;
    *) symbol="Unknown" ;;
esac

# Print the symbol if DAY_OF_WEEK_ is enabled
if [ "$DAY_OF_WEEK_" -eq 1 ]; then
    echo -n "$symbol"
fi

# Get current time in HH:MM format
current_time=$(date +%H:%M)

# Function to check the current time against start and end times to determine the governing planet
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

# Day-specific functions: Define functions for each day to check and output planetary hours.
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

# displays planetary hours using parameters
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

# Check each variable and call the corresponding function if enabled
if [ "${MONDAY_MOON_}" -eq 1 ]; then MONDAY_MOON; fi
if [ "${TUESDAY_MARS_}" -eq 1 ]; then TUESDAY_MARS; fi
if [ "${WEDNESDAY_MERCURY_}" -eq 1 ]; then WEDNESDAY_MERCURY; fi
if [ "${THURSDAY_JUPITER_}" -eq 1 ]; then THURSDAY_JUPITER; fi
if [ "${FRIDAY_VENUS_}" -eq 1 ]; then FRIDAY_VENUS; fi
if [ "${SATURDAY_SATURN_}" -eq 1 ]; then SATURDAY_SATURN; fi
if [ "${SUNDAY_SUN_}" -eq 1 ]; then SUNDAY_SUN; fi
if [ "${PLANETARY_HOURS_CHART_}" -eq 1 ]; then PLANETARY_HOURS_CHART; fi
