# if already running, exit
Write-Output "Starting trojan...."
$processName = "trojan*"
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($null -ne $process) {
    Write-Host "Already running"
    Read-Host -Prompt "Press Enter to exit"
    exit 0
}
# ask which one to start
# bitesme.vip
# or love2.vip
# prompt to select
$trojanName = Read-Host -Prompt "Which trojan to start? (1. bitesme.vip or 2. love2.vip)"
if ($trojanName -eq "1") {
    Write-Host "Using bitesme.vip"
    $trojanName = "bitesme.vip"
} elseif ($trojanName -eq "2") {
    Write-Host "Using love2.vip"
    $trojanName = "love2.vip"
} else {
    Write-Host "Invalid input"
    Write-Host "Using default: bitesme.vip"
    $trojanName = "bitesme.vip"
}

# set the path to the trojan
$trojanPath = "${env:PortableProgram}/trojan-cli-${trojanName}"

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