# log in a remote linux machin via ssh by using password
# Usage: Login.ps1 -ip <ip address> -port <port> -user <username> -password <password>
# Install-Module -Name Posh-SSH

param(
    [Parameter(Mandatory = $true)]
    [string]$ip,
    [Parameter(Mandatory = $true)]
    [string]$port,
    [Parameter(Mandatory = $true)]
    [string]$user,
    [Parameter(Mandatory = $true)]
    [string]$passw,
    [Parameter(Mandatory = $false)]
    [string]$cmd
)
# Posh-SSH docs:
# https://github.com/darkoperator/Posh-SSH
Import-Module -Name Posh-SSH

$session = New-SSHSession -ComputerName $ip -Port $port -Credential (New-Object System.Management.Automation.PSCredential($user, (ConvertTo-SecureString $passw -AsPlainText -Force)))

if ($session) {
    Write-Host "Login successfully"
    $SSHStream = New-SSHShellStream -SSHSession $session
    # $SSHStream.WriteLine("echo 'Hello World 888' > ~/hello.txt")
    $SSHStream.WriteLine($cmd)
    $SSHStream.read()
}
else {
    Write-Host "Login failed"
}

