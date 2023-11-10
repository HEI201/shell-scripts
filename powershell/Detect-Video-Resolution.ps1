# get working directory
$workingPath = (Get-Item -Path ".\").FullName

# get all files in working directory
$files = Get-ChildItem -Path $workingPath -Recurse -File

function Test-VideoFile {
    param (
        [Parameter(Mandatory = $true)]
        [string]$extension
    )

    $videoExtensions = @(".mp4", ".mov", ".avi", ".wmv", ".flv", ".mkv", ".webm", ".m4v", ".mpg", ".mpeg", ".m2v", ".3gp", ".3g2", ".mxf", ".ts", ".mts", ".m2ts", ".vob", ".divx", ".xvid", ".rm", ".rmvb", ".asf", ".ogm", ".ogv", ".f4v", ".h264", ".h265", ".hevc", ".m1v", ".m2p", ".m2t", ".mpv", ".mpeg1", ".mpeg2", ".mpeg4", ".mpv2", ".mp2v", ".mp2", ".mpe", ".mpv4", ".mpegts", ".mpegts2", ".mts", ".mxf", ".m4v", ".m2ts", ".m2t", ".m2v", ".m1v", ".mov", ".qt", ".rm", ".rmvb", ".ts", ".tp", ".trp", ".tp", ".trp", ".tod", ".vob", ".vro", ".wmv", ".webm", ".flv", ".mkv", ".3gp", ".3g2", ".3gp2", ".3gpp", ".3gpp2", ".avi", ".divx", ".evo", ".f4v", ".h264", ".h265", ".hevc", ".mjpeg", ".mjpg", ".mjpg")

    if ($videoExtensions -contains $extension) {
        return $true
    }
    else {
        return $false
    }

    
}

Write-Host "total files : $($files.Count)"

# loop through all files
foreach ($filePath in $files) {
    # get file extension
    $extension = $filePath.Extension
    Write-Host "---------------------------------"
    Write-Host "Processing: $filePath"

    # check if file is a video file
    if (Test-VideoFile $extension) {
        # get file name
        $fileName = $filePath.Name

        # get file resolution
        # do not format the line below, if you do, the editor will add a space between width, and height, and the command will fail, but if 'stream=width,height' is quoted, it will work
        $fileResolution = ffprobe -v error `
            -select_streams v:0 `
            -show_entries 'stream=width,height' `
            -of csv=s=x:p=0 `
            $filePath
        try {
            # get file resolution width
            $fileResolutionWidth = $fileResolution.Substring(0, $fileResolution.IndexOf("x"))

            Write-Host "File resolution width is $fileResolutionWidth"

            # get file resolution height
            $fileResolutionHeight = $fileResolution.Substring($fileResolution.IndexOf("x") + 1)

            Write-Host "File resolution height is $fileResolutionHeight"

            # parse file resolution width
            $fileResolutionWidth = [int]$fileResolutionWidth

            # parse file resolution height
            $fileResolutionHeight = [int]$fileResolutionHeight

            # check if file resolution is less than 720p
            if ($fileResolutionWidth -lt 1280 -or $fileResolutionHeight -lt 720) {

                # write to console in yellow
                Write-Host "low: $fileName" -ForegroundColor Yellow

                # log to a file
                Add-Content -Path "$workingPath\lowResLog.txt" -Value "$filePath"
            }
            else {
                # write to console in green
                Write-Host "high: $fileName" -ForegroundColor Green
                Add-Content -Path "$workingPath\highResLog.txt" -Value "$filePath"
            }
        }
        catch {
            Write-Host "Error:" $_.Exception.Message
            exit 0
        }
    }

}