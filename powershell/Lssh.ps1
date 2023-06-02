param(
    [Parameter(Mandatory = $false)]
    [string]$sshEnv
)
$ip = '127.0.0.1'
$port = '22'
$user = 'root'
$passw = '123456'
$cmd = 'echo "Hello World"'

switch ($sshEnv) {
    15422 { 
        $ip = '10.10.10.10'
        $port = '22'
        $passw = '123'
    }
    15322 { 
        $ip = '10.10.10.11'
        $port = '22'
        $passw = '456'
    }
    test {
      
    }
    Default {
       
    }
}

Set-Location $PSScriptRoot

Write-Host "user: [$user] login to [$ip`:$port]"
& ".\LoginSSH.ps1" -ip $ip -port $port -user $user -passw $passw -cmd $cmd