# if already running, exit
$processName = "trojan*"
$process = Get-Process -Name $processName -ErrorAction SilentlyContinue
if ($null -ne $process) {
    # get the path of the process
    $processPath = $process.Path
    Write-Host "Trojan is already running at $processPath"
    Write-Host "exit ..."
    exit 0
}

# read the directory in ${env:PortableProgram}
# list the directories
$dirs = Get-ChildItem -Path ${env:PortableProgram} -Directory
# filter the directories with trojan-cli
$dirs = $dirs | Where-Object { $_.Name -like "trojan-cli*" }
# if no directory found, exit
if ($null -eq $dirs) {
    Write-Host "No trojan-cli directory found"
    Write-Host "exit ..."
    exit 0
}

# ask which one to start
# prompt to select
Write-Host "Select the trojan-cli directory to start"
$index = 1
foreach ($dir in $dirs) {
    Write-Host "$index. $dir"
    $index++
}
$selection = Read-Host -Prompt "Enter the number"
$selection = [int]$selection
if ($selection -lt 1 -or $selection -gt $dirs.Length) {
    Write-Host "Invalid selection"
    # default to the first one
    $selection = 1
}

# set the path to the selected directory
$selectedTrojanFolder = $dirs[$selection - 1].Name
Write-Host "Starting ${selectedTrojanFolder} ..."
$trojanPath = "${env:PortableProgram}/${selectedTrojanFolder}"

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