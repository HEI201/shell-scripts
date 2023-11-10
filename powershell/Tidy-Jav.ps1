# get working directory
$workingPath = (Get-Item -Path ".\").FullName

# get all files in working directory
$dirs = Get-ChildItem -Path $workingPath  -Directory

# loop through all directories
foreach ($dir in $dirs) {

    Set-Location $dir

    video-cut.ps1

    jav-normalize-file-name.ps1

}
