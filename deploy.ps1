# deploy the packed app in dist folder to a linux server
# run this script from the root of the project
# if posh-ssh module is not installed, run the following command in powershell
# Install-Module -Name Posh-SSH

# import posh-ssh module
Import-Module posh-ssh

# echo all logs to the console
$VerbosePreference = "Continue"

$serverHost = "10.1.3.4"
$serverPort = 22
$sereverUser = "lyk"
$serverPassword = "123456"

$projectDir = 'C:\Users\zlcx\code\device_platform'
# set working directory
Set-Location -Path $projectDir
# echo pwd
Write-Output "Working directory: $(Get-Location)"

# get file name from package.json
$package = Get-Content -Path "package.json" -Raw | ConvertFrom-Json
$fileName = $package.name + "-v" + $package.version + ".tar.gz"
# file path
$filePath = ".\dist\" + $fileName
# absolute file path
$filePath = Resolve-Path -Path $filePath
# echo file path
Write-Output "File path: $filePath"


$secpasswd = ConvertTo-SecureString $serverPassword -AsPlainText -Force
$Credentials = New-Object System.Management.Automation.PSCredential($sereverUser, $secpasswd)

# upload file to the server via scp using password $serverPassword
Write-Output "Uploading file to the server..."
$session = New-SFTPSession -ComputerName $serverHost -Credential $Credentials -Port $serverPort -OperationTimeout 20000
Set-SFTPItem -SessionId $session.sessionid -Path $filePath -Destination "/home/$sereverUser" -Force
Write-Output "Upload complete."

# connect to the server via ssh using password
Write-Output "Connecting to the server..."
# decompress the file
# tar -xzvf $fileName
Write-Output "Decompressing file..."
$Command = "tar -xzvf $fileName"
# $Command = "echo 'hello f**k' > test.txt"
$SessionID = New-SSHSession -ComputerName $serverHost -Credential $Credentials #Connect Over SSH
Invoke-SSHCommand -Index $SessionID.sessionid -Command $Command # Invoke Command Over SSH
Write-Output "Decompress complete."
# exit ssh
Read-Host -Prompt "Press any key to exit..."