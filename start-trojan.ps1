# do not echo the commands
$VerbosePreference = "SilentlyContinue"

# get parameter trojan from command line
$trojan = $args[0]
# if no parameter trojan prompt for it
if ($null -eq $trojan) {
    # which trojan to start
    # prompt which to start
    Write-Output "Which trojan to start?"
    Write-Output "1. Trojan-CLI-Japan"
    Write-Output "2. Trojan-CLI-America"
    $trojan = Read-Host -Prompt "Enter number 1 or 2"
}

# set the path to the trojan
$basicPath = "C:/DevEnv/trojan-cli"


if ($trojan -eq "1") {
    $trojanPath = $basicPath
}
elseif ($trojan -eq "2") {
    $trojanPath = "$basicPath-america"
}
else {
    Write-Host "Invalid trojan number, Using Trojan-CLI-America"
    $trojanPath = "$basicPath-america"
    # exit
}

# set working directory
Set-Location $trojanPath
# call start script
& $trojanPath/start.bat

# keep the window open
# Read-Host -Prompt "Press Enter to exit"

exit 0