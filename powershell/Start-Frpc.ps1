# set the path to be the folder where frpc.exe is located
$frpcPath = "C:/DevEnv/frp_0.45.0_windows_amd64"
# set working directory
Set-Location $frpcPath
# run frpc.exe
& $frpcPath/frpc.exe -c $frpcPath/frpc_custom.ini

# keep the window open
Read-Host -Prompt "Press Enter to exit"