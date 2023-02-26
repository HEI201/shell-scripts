Add-Type -AssemblyName System.Windows.Forms

# 将鼠标光标移动到屏幕上的指定位置
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(200, 200)
