@echo off
if exist CafeStella_KR.exe (
  NSIS\makensis.exe installer.nsi
) else (
  echo �� ��ġ�� �������� ������ Ǯ���ּ���.
  echo Please extract CafeStella_KR1.x.zip file here.
  pause
)
