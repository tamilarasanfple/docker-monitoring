#!/bin/bash

# Function to check disk space
check_disk_space() {
    # Get available disk space in percentage
    disk_space=$(df -h / | awk 'NR==2 {print $5}' | cut -d'%' -f1)

    # Threshold for disk space utilization
    threshold=85  # Adjust as needed

    # Check if disk space exceeds the threshold
    if [ "$disk_space" -ge "$threshold" ]; then
        return 1  # Disk space is critically low
    else
        return 0  # Disk space is normal
    fi
}

# Function to send Telegram notification
send_telegram_alert() {
    BOT_TOKEN="8191656006:AAGjBZTVgSsyjK_Gof8kSDlWVctAiUf7o-4"  # Replace with your bot token
    CHAT_ID="-4781658793"  # Replace with your chat ID
    SERVER_IP=$(curl -s icanhazip.com)  # Get first IP address

MESSAGE="⚠️ *CRITICAL DISK SPACE ALERT* ⚠️

📌 *Server:* $(hostname)
🌐 *IP Address:* $SERVER_IP
💾 *Used Disk Space:* ${disk_space}%

🚨 *Disk space usage has exceeded the critical limit!* Immediate action required!"

    # Sending message using Telegram API
    response=$(curl -s -X POST "https://api.telegram.org/bot$BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE" \
        -d parse_mode="Markdown")

    if [[ $response == *"true"* ]]; then
        echo "Telegram alert sent successfully."
    else
        echo "Failed to send Telegram alert."
        echo "Response: $response"
    fi
}

# Main script execution
check_disk_space
if [ $? -eq 1 ]; then
    send_telegram_alert
fi
