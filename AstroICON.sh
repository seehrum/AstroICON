#!/bin/bash

# Default configuration - Modify these variables as needed
default_array_number=$(date +%u) # Dynamically select array based on the day of the week
default_start_position=0
default_time_x_minutes=1
default_time_y_minutes=2

# Function to display help
show_help() {
    echo "Usage: $0 [array number] [starting position] [time X in minutes] [time Y in minutes]"
    echo "Parameters (all are optional):"
    echo "  array number         - The array to start from (1 to 7, corresponding to days of the week)"
    echo "  starting position    - The position in the array to start from (0-23)"
    echo "  time X in minutes    - Time interval for characters 0-12"
    echo "  time Y in minutes    - Time interval for characters 13-23"
    echo
    echo "If no parameters are provided, the script will use default values."
    echo "Example: $0 1 0 61 58"
    echo "This starts the program with array [1-MONDAY], starting at position [0-☽], changing every 61 minutes for characters 0-12, and every 58 minutes for characters 13-23."
	echo "to calculate day and night hours, use: ./AstroICON.sh -c"
    exit 0 # Ensure the script exits after displaying the help
}

calc(){
#!/bin/bash
clear

read -ep "Hour sunrise: " hour_sunrise
read -ep "Minutes sunrise: " minutes_sunrise

read -ep "Hour sunset: " hour_sunset
read -ep "Minutes sunset: " minutes_sunset

read -ep "Hour sunrise of next day: " hour_sunrise_2
read -ep "Minutes sunrise of next day: " minutes_sunrise_2


# Constants
MINUTES_IN_DAY=1440
MINUTES_IN_HOUR=60

# Convert times to minutes
minutes_sunrise_total=$(echo "$hour_sunrise * $MINUTES_IN_HOUR + $minutes_sunrise" | bc)
minutes_sunset_total=$(echo "$hour_sunset * $MINUTES_IN_HOUR + $minutes_sunset" | bc)
minutes_sunrise_2_total=$(echo "$hour_sunrise_2 * $MINUTES_IN_HOUR + $minutes_sunrise_2" | bc)

clear

# Daytime calculation
daytime_minutes=$(echo "$minutes_sunset_total - $minutes_sunrise_total" | bc)
daytime_hours=$(echo "$daytime_minutes / 12" | bc)
# Nighttime calculation
nighttime_minutes=$(echo "$MINUTES_IN_DAY - $daytime_minutes" | bc)
nighttime_hours=$(echo "$nighttime_minutes / 12" | bc)
day_of_week=$(date +%u)

# Match the day of the week to its corresponding symbol
case $day_of_week in
    1) symbol="1-Monday - ☾" ;; # Monday
    2) symbol="2-Tuesday - ♂" ;; # Tuesday
    3) symbol="3-Wednesday - ☿" ;; # Wednesday & Friday
    4) symbol="4-Thursday - ♃" ;; # Thursday
    5) symbol="5-Friday - ☿" ;; # Wednesday & Friday
    6) symbol="6-Saturday - ♄" ;; # Saturday
    7) symbol="7-Sunday - ☉" ;; # Sunday
    *) symbol="Unknown" ;; # Just in case
esac

# Print the related character
echo "Today's planetary day: $symbol"

cat<<EOF
+------------------------------------------------------------------------------------------------------+
|Array icon positions:---------------------------------------------------------------------------------|
+------------------------------------------------------------------------------------------------------+
|------| 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 |10 |11 |12 |13 |14 |15 |16 |17 |18 |19 |20 |21 |22 |23 |
+------------------------------------------------------------------------------------------------------+
|1-MON | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ |
|2-TUES| ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ |
|3-WED | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ |
|4-THUR| ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ |
|5-FRI | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ |
|6-SAT | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ |
|7-SUN | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ | ☽ | ♄ | ♃ | ♂ | ☉ | ♀ | ☿ |
+------------------------------------------------------------------------------------------------------+
EOF
echo "Daytime hours: $daytime_hours"
echo "Nighttime hours: $nighttime_hours"
exit 0
}

# Check for -h parameter for help
if [[ $1 == "-h" ]]; then
    show_help
fi

# Check for -h parameter for help
if [[ $1 == "-c" ]]; then
    calc
fi


# Proceed to use parameters if provided, otherwise use default values
array_number=${1:-$default_array_number}
start_position=${2:-$default_start_position}
time_x_minutes=${3:-$default_time_x_minutes}
time_y_minutes=${4:-$default_time_y_minutes}

# Define arrays for each day
# MONDAY-1
characters_1=('☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃')
# TUESDAY-2
characters_2=('♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀')
# WEDNESDAY-3
characters_3=('☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄')
# THURSDAY-4
characters_4=('♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉')
# FRIDAY-5
characters_5=('♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽')
# SATURNDAY-6
characters_6=('♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂')
# SUNDAY-7
characters_7=('☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿' '☽' '♄' '♃' '♂' '☉' '♀' '☿')
# Define more character arrays for characters_3 to characters_7 as needed

# Mapping arrays to parameter input
declare -A day_to_array=( [1]=characters_1 [2]=characters_2 [3]=characters_3 [4]=characters_4 [5]=characters_5 [6]=characters_6 [7]=characters_7 )

# Loop through arrays after completing one
while true; do
    selected_array_name=${day_to_array[$array_number]}
    eval selected_array=( '"${'${selected_array_name}'[@]}"' )

    # Display and change characters
    current_position=$start_position
    while [ $current_position -lt ${#selected_array[@]} ]; do
        clear  # Clear the screen before displaying the new character
        echo "${selected_array[$current_position]}"
        # Determine sleep time based on current position
        if [ $current_position -lt 12 ]; then
            sleep $((time_x_minutes * 60)) # Sleep time X
        else
            sleep $((time_y_minutes * 60)) # Sleep time Y
        fi
        ((current_position++))
    done

    # Move to the next array
    ((array_number++))
    if [ $array_number -gt 7 ]; then
        array_number=1 # Reset to the first array if the end is reached
    fi
    start_position=0 # Reset starting position for the new array
done
