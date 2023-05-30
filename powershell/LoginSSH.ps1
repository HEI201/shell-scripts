# log in a remote linux machin via ssh by using password
# Usage: Login.ps1 -ip <ip address> -port <port> -user <username> -password <password>
# Install-Module -Name Posh-SSH

# param(
#     [Parameter(Mandatory = $true)]
#     [string]$ip,
#     [Parameter(Mandatory = $true)]
#     [string]$port,
#     [Parameter(Mandatory = $true)]
#     [string]$user,
#     [Parameter(Mandatory = $true)]
#     [SecureString]$password
# )
Import-Module -Name Posh-SSH
$ip = '127.0.0.1'
$port = '22'
$user = 'root'
$password = ''

$session = New-SSHSession -ComputerName $ip -Port $port -Credential (New-Object System.Management.Automation.PSCredential($user, (ConvertTo-SecureString $password -AsPlainText -Force)))

if ($session) {
    Write-Host "Login successfully"
}
else {
    Write-Host "Login failed"
}

