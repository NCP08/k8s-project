@echo off

bcdedit > nul || (echo ��Ŭ�� �Ͽ� ������ �������� �����ϼ���. & pause & exit)


:INPUT
cls
echo 1. ���� ����ũ�� ��Ʈ(3389)�� �����մϴ�.
echo 2. ������ ���� ����ũ�� ��Ʈ�� ����ϴ�.
echo 3. ������ ���� ����ũ�� ����� Ȯ���մϴ�.
echo 4. ����

set /p select=�޴� ����(1,2,3,4) :
cls

if %select% == 1 ( 
set /p port=���� �� ��Ʈ ��ȣ �Է� : 
) else if %select% == 2 ( 
set /p del_port=������ ���� ����ũ�� ��Ʈ ��ȣ �Է� : 
) else if %select% == 3 ( 
netsh advfirewall firewall show rule name=all dir=in | findstr /C:"���� ����ũ��" 
) else if %select% == 4 ( exit ) else ( goto INPUT )

if %select% == 1 (

if "%port%" == "" (
goto INPUT
)

reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v PortNumber /t REG_DWORD /d %port% /f

netsh advfirewall firewall add rule name="���� ����ũ�� %port%" description="3389��Ʈ ��� %port%�� ����մϴ�." dir=in action=allow protocol=tcp localport=%port%
net stop /y TermService
net start /y TermService

echo ��Ʈ�� %port%�� ����Ǿ����ϴ�.
) else if %select% == 2 ( 

if "%del_port%" == "" (
goto INPUT
)
netsh advfirewall firewall delete rule name="���� ����ũ�� %del_port%" dir=in protocol=tcp localport=%del_port%
)

echo.
echo ����Ϸ��� Any Ű�� ��������.
pause > nul
goto INPUT