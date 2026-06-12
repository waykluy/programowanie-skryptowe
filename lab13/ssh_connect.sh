#!/bin/bash
# Creating and clearing new file
touch ./ssh_output.txt
> ssh_output.txt
# Writing data
echo "Current user:" >> ssh_output.txt
# This command allows to execute command on ssh server
ssh -i ~/.ssh/localhost_key cbekali@localhost whoami >> ssh_output.txt
echo "Current path:" >> ssh_output.txt
ssh -i ~/.ssh/localhost_key cbekali@localhost pwd >> ssh_output.txt
echo "List of files/catalogs in current path:" >> ssh_output.txt
ssh -i ~/.ssh/localhost_key cbekali@localhost ls >> ssh_output.txt

