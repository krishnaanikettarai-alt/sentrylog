# SentryLog – Security Journal Analyzer

> A Bash-based security log analysis tool for Red Hat Enterprise Linux.

---

## 📌 Overview

**SentryLog** is a lightweight security log analysis tool developed using Bash scripting on **Red Hat Enterprise Linux**.

It analyzes the Linux system journal using `journalctl` and identifies important security-related events such as:

- Failed authentication attempts
- Suspicious source addresses
- Affected users
- Service failures
- Error-level journal entries
- Threat severity
- Recommended security actions

The tool generates a readable security analysis report and stores it in the project's `reports/` directory.

---

## ✨ Features

- Detects failed authentication attempts
- Analyzes authentication sources
- Identifies suspicious source addresses
- Performs user-based analysis
- Detects failed system services
- Analyzes ERROR-level and higher-priority journal entries
- Calculates threat severity
- Provides recommended security actions
- Generates timestamped security reports
- Uses Linux `journalctl` for real-time journal analysis
- Can be executed manually or through a systemd service

---

## 📁 Project Structure

```text
sentrylog/
│
├── README.md
│
├── scripts/
│   └── sentrylog.sh
│
└── reports/
    ├── sentrylog_report.txt
    └── sentrylog_report_2026-08-30.txt



⚙️ Requirements

The project requires:

Red Hat Enterprise Linux 10
Bash
systemd
journalctl
Appropriate permissions to read the system journal



🚀 Installation & Setup

Clone the repository:

git clone https://github.com/krishnaanikettarai-alt/sentrylog.git

Enter the project directory:

cd sentrylog

Make the script executable:

chmod +x scripts/sentrylog.sh



▶️ Running SentryLog

Run the analyzer using:

./scripts/sentrylog.sh

If elevated permissions are required:

sudo ./scripts/sentrylog.sh

The analyzer displays the results directly in the terminal.

A report is also generated inside:

reports/
🔍 Analysis Performed
1. Failed Authentication Analysis

SentryLog searches the system journal for authentication failures.

It reports:

Total authentication failures
Time of the events
Affected users
Source addresses
Authentication-related journal messages

Example:

Failed Authentication Attempts
--------------------------------

Authentication failures detected: 21
2. Source IP Analysis

The tool analyzes the source addresses associated with authentication failures.

Example:

Source IP Analysis
--------------------------------

Attempts by source:

9 ::1

This allows repeated authentication attempts from the same source to be identified.

3. Suspicious Source Detection

Sources generating repeated authentication failures can be flagged as suspicious.

Example:

Suspicious Source Detection
--------------------------------

[SUSPICIOUS] ::1 - 9 failed attempts

This helps administrators identify sources that may require further investigation.

4. User Analysis

SentryLog identifies users associated with authentication failures.

Example:

User Analysis
--------------------------------

18 katarai

This provides a quick overview of which accounts are experiencing authentication failures.

5. Service Failure Analysis

The tool searches the system journal for failed services and systemd-related errors.

Example events may include:

Failed to start service
Main process exited
Failed with result 'exit-code'
Dependency failed

This helps identify services that may require administrative attention.

6. Priority Error Analysis

SentryLog analyzes journal entries with ERROR priority or higher.

This can reveal:

Kernel errors
Driver warnings
Failed services
Hardware-related issues
System-level errors

Example:

Priority ERR or Above
--------------------------------

Priority error-level entries detected: 24
7. Threat Severity Analysis

The analyzer determines a threat severity level based on the number of authentication failures.

Possible severity levels include:

LOW
MEDIUM
HIGH
CRITICAL

Example:

Threat Severity Analysis
--------------------------------

Failure Count: 21
Severity: CRITICAL

Message: High number of authentication failures detected.
8. Final Security Status

The analyzer provides a final security status based on the detected events.

Example:

Final Status
--------------------------------

Status: CRITICAL
9. Recommended Actions

SentryLog provides recommended actions based on the analysis.

Example:

Recommended Actions
--------------------------------

1. Review the failed authentication attempts.
2. Investigate the source IP addresses.
3. Check whether the targeted user accounts are legitimate.
4. Consider using SSH public-key authentication.
5. Monitor the system for repeated authentication failures.


📊 Example Output

A typical SentryLog analysis may look like:

========================================
        SENTRYLOG SECURITY ANALYZER
========================================

Analysis Time: Sunday 30 August 2026

Analyzing journal for security events...

----------------------------------------
Failed Authentication Attempts
----------------------------------------

[!] Authentication failures detected: 21

----------------------------------------
Source IP Analysis
----------------------------------------

Attempts by source:

9 ::1

----------------------------------------
Suspicious Source Detection
----------------------------------------

[SUSPICIOUS] ::1 - 9 failed attempts

----------------------------------------
User Analysis
----------------------------------------

18 katarai

----------------------------------------
Threat Severity Analysis
----------------------------------------

Failure Count: 21
Severity: CRITICAL

Message: High number of authentication failures detected.

----------------------------------------
Final Status
----------------------------------------

Status: CRITICAL

----------------------------------------
Recommended Actions
----------------------------------------

1. Review the failed authentication attempts.
2. Investigate the source IP addresses.
3. Check whether the targeted user accounts are legitimate.
4. Consider using SSH public-key authentication.
5. Monitor the system for repeated authentication failures.


📄 Generated Reports

SentryLog automatically saves analysis reports in:

reports/

Example:

reports/sentrylog_report_2026-08-30.txt

The reports can be used for:

Security review
System administration
Troubleshooting
Documentation
Demonstration purposes



🛠️ Technologies Used

Technology	Purpose
Bash	Main scripting language
Red Hat Enterprise Linux 10	Operating system
journalctl	System journal analysis
systemd	Service and journal management
Git	Version control
GitHub	Project hosting


🔐 Security Purpose

SentryLog provides a simple way to analyze important security-related events recorded by the Linux system journal.

It can help administrators quickly identify:

Repeated authentication failures
Potentially suspicious sources
Accounts experiencing authentication problems
Failed system services
Important system errors

The project is intended as a lightweight educational and administrative security-analysis tool.

It does not replace professional Security Information and Event Management (SIEM) systems.


🎯 Project Objectives

The main objectives of SentryLog are:

To understand Linux system logging.
To work with journalctl and systemd journals.
To automate security-log analysis using Bash.
To identify authentication failures.
To analyze suspicious sources and affected users.
To detect service and system errors.
To generate automated security reports.
To practice Linux administration and shell scripting.


📌 Future Improvements

Possible future improvements include:

Email notifications for critical events
Automatic IP blocking
Configurable severity thresholds
CSV/JSON report generation
Web-based dashboard
Graphical statistics
Integration with monitoring systems
Automated periodic analysis
Improved detection of brute-force attacks


👨💻 Author

Krishna Aniket Tarai

📜 License

This project is intended for educational and administrative use.
