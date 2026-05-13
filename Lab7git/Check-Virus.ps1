<#
.SYNOPSIS
Skrypt antywirusowy weryfikujący bezpieczeństwo plików za pomocą API VirusTotal.

.DESCRIPTION
Skrypt oblicza sumę kontrolną (hash SHA256) wskazanego pliku, a następnie wysyła zapytanie 
do serwisu VirusTotal. Zwraca informację, czy plik jest bezpieczny, czy złośliwy (na podstawie oceny silników antywirusowych), 
oraz zapisuje wynik operacji do lokalnego pliku z logami (AntivirusLog.txt). 
Uwaga: Skrypt wymaga skonfigurowanej zmiennej środowiskowej o nazwie VIRUSTOTAL_API z poprawnym kluczem.

.PARAMETER TargetFile
Określa pełną ścieżkę do pliku, który ma zostać przeskanowany. Jeśli nie zostanie podana, skrypt spróbuje przeskanować plik domyślny (EICAR.txt).

.EXAMPLE
.\Check-Virus.ps1 -TargetFile "C:\stuff\Study\Sem2PS\Lab7\PutHere\moj_plik.txt"
Skanuje określony plik i dopisuje wynik do pliku AntivirusLog.txt.

.NOTES
Autor: Pavel Stankevich
Data: 30.04.2026
#>
param (
    [string]$TargetFile = "c:\stuff\Study\Sem2PS\Lab7\PutHere\EICAR.txt"
) #Domyślny plik
#Klucz API
$apiKey = $env:VIRUSTOTAL_API

#Ścieżka do naszego pliku z logami
$logFile = "c:\stuff\Study\Sem2PS\Lab7\AntivirusLog.txt"
$czas = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

#Obliczenie sumy kontrolnej
$fileHash = (Get-FileHash -Path $TargetFile -Algorithm SHA256).Hash

#Przygotowanie zapytania
$apiUrl = "https://www.virustotal.com/api/v3/files/$fileHash"
$headers = @{ "x-apikey" = $apiKey }

try {
    # Wysłanie zapytania
    $response = Invoke-RestMethod -Uri $apiUrl -Headers $headers -Method Get
    
    #Interpretacja
    $maliciousVotes = $response.data.attributes.last_analysis_stats.malicious

    if ($maliciousVotes -gt 0) {
        $raport = "[$czas] ZAGROŻENIE! Wykrycia: $maliciousVotes | Plik: $TargetFile"
        Write-Host $raport
        #Zapisujemy wynik do pliku
        Add-Content -Path $logFile -Value $raport
    } else {
        $raport = "[$czas] CZYSTY. Plik: $TargetFile"
        Write-Host $raport
        #Zapisujemy wynik do pliku
        Add-Content -Path $logFile -Value $raport
    }
}
catch {
    $raport = "[$czas] BRAK W BAZIE / ERROR 404. Plik: $TargetFile"
    Write-Host $raport
    #Zapisujemy wynik do pliku
    Add-Content -Path $logFile -Value $raport
}

