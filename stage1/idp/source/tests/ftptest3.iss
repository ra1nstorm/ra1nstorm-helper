#pragma include __INCLUDE__ + ";" + ReadReg(HKLM, "Software\Mitrich Software\Inno Download Plugin", "InstallDir")

[Setup]
AppName                    = My Program
AppVersion                 = 1.5
DefaultDirName             = {pf}\My Program
DefaultGroupName           = My Program
OutputDir                  = .

#define IDP_DEBUG
#include <idp.iss>

[Files]
Source: "idptest.iss"; DestDir: "{app}"

[Icons]
Name: "{group}\{cm:UninstallProgram,My Program}"; Filename: "{uninstallexe}"

[Code]
procedure InitializeWizard();
begin
    idpSetOption('DetailedMode',  '1');
    idpSetOption('AllowContinue', '1');
    idpSetOption('ErrorDialog',   'URLList');

    idpAddFile('ftp://127.0.0.1/test1.zip', ExpandConstant('{src}\test1.zip'));
    idpAddFile('ftp://127.0.0.1/test2.zip', ExpandConstant('{src}\test2.zip'));
    idpAddFile('ftp://127.0.0.1/test3.zip', ExpandConstant('{src}\test3.zip'));
    idpAddFile('ftp://127.0.0.1/test#.zip', ExpandConstant('{src}\test#.zip'));

    idpDownloadAfter(wpWelcome);
end;
