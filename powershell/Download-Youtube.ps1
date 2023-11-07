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

# save the youtube-dl project directory path to a variable
$youtubedlPath = "D:\Dev\repo\youtube-dl"
$env:PYTHONPATH += ";$youtubedlPath"

$outputOption = ""
$urlsPath = "D:\Video\youtube\youtube-urls.txt"
# if the current switch is set, save the videos in the current directory
if ($current) {
    # fix me: the path is not working, youtube-dl is replacing the : with #, this makes the path invalid
    $outputOption = "%(uploader)s/%(title)s/video.%(ext)s"
    $urlsPath = "$currentPath/youtube-urls.txt"
}

function DownloadVideo {
    param (
        $url,
        $option
    )
    # -o option can not contain gbk characters
    if ($option) {
        python -m youtube_dl $url -o $option
        return
    }
    python -m youtube_dl $url
}

if ($url) {
    # download the video by calling python -m youtube_dl $url
    # python -m youtube_dl $url $outputOption
    DownloadVideo $url $outputOption
    exit
}



# set the path to the file containing the list of URLs
$urls = Get-Content -Path $urlsPath

# loop through the list of URLs
foreach ($url in $urls) {
    # download the video by calling python -m youtube_dl $url
    # catch errors and continue with the next URL
    try {
        # python -m youtube_dl $url $outputOption
        DownloadVideo $url $outputOption
    }
    catch {
        continue
    }
}
