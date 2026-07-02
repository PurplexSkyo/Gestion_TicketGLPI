@echo off
cd /d "%~dp0"
start "" /B pwsh.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "Gestion_Ticket.ps1"
exit