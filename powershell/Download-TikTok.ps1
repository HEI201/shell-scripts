# usage:
# start server.bat in a terminal
# start this script in another terminal
# can only download single video links, not playlists
Import-Module -Name PsIni

$downloaderPath = "D:\Video\tiktok\downloader"
# add downloader path to PATH
$env:PATH += ";$downloaderPath"

# Map the network drive
# New-PSDrive -Name $driverName -PSProvider FileSystem -Root "\\192.168.88.190\26956693" -Persist

# Create a symbolic link
# New-Item -ItemType SymbolicLink -Path "$downloaderPath\Download" -Target "$driverName`:\tiktok"

# working directory is running directory
# get working directory
$runningDownloaderPath = (Get-Location).Path

# read the config file
$configFilePath = "$runningDownloaderPath\conf.ini"
$ini = Get-IniContent -FilePath $configFilePath
Write-Host $ini

# read cookie from cookie.txt
$cookie = Get-Content -Path "$downloaderPath\cookie"
# $ini["cookie"] = $cookie

# read links from urls.txt
$urls = Get-Content -Path "$downloaderPath\urls.txt"

# loop through the list of URLs
foreach ($url in $urls) {
    # if $url is empty, continue with the next URL
    if ($url -eq "") {
        continue
    }

    # if $url is a comment, continue with the next URL
    if ($url.StartsWith("#")) {
        continue
    }

    # download the video by calling python -m TikTokDownload.py
    # catch errors and continue with the next URL
    $ini["uid"] = $url
    Write-Host $ini["uid"]

    # remove the old config file and write the new one
    Remove-Item -Path $configFilePath
    Out-IniFile -InputObject $ini -FilePath  $configFilePath
    
    try {
        TikTokTool
    }
    catch {
        Start-Sleep -Seconds 20
        continue
    }
}
exit