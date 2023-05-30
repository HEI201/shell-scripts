# download the videos from a list of URLs using youtube-dl
# set youtube-dl project directory as current directory
Set-Location -Path "D:\Dev\repo\youtube-dl"

# set the path to the file containing the list of URLs
$urls = Get-Content -Path "D:\Video\youtube\youtube-urls.txt"

# loop through the list of URLs
foreach ($url in $urls) {
    # download the video by calling python -m youtube_dl $url
    # catch errors and continue with the next URL
    try {
        python -m youtube_dl $url
    }
    catch {
        continue
    }
}
