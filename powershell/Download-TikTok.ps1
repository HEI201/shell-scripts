# usage:
# start server.bat in a terminal
# start this script in another terminal
# can only download single video links, not playlists
Import-Module -Name PsIni

$downloaderPath = "D:\Video\tiktok\downloader"
# add downloader path to PATH
$env:PATH += ";$downloaderPath"

# working directory is running directory
# get working directory
$runningDownloaderPath = (Get-Location).Path

# read the config file
$configFilePath = "$runningDownloaderPath\conf.ini"

$urlsFilepath = "$runningDownloaderPath\urls.txt"

# if urls file does not exist, exit with error
if (-not (Test-Path -Path $urlsFilepath)) {
    Write-Host "urls file does not exist: $urlsFilepath"
    exit 1
}

# read links from urls.txt
$urls = Get-Content -Path $urlsFilepath

function  Get-Cookie {
    # read cookie from ini file
    $iniFile = Get-IniContent -FilePath $configFilePath
    $cookie = $iniFile['_']['cookie']

    # if cookie is empty, assign an empty string
    if ($null -eq $cookie) {
        $cookie = ""
    }

    return $cookie
}

# filter the lines that are empty and comments from urls.txt
# read links from urls.txt and filter out empty and comment lines
$urls = Get-Content -Path $urlsFilepath | Where-Object { $_ -notmatch "^(\s*#|$)" }
# print links line by line
Write-Host "links:"
foreach ($url in $urls) {
    Write-Host $url
}

# loop through the list of URLs
foreach ($url in $urls) {

    # download the video by calling python -m TikTokDownload.py
    # catch errors and continue with the next URL
    $ini = @{
        uid             = $url
        music           = "no"
        cover           = "no"
        desc            = "no"
        folderize       = "no"
        update          = "no"
        mode            = "post"
        cookie          = Get-Cookie
        interval        = "all"
        # path 下载地址是相对于当前运行脚本的目录
        path            = "./"
        naming          = "{create}_{desc}"
        max_connections = 5
        max_tasks       = 2
    }
    
    Remove-Item -Path $configFilePath
    Out-IniFile -InputObject $ini -FilePath $configFilePath
    
    try {
        TikTokTool
    }
    catch {
        # log the error
        Write-Host "error downloading $url : $($_.Exception.Message)"
        Write-Host "sleeping for 5 s ..."
        Start-Sleep -Seconds 5
        continue
    }
}
exit 0