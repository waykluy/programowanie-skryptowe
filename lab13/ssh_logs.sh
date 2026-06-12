#!/bin/bash
# Collecting logs
logs=$(sudo journalctl -u ssh | grep -i "invalid\|failed\|denied")
# Creating output file
touch logs_output.txt
# Clearing output file
> logs_output.txt
# Writing data
date >> logs_output.txt
echo "Number of suspicious logs: " >> logs_output.txt
echo "${logs}" | wc -l >> logs_output.txt
echo "Logs: " >> logs_output.txt
# Using "${logs}" indtead of ${logs} keeps new lines separated so they won't stick together
echo "${logs}" >> logs_output.txt
