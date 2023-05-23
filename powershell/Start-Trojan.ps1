# if already running, exit
Write-Output "Starting trojan..."
$processName = "trojan*"
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($null -ne $process) {
    Write-Host "Already running"
    Read-Host -Prompt "Press Enter to exit"
    exit 0
}

# set the path to the trojan
$trojanPath = "${env:PortableProgram}/trojan-cli"

# set working directory
Set-Location $trojanPath
# call start script
# & $trojanPath/start.bat
# start the trojan.exe in the background
Start-Process -FilePath $trojanPath/trojan.exe -WindowStyle Hidden

# log the start time
# append a new line
Write-Output "" | Out-File -FilePath $trojanPath/start.log -Append

$now = Get-Date
# trim empty lines before writing to file
$now | Out-File -FilePath $trojanPath/start.log -Append -NoNewline

# keep the window open
Read-Host -Prompt "Press Enter to exit"

exit 0