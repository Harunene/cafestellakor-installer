Var MSG

Var BGImage
Var MiddleImage
Var ImageHandle

!addincludedir "includes"
!addplugindir /x86-unicode "plugins"

!define EM_BrandingText "카페 스텔라와 사신의 나비 비공식 한국어 패치 1.1"
Name "${EM_BrandingText}"
OutFile "CafeStella_korpatch.exe"
RequestExecutionLevel user
Unicode True
InstallDir $EXEDIR
BrandingText "${EM_BrandingText}"
SetCompressor zlib
SetCompress force
XPStyle on


; Includes
!include "MUI2.nsh"
!include "UAC.nsh"

;--------------------------------
; initialize
;--------------------------------

!define MUI_ICON "icon.ico"
!define MUI_UNICON "icon.ico"
!define MUI_TEXT_WELCOME_INFO_TEXT "주의!$\n$\n기존 세이브파일은 savedata_backup으로 백업됩니다.$\n$\n언인스톨러를 실행하면 원래대로 복원됩니다.$\n$\n기존 세이브파일을 쓰시려면 (비권장)$\n인스톨러가 끝난 후에 savedata_backup을 savedata로 직접 바꿔주시고 꼭 게임 내 설정에서 폰트를 NOTOYUZU로 선택해주세요!"
!define MUI_WELCOMEFINISHPAGE_BITMAP "images\welcome.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "images\header.bmp"
!define MUI_TEXT_DIRECTORY_TITLE "설치 위치 선택"
!define MUI_TEXT_DIRECTORY_SUBTITLE "원본 게임이 설치된 위치를 선택해주세요"
!insertmacro MUI_PAGE_WELCOME
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE "validateDirectory"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "Korean"


!macro Init_UAC thing
  uac_tryagain:
  !insertmacro UAC_RunElevated

  ${Switch} $0
  ${Case} 0
    ;${IfThen} $1 = 1 ${|} Quit ${|} ;we are the outer process, the inner process has done its work, we are done
    ${IfThen} $3 <> 0 ${|} ${Break} ${|} ;we are admin, let the show go on
    ${If} $1 = 3 ;RunAs completed successfully, but with a non-admin user
      MessageBox mb_YesNo|mb_IconExclamation|mb_TopMost|mb_SetForeground "${thing}가 관리자권한을 필요로 합니다. 다시 시도할까요?" /SD IDNO IDYES uac_tryagain IDNO 0
    ${Else}
      ${Break}
    ${EndIf}
  ${Default}
  ${EndSwitch}

  SetShellVarContext all
!macroend

!macro check_file_installed filename
  ${If} ${FileExists} `$InstDir\${filename}`
  ${Else}
    MessageBox MB_OK `$InstDir\${filename}을 설치하는 동안 파일이 손상되었습니다. 안티바이러스(V3, Windows Depender)등의 영향이 있을 수 있으므로 실시간 검사를 잠시 Off로 해두신 후 확인버튼을 눌러주세요`
    File ${filename}
  ${EndIf}
!macroend

Function .onInit
    InitPluginsDir
FunctionEnd

Function validateDirectory
  CreateDirectory "$InstDir\dummy"
  ${If} ${Errors}
    MessageBox MB_OK `설치 권한이 없습니다. 관리자 권한으로 설치를 다시 시작합니다.`
    !insertmacro Init_UAC "Installer"
	Quit
  ${EndIf}
  RMDir "$InstDir\dummy"

  Crypto::HashFile 'MD5' "$InstDir\patch.xp3"
  Pop $0
  StrCmp $0 "3087402b3629ebda59a3613525b4b553" +4 ; 패키지판 hash
  ;StrCmp $0 "65dc396277079c5c93b8ae754031bfe4" +3 ; 다운로드판 hash
    MessageBox MB_YESNO "설치된 게임이 카페 스텔라와 사신의 나비 1.30 버전이 아닌것으로$\n확인됩니다. (해당 한국어 패치는 패키지판만을 지원합니다)$\n그래도 설치하시겠습니까?" IDYES yep
    Abort
  yep:

  ${If} ${FileExists} "$InstDir\cafestella.exe"
  ${Else}
    MessageBox MB_YESNO `cafestella.exe가 $InstDir 에 없습니다. 그래도 설치하시겠습니까?` IDYES yep2
    Abort
  yep2:
  ${EndIf}

FunctionEnd

; dummy
Section "Dummy Section" SecDummy

  SetOutPath "$INSTDIR"

  ${If} ${FileExists} "$InstDir\CafeStella_KR.exe"
  ${Else}
    Rename "$INSTDIR\savedata" "$INSTDIR\savedata_backup"
    Rename "$INSTDIR\savedata_kr" "$INSTDIR\savedata"
  ${EndIf}

  Delete "$INSTDIR\Cafestella_KR_Uninstall.exe"
  Delete "$INSTDIR\CafeStella_KR_uninstall.exe"
  Delete "$INSTDIR\CafeStella_KR.exe"
  Delete "$INSTDIR\krkrPatch.db"
  Delete "$INSTDIR\krkrPatch.dll"
  Delete "$INSTDIR\patch_KR2.xp3"
  RMDir /r "$INSTDIR\video"
  RMDir /r "$INSTDIR\patch_KR"
  RMDir /r "$INSTDIR\patch_KR2"
  
  File CafeStella_KR.exe
  File krkrPatch.dll
  File krkrPatch.db
  File patch_KR2.xp3
  File /r video
  File /r patch_KR
  File /r patch_KR2
  
  !insertmacro check_file_installed "CafeStella_KR.exe"
  !insertmacro check_file_installed "krkrPatch.dll"

  ;Create uninstaller
  WriteUninstaller "$INSTDIR\CafeStella_KR_uninstall.exe"

SectionEnd

Section "Uninstall"
  CreateDirectory "$InstDir\dummy"
  ${If} ${Errors}
    MessageBox MB_OK `설치 권한이 없습니다. 관리자 권한으로 설치를 다시 시작합니다.`
    !insertmacro Init_UAC "Uninstall"
	Quit
  ${EndIf}
  
  Delete "$INSTDIR\CafeStella_KR_uninstall.exe"
  Delete "$INSTDIR\CafeStella_KR.exe"
  Delete "$INSTDIR\krkrPatch.dll"
  Delete "$INSTDIR\krkrPatch.db"
  Delete "$INSTDIR\patch_KR2.xp3"
  RMDir /r "$INSTDIR\video"
  RMDir /r "$INSTDIR\patch_KR"
  RMDir /r "$INSTDIR\patch_KR2"

  Rename "$INSTDIR\savedata" "$INSTDIR\savedata_kr"
  Rename "$INSTDIR\savedata_backup" "$INSTDIR\savedata"

SectionEnd