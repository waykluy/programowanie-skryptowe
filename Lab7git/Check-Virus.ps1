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

