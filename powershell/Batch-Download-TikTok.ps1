# usage:
# start server.bat in a terminal
# start this script in another terminal
# can only download single video links, not playlists
Import-Module -Name PsIni

# read the config file
$configFilePath = "D:\Dev\repo\TikTokDownload\conf.ini"
$ini = Get-IniContent -FilePath $configFilePath

# read links from urls.txt
$urls = Get-Content -Path "D:\Dev\repo\TikTokDownload\Download\urls.txt"

# set working directory to the tiktok downloader project directory
Set-Location -Path "D:\Dev\repo\TikTokDownload"

# activate the virtual environment
.\.venv\Scripts\Activate.ps1


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
    $ini["uid"]["uid"] = $url
    Write-Host $ini["uid"]["uid"]
    # remove the old config file and write the new one
    Remove-Item -Path $configFilePath
    Out-IniFile -InputObject $ini -FilePath  $configFilePath
    try {
        python TikTokTool.py
    }
    catch {
        continue
    }
}
