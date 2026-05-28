#!/bin/bash
read -p "Please enter input file path: " path
echo "It will be encrypted and saved to \"./encrypted_output.txt\"."
echo "Please, don't forget your encryption password, otherwise your secured data will be lost!"
touch ./encrypted_output.txt
# Password-based key derivation function 2 is used to securely turn a password into a cryptographic key.
# I used openssl ultility with aes-256-cbc flag to encrypt the file.
# The rest of the commands is simple and doesn't need to be explained.
openssl aes-256-cbc -pbkdf2 -in ${path} -out encrypted_output.txt
echo "Done."
