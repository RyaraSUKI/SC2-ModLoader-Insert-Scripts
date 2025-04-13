@echo off
title SugarCube2 ModLoader 注入器 By ：RyaraSUKI
color 0A

echo.
echo 欢迎使用 SugarCube2 ModLoader 注入器！
echo -------------------------------
echo 将自动调用 PowerShell 脚本进行处理，请勿进行其他操作...
echo.

powershell -ExecutionPolicy Bypass -NoProfile -File "%~dp0runml.ps1"

echo.
echo -------------------------------
echo 所有操作完成。请按任意键退出窗口。
pause >nul