@echo off
setlocal EnableExtensions

if /I "%~1"=="--copy" goto COPY_FILE
if /I "%~1"=="--uninstall" goto UNINSTALL

set "APPDIR=%LOCALAPPDATA%\BackupContextMenu"
set "TARGET=%APPDIR%\BackupToFiles.bat"
set "BACKUP_DIR=D:\backup\Files"

set "MENU_KEY=HKCU\Software\Classes\*\shell\BackupToFilesWithTimestamp"
set "CLASSIC_ROOT=HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"
set "CLASSIC_KEY=%CLASSIC_ROOT%\InprocServer32"

if not exist "D:\" (
    echo.
    echo ERROR: Drive D: not found.
    echo Please make sure drive D: exists.
    echo.
    pause
    exit /b 1
)

mkdir "%APPDIR%" >nul 2>nul
mkdir "%BACKUP_DIR%" >nul 2>nul

if /I not "%~f0"=="%TARGET%" (
    copy /Y "%~f0" "%TARGET%" >nul
)

reg.exe delete "%MENU_KEY%" /f >nul 2>nul

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$r=[Microsoft.Win32.Registry]::CurrentUser; $m='Software\Classes\*\shell\BackupToFilesWithTimestamp'; $k=$r.CreateSubKey($m); $k.SetValue('', 'Back up to D:\backup\Files'); $k.SetValue('Icon','imageres.dll,-5302'); $k.SetValue('Position','Top'); $c=$k.CreateSubKey('command'); $q=[char]34; $bat=$env:TARGET; $c.SetValue('', 'cmd.exe /d /c call '+$q+$bat+$q+' --copy '+$q+'%%1'+$q)"

reg.exe add "%CLASSIC_KEY%" /ve /t REG_SZ /d "" /f >nul

taskkill /f /im explorer.exe >nul 2>nul
start "" explorer.exe

echo.
echo Installation completed.
echo.
echo Right-click a file and choose:
echo Back up to D:\backup\Files
echo.
echo Output filename format:
echo originalname_yyyyMMdd_HHmmss.ext
echo.
echo If the context menu is still not classic style, restart Windows once.
echo.
pause
exit /b 0

:COPY_FILE
set "SRC=%~2"
set "BACKUP_DIR=D:\backup\Files"

if "%SRC%"=="" exit /b 1
if not exist "D:\" exit /b 2
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%" >nul 2>nul
if not exist "%SRC%" exit /b 3

for %%F in ("%SRC%") do (
    set "NAME=%%~nF"
    set "EXT=%%~xF"
)

for /f %%T in ('powershell.exe -NoProfile -Command "[DateTime]::Now.ToString('yyyyMMdd_HHmmss')"') do set "TS=%%T"

set "DST=%BACKUP_DIR%\%NAME%_%TS%%EXT%"
set /a N=1

:CHECK_DUP
if not exist "%DST%" goto DO_COPY
set "DST=%BACKUP_DIR%\%NAME%_%TS%_%N%%EXT%"
set /a N+=1
goto CHECK_DUP

:DO_COPY
copy /Y /B "%SRC%" "%DST%" >nul
exit /b %ERRORLEVEL%

:UNINSTALL
set "APPDIR=%LOCALAPPDATA%\BackupContextMenu"
set "MENU_KEY=HKCU\Software\Classes\*\shell\BackupToFilesWithTimestamp"
set "CLASSIC_ROOT=HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}"

reg.exe delete "%MENU_KEY%" /f >nul 2>nul
reg.exe delete "%CLASSIC_ROOT%" /f >nul 2>nul

if exist "%APPDIR%" rmdir /s /q "%APPDIR%" >nul 2>nul

taskkill /f /im explorer.exe >nul 2>nul
start "" explorer.exe

echo.
echo Uninstalled.
echo.
echo The backup context menu has been removed.
echo The default Windows 11 context menu has been restored.
echo.
pause
exit /b 0