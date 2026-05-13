import requests
import socket

#Getting ip address from user
host = input("Enter ip address or hostname: ")

#If we got the hostname, creating ip address from it
ip = socket.gethostbyname(host)

#Creating the request url
url = f"https://internetdb.shodan.io/{ip}"

#Getting the response
response = requests.get(url)

#Printing status
print("Status:", response.status_code)

#If there is no error
if response.status_code == 200:
    #Transforming data into json
    data = response.json()

    #Writing out basic info (ip, hostname(-s if many), vulnerability(-s if many)
    print(f"IP: {data['ip']}")
    hostnm = "Hostname(s): "
    for name in data['hostnames']:
        hostnm += name
    print(hostnm)
    vulnerabilities = "Vulnerabilities: "
    for name in data['vulns']:
        vulnerabilities += name
    if (data['vulns'] == []):
        vulnerabilities += "None"
    print(vulnerabilities)
    #Writing out info about every open port
    for port in data['ports']:
        print(f"{port} is open")

#Handling errors
else:
    print(f"Error message: {response.text}")