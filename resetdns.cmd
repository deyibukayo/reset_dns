@echo off
cls

:initialization
setlocal DisableDelayedExpansion
set "filePath=%~0"
for %%i in (%0) do set fileName=%%~ni
set "getAdmin=%temp%\%fileName%.vbs"
setlocal EnableDelayedExpansion

:checkPrivileges
net file 1>nul 2>nul
if '%errorlevel%' == '0' ( goto gotAdminRights ) else ( goto getAdminRights )

:getAdminRights
if "%1" == "ELEV" (echo ELEV & shift /1 & goto gotAdminRights)
ECHO set UAC = CreateObject^("Shell.Application"^) > "%getAdmin%"
ECHO args = "ELEV " >> "%getAdmin%"
ECHO for each strArg in WScript.Arguments >> "%getAdmin%"
ECHO args = args ^& strArg ^& " "  >> "%getAdmin%"
ECHO next >> "%getAdmin%"
ECHO UAC.ShellExecute "!filePath!", args, "", "runas", 1 >> "%getAdmin%"
"%SystemRoot%\System32\WScript.exe" "%getAdmin%" %*
exit /B

:gotAdminRights
setlocal & pushd .
cd /d %~dp0
if "%1" == "ELEV" (del "%getAdmin%" 1>nul 2>nul & shift /1)

:adminCMDs
ipconfig /flushdns
ipconfig /registerdns
ipconfig /release
ipconfig /renew
netsh winsock reset

echo This computer will restart...
pause
shutdown /r /t 00

cmd /k