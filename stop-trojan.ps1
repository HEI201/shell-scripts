# do not echo the commands
$VerbosePreference = "SilentlyContinue"

# get the current running trojan and its folder
$trojanFilePath = Get-Process -Name trojan* | Select-Object -ExpandProperty Path
$trojanFolder = Split-Path $trojanFilePath -Resolve

# echo the info to the console
Write-Host "Current running trojan: " $trojanFolder

# set working directory
Set-Location $trojanFolder
# call start script
& $trojanFolder/stop.bat

# keep the window open
# Read-Host -Prompt "Press Enter to exit"

exit 0