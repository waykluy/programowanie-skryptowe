#Utworzenie katalogu docelowego, jesli nie istnieje
if ((Test-Path "c:\stuff\Study\Sem2PS\Lab7\PutHere") -eq $false){
    New-Item "c:\stuff\Study\Sem2PS\Lab7\PutHere" -ItemType Directory
}

#Utworzenie folderu źródłowego, jesli nie istnieje
if ((Test-Path "c:\stuff\Study\Sem2PS\Lab7\TakeHere") -eq $false){
    New-Item "c:\stuff\Study\Sem2PS\Lab7\TakeHere" -ItemType Directory
}

#Monitoruje określony folder za pomocą FileSystemWatcher
$watcher = New-Object System.IO.FileSystemWatcher "c:\stuff\Study\Sem2PS\Lab7\TakeHere" -Property @{
    IncludeSubdirectories = $false
    NotifyFilter = [System.IO.NotifyFilters]'FileName, LastWrite'
    Filter = "*.txt"
} 

#Rejestrujemy pojawienie się nowego pliku
Register-ObjectEvent -InputObject $watcher -EventName "Created" -Action {
    $sourcePath = $Event.SourceEventArgs.FullPath
    $destPath = "c:\stuff\Study\Sem2PS\Lab7\PutHere\$($Event.SourceEventArgs.Name)"

    Start-Sleep -Seconds 2
    
    #Przenosimy plik
    Move-Item -Path $sourcePath -Destination $destPath -Force
    Write-Host "Plik przeniesiony do PutHere: $($Event.SourceEventArgs.Name)"
    
    #WYWOŁANIE DRUGIEGO SKRYPTU
    #Znak '&' uruchamia zewnętrzny skrypt, a '-TargetFile' przekazuje mu nową ścieżkę do pliku
    & "c:\stuff\Study\Sem2PS\Lab7\Check-Virus.ps1" -TargetFile $destPath
}
#Skrypt działa ciągle
while ($true) {
    Start-Sleep -Seconds 2
}
