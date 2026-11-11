#!/usr/bin/env bash

OUTPUT_DIR="/var/www/html/viikko3"
TEMP_FILE="/tmp/index.html"

GENERATED_AT=$(date "+%Y-%m-%d %H:%M:%S %Z")
UPTIME_TEXT=$(uptime -p)

DISK_USAGE=$(df -P / | awk 'NR==2 {print $5}')
DISK_PERCENT=$(echo "$DISK_USAGE" | tr -d '%')

MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_AVAILABLE=$(free -m | awk '/Mem:/ {print $7}')

get_disk_status() {
    if [ "$1" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS=$(get_disk_status "$DISK_PERCENT")

GITHUB_URL="https://github.com/Joonatas/linux-viikko3"

cat > "$TEMP_FILE" <<EOF
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Week 3 Server Status</title>
</head>
<body>

<h1>Server Status Report</h1>

<p>Generated: $GENERATED_AT</p>

<p>Uptime: $UPTIME_TEXT</p>

<p>Disk usage: $DISK_USAGE</p>

<p>Disk status: $DISK_STATUS</p>

<p>Total RAM: $MEM_TOTAL MiB</p>

<p>Available RAM: $MEM_AVAILABLE MiB</p>

<h2>GitHub</h2>

<p><a href="$GITHUB_URL">View the source code on GitHub</a></p>

</body>
</html>
EOF

mv "$TEMP_FILE" "$OUTPUT_DIR/index.html"
