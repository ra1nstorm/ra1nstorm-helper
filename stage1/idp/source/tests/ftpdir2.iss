[Setup]
AppName          = My Program
AppVersion       = 1.5
DefaultDirName   = {pf}\My Program
DefaultGroupName = My Program
OutputDir        = .

#define IDP_DEBUG
#include <idp.iss>

[Files]
Source: "idptest.iss"; DestDir: "{app}"

[Icons]
Name: "{group}\{cm:UninstallProgram,My Program}"; Filename: "{uninstallexe}"

[Code]
procedure InitializeWizard();
begin
    idpSetOption('DetailedMode',    '1');
    idpSetOption('AllowContinue',   '1');
    idpSetOption('ErrorDialog',     'FileList');
    //idpSetOption('PreserveFtpDirs', '0');
end;

procedure CurPageChanged(CurPageID: Integer);
begin
    if CurPageID = wpReady then
    begin
        ForceDirectories(ExpandConstant('{app}'));
        idpAddFtpDir('ftp://127.0.0.1/', '', ExpandConstant('{app}'), true);
        idpDownloadAfter(wpReady);
    end;
end;