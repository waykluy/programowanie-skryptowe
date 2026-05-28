#!/bin/bash
read -p "Please enter the file path: " path
openssl dgst -sha256 -sign example-key.pem -out signature.bin ${path}
