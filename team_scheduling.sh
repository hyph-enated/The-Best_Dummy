#!/bin/bash

json_file="data.json"

# Ensure JSON file exists
if [ ! -s "$json_file" ]; then
  echo "[]" > "$json_file"
fi

# Append to JSON
add_to_json() {
  local name="$1"
  local shift="$2"
  local team="$3"

  local entry
  entry=$(jq -n \
    --arg name "$name" \
    --arg shift "$shift" \
    --arg team "$team" \
    '{name: $name, shift: $shift, team: $team}')

  jq ". += [$entry]" "$json_file" > tmp.json && mv tmp.json "$json_file"
}

# Print Output Table
print_table() {
  echo
  echo "|-------|------------|-----------------|"
  printf "| %-5s | %-10s | %-15s |\n" "Team" "Shift" "Employees"
  echo "|-------|------------|-----------------|"

  jq -r '
    group_by(.team + "-" + .shift) |
    .[] |
    {
      team: .[0].team,
      shift: .[0].shift,
      employees: (map(.name) | join(", "))
    } |
    [ .team, .shift, .employees ] |
    @tsv
  ' "$json_file" | while IFS=$'\t' read -r team shift employees; do
    printf "| %-5s | %-10s | %-15s |\n" "$team" "$shift" "$employees"
  done

  echo "|-------|------------|-----------------|"
}

# Main input loop
while true; do
  read -p "Enter Employee Name: " name

  if [[ "$name" == "print" ]]; then
    print_table
    exit 0
  fi

  read -p "Enter Shift (morning, mid, night): " shift
  read -p "Enter Team (a1, a2, a3, b1, b2, b3): " team

  # Count how many people already have that team-shift
  current_count=$(jq -r --arg team "$team" --arg shift "$shift" \
    '[.[] | select(.team == $team and .shift == $shift)] | length' "$json_file")

  if (( current_count >= 2 )); then
    echo "Maximum employees per shift in team $team reached. Exiting..."
    exit 1
  fi

  # Append new employee to JSON
  add_to_json "$name" "$shift" "$team"
done
