# $VerbosePreference = 'SilentlyContinue'
$folder = $PWD
Start-Process "${env:LOCALAPPDATA}\Programs\Microsoft VS Code\Code.exe" -ArgumentList $folder

# exit 0
# Read-Host -Prompt "Press Enter to exit"

# sleep for 2 second to wait for VS Code to start
Start-Sleep -s 2
