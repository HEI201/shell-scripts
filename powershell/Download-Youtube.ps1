# download the videos from a list of URLs using youtube-dl

# read named url argument from the command line
param (
    [Parameter(Mandatory = $false)]
    [string]$url,
    # Parameter help description
    [Parameter(Mandatory = $false)]
    [switch]$current
)

$currentPath = Get-Location

# set youtube-dl project directory as current directory
Set-Location -Path "D:\Dev\repo\youtube-dl"

$savedOption = ""
# if the current switch is set, save the videos in the current directory
if ($current) {
    # fix me: the path is not working, youtube-dl is replacing the : with #, this makes the path invalid
    $savedOption = "-o $currentPath/%(title)s/%(title)s.%(ext)s"
}

Write-Host $currentPath
Write-Host $savedOption

function DownloadVideo {
    param (
        $url,
        $option
    )
    python -m youtube_dl $url $option
}

if ($url) {
    # download the video by calling python -m youtube_dl $url
    # python -m youtube_dl $url $savedOption
    DownloadVideo $url $savedOption
    exit
}



# set the path to the file containing the list of URLs
$urls = Get-Content -Path "D:\Video\youtube\youtube-urls.txt"

# loop through the list of URLs
foreach ($url in $urls) {
    # download the video by calling python -m youtube_dl $url
    # catch errors and continue with the next URL
    try {
        # python -m youtube_dl $url $savedOption
        DownloadVideo $url $savedOption
    }
    catch {
        continue
    }
}
