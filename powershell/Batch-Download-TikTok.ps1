# get current directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Start-Process pwsh -ArgumentList "-File $scriptPath/Download-TikTok/Start-TikTok-Server.ps1" 

Start-Sleep -Seconds 3

Start-Process pwsh -ArgumentList "-File $scriptPath/Download-TikTok/Start-Download-TikTok.ps1"