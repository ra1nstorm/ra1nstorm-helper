#pragma include __INCLUDE__ + ";" + "idp\"
[Setup]
AppName                = ra1nstorm
AppVerName             = 0.9.5
AppVersion             = 0.9.5
DefaultDirName         = {sd}\ra1nstorm
DefaultGroupName       = ra1nstorm
DisableDirPage         = yes
; Size of files to download:
OutputDir              = ..\

#include "idp\idp.iss"

[Files]
Source: "..\ra1nstorm.run"; DestDir: "{app}"

[Run]
Filename: "{localappdata}\ra1nlinux\wubi.exe"; Parameters: "--size=64000"

[Code]
procedure InitializeWizard();
begin
    CreateDir(ExpandConstant('{localappdata}\ra1nlinux'));
    idpAddFile('https://github.com/hakuna-m/wubiuefi/releases/download/18042r333/wubi18042r333.exe', ExpandConstant('{localappdata}\ra1nlinux\wubi.exe'));
    idpAddFile('http://ftp.ussg.iu.edu/linux/xubuntu/18.04/release/xubuntu-18.04.2-desktop-amd64.iso', ExpandConstant('{localappdata}\ra1nlinux\xubuntu-18.04.2-desktop-amd64.iso'));
    idpAddMirror('http://ftp.ussg.iu.edu/linux/xubuntu/18.04/release/xubuntu-18.04.2-desktop-amd64.iso', 'https://mirror.us.leaseweb.net/ubuntu-cdimage/xubuntu/releases/18.04/release/xubuntu-18.04.2-desktop-amd64.iso');
    idpAddMirror('http://ftp.ussg.iu.edu/linux/xubuntu/18.04/release/xubuntu-18.04.2-desktop-amd64.iso', 'https://www.mirrorservice.org/sites/cdimage.ubuntu.com/cdimage/xubuntu/releases/18.04/release/xubuntu-18.04.2-desktop-amd64.iso');
    idpDownloadAfter(wpReady);
end;

