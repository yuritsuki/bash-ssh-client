#!/bin/bash


passphrase="your_passphrase"
ssh_key_path="/path/to/private/key"
declare -a hosts=(
    "Host 1:127.0.0.1" 
    "Host 2:127.0.0.2" 
    "Host 3:127.0.0.3" 
)


echo "Choose a host to connect:"
for index in "${!hosts[@]}"; do
    name=$(echo "${hosts[$index]}" | cut -d':' -f1)
    ip=$(echo "${hosts[$index]}" | cut -d':' -f2)
    echo "$index. $name ($ip)"
done

read -p "Enter the number of the host you want to connect to: " choice

if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -lt "${#hosts[@]}" ]; then
    selected_host=$(echo "${hosts[$choice]}" | cut -d':' -f2)
    name=$(echo "${hosts[$choice]}" | cut -d':' -f1)
    echo "Connecting to $name ($selected_host)..."
    ./expect.sh "$passphrase" "$ssh_key_path" "$selected_host"
else
    echo "Invalid choice. Please enter a valid number."
fi