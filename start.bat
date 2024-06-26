@echo off

:: Remove the Epic Games Launcher shortcut
del /f "C:\Users\Public\Desktop\Epic Games Launcher.lnk" > out.txt 2>&1

:: Set server comment
net config server /srvcomment:"Windows Server 2019 By mohammadali" > out.txt 2>&1

:: Disable auto tray
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /V EnableAutoTray /T REG_DWORD /D 0 /F > out.txt 2>&1

:: Add registry entry to run wallpaper.bat at startup
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /f /v Wallpaper /t REG_SZ /d D:\a\wallpaper.bat

:: Create user mohammadali and add to administrators group
net user mohammadali mmd@123 /add >nul
net localgroup administrators mohammadali /add >nul
net user mohammadali /active:yes >nul

:: Delete installer user
net user installer /delete

:: Enable disk performance counters
diskperf -Y >nul

:: Configure and start Audio Service
sc config Audiosrv start= auto >nul
sc start audiosrv >nul

:: Grant permissions to mohammadali user
ICACLS C:\Windows\Temp /grant mohammadali:F >nul
ICACLS C:\Windows\installer /grant mohammadali:F >nul

:: Display installation success message
echo Successfully installed! If RDP is dead, rebuild again.
echo IP:

:: Fetch NGROK tunnel information using PowerShell
powershell -Command "
    $ngrokApiUrl = 'http://localhost:4040/api/tunnels'
    try {
        $response = Invoke-RestMethod -Uri $ngrokApiUrl -ErrorAction Stop
        $publicUrl = $response.tunnels[0].public_url
        if ($publicUrl) {
            echo $publicUrl
        } else {
            echo 'Failed to retrieve NGROK tunnel URL - no tunnels found'
        }
    } catch {
        echo 'Failed to retrieve NGROK tunnel URL - check if NGROK is running and the authtoken is set correctly'
    }
"

:: Display user credentials
echo Username: mohammadali
echo Password: mmd@123
echo You can login now

:: Pause to allow user to read the output
ping -n 10 127.0.0.1 >nul
