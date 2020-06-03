@echo off
if exist CafeStella_KR.exe (
  NSIS\makensis.exe installer.nsi
) else (
  echo 이 위치에 한패파일 압축을 풀어주세요.
  echo Please extract CafeStella_KR1.x.zip file here.
  pause
)
