#!/bin/bash

# SentryLog - Security Journal Analyzer

REPORT_DIR="$HOME/sentrylog/reports"
REPORT_FILE="$REPORT_DIR/sentrylog_report_$(date +%Y-%m-%d).txt"

mkdir -p "$REPORT_DIR"

{
echo "============================================"
echo "        SENTRYLOG SECURITY ANALYZER"
echo "============================================"
echo
echo "Analysis Time: $(date)"
echo
echo "Analyzing journal for security events..."
echo

# ============================================================
# 1. FAILED AUTHENTICATION ATTEMPTS
# ============================================================

echo "--------------------------------------------"
echo "Failed Authentication Attempts"
echo "--------------------------------------------"

FAILURES=$(journalctl -b --no-pager | grep -Ei \
'Failed password|authentication failure|Failed publickey')

COUNT=$(echo "$FAILURES" | grep -c .)

echo
echo "[!] Authentication failures detected: $COUNT"
echo

if [ "$COUNT" -gt 0 ]; then
    echo "$FAILURES"
else
    echo "No authentication failures detected."
fi

# ============================================================
# 2. SERVICE FAILURES
# ============================================================

echo
echo "--------------------------------------------"
echo "Service Failures"
echo "--------------------------------------------"

SERVICE_FAILURES=$(journalctl -b --no-pager | grep -Ei \
'systemd.*(failed|failure)|Failed to start|failed with result')

SERVICE_COUNT=$(echo "$SERVICE_FAILURES" | grep -c .)

echo
echo "Service failures detected: $SERVICE_COUNT"
echo

if [ "$SERVICE_COUNT" -gt 0 ]; then
    echo "$SERVICE_FAILURES"
else
    echo "No service failures detected."
fi

# ============================================================
# 3. PRIORITY ERR OR ABOVE
# ============================================================

echo
echo "--------------------------------------------"
echo "Priority ERR or Above"
echo "--------------------------------------------"

PRIORITY_ERRORS=$(journalctl -b -p err..emerg --no-pager)

PRIORITY_COUNT=$(echo "$PRIORITY_ERRORS" | grep -c .)

echo
echo "Priority error-level entries detected: $PRIORITY_COUNT"
echo

if [ "$PRIORITY_COUNT" -gt 0 ]; then
    echo "$PRIORITY_ERRORS"
else
    echo "No priority ERR or above entries detected."
fi

# ============================================================
# 4. SOURCE IP ANALYSIS
# ============================================================

echo
echo "--------------------------------------------"
echo "Source IP Analysis"
echo "--------------------------------------------"

echo
echo "Attempts by source:"

IP_ADDRESSES=$(echo "$FAILURES" | \
grep -oE 'from [^ ]+' | \
awk '{print $2}' | \
sort | uniq -c)

if [ -n "$IP_ADDRESSES" ]; then
    echo "$IP_ADDRESSES"
else
    echo "No source IP addresses found."
fi

# ============================================================
# 5. SUSPICIOUS SOURCE DETECTION
# ============================================================

echo
echo "--------------------------------------------"
echo "Suspicious Source Detection"
echo "--------------------------------------------"

FOUND_SUSPICIOUS=0

if [ -n "$IP_ADDRESSES" ]; then

    while read -r ATTEMPTS IP; do

        if [ "$ATTEMPTS" -gt 5 ]; then
            echo "[SUSPICIOUS] $IP - $ATTEMPTS failed attempts"
            FOUND_SUSPICIOUS=1
        fi

    done <<< "$IP_ADDRESSES"

fi

if [ "$FOUND_SUSPICIOUS" -eq 0 ]; then
    echo "No suspicious sources detected."
fi

# ============================================================
# 6. USER ANALYSIS
# ============================================================

echo
echo "--------------------------------------------"
echo "User Analysis"
echo "--------------------------------------------"

# Extract usernames from:
#   user=<username>
#   Failed password for <username>

USERS=$(echo "$FAILURES" | \
grep -oE 'user=[a-zA-Z0-9._-]+' | \
sed 's/^user=//' )

FAILED_USERS=$(echo "$FAILURES" | \
grep -oE 'Failed password for [a-zA-Z0-9._-]+' | \
awk '{print $4}')

ALL_USERS=$(printf "%s\n%s\n" "$USERS" "$FAILED_USERS" | \
grep -E '^[a-zA-Z0-9._-]+$' | \
sort | uniq -c)

if [ -n "$ALL_USERS" ]; then
    echo "$ALL_USERS"
else
    echo "No users found."
fi

# ============================================================
# 7. THREAT SEVERITY ANALYSIS
# ============================================================

echo
echo "--------------------------------------------"
echo "Threat Severity Analysis"
echo "--------------------------------------------"

echo "Failure Count: $COUNT"

if [ "$COUNT" -eq 0 ]; then

    SEVERITY="LOW"
    MESSAGE="No authentication failures detected."

elif [ "$COUNT" -lt 5 ]; then

    SEVERITY="LOW"
    MESSAGE="Small number of authentication failures detected."

elif [ "$COUNT" -lt 10 ]; then

    SEVERITY="WARNING"
    MESSAGE="Multiple authentication failures detected."

else

    SEVERITY="CRITICAL"
    MESSAGE="High number of authentication failures detected."

fi

echo "Severity: $SEVERITY"
echo "Message: $MESSAGE"

# ============================================================
# 8. FINAL STATUS
# ============================================================

echo
echo "--------------------------------------------"
echo "Final Status"
echo "--------------------------------------------"

if [ "$SEVERITY" = "CRITICAL" ]; then

    echo "Status: CRITICAL"

elif [ "$SEVERITY" = "WARNING" ]; then

    echo "Status: WARNING"

else

    echo "Status: SYSTEM CLEAN"

fi

# ============================================================
# 9. RECOMMENDED ACTIONS
# ============================================================

echo
echo "--------------------------------------------"
echo "Recommended Actions"
echo "--------------------------------------------"

if [ "$COUNT" -eq 0 ]; then

    echo "No immediate action required."

elif [ "$COUNT" -lt 5 ]; then

    echo "1. Review the failed authentication attempts."
    echo "2. Verify that the attempts were legitimate."

else

    echo "1. Review the failed authentication attempts."
    echo "2. Investigate the source IP addresses."
    echo "3. Check whether the targeted user accounts are legitimate."
    echo "4. Consider using SSH public-key authentication."
    echo "5. Monitor the system for repeated authentication failures."

fi

# ============================================================
# 10. COMPLETION
# ============================================================

echo
echo "============================================"
echo "Analysis complete."
echo "Report saved to: $REPORT_FILE"
echo "============================================"

} | tee "$REPORT_FILE"
