#!/bin/bash
# Creating test files to be sended
touch first.txt
echo "This is the first file" > first.txt
touch second.txt
echo "This is the second file" > second.txt
touch third.txt
echo "This is the third file" > third.txt
# Putting them into archive
tar -czf ftparchive.tar.gz first.txt second.txt third.txt
# Now sending
curl -T ftparchive.tar.gz ftp://localhost/ftparchive_copy.tar.gz --user cbekali:$FTP_PASS
