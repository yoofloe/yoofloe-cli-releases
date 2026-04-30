@echo off
setlocal

set "INSTALLER_REPO=%YOOFLOE_INSTALLER_REPO%"
if "%INSTALLER_REPO%"=="" set "INSTALLER_REPO=yoofloe/yoofloe-cli-releases"

set "SCRIPT_URL=https://raw.githubusercontent.com/%INSTALLER_REPO%/main/install.ps1"
set "TMP_SCRIPT=%TEMP%\yoofloe-install-%RANDOM%-%RANDOM%.ps1"

echo Downloading Yoofloe CLI installer from %SCRIPT_URL%
curl.exe --fail --location --retry 3 --silent --show-error "%SCRIPT_URL%" --output "%TMP_SCRIPT%"
if errorlevel 1 exit /b %ERRORLEVEL%

powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%TMP_SCRIPT%"
set "INSTALL_EXIT=%ERRORLEVEL%"
del "%TMP_SCRIPT%" >nul 2>nul
exit /b %INSTALL_EXIT%
