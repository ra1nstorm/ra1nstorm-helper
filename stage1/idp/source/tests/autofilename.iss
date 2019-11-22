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
    idpSetOption('DetailedMode',  '1');
    idpSetOption('AllowContinue', '1');
    idpSetOption('ErrorDialog',   'URLList');

    idpAddFile('http://www.jrsoftware.org/download.php/is-unicode.exe?site=1', ExpandConstant('{src}\isetup.exe'));
    idpDownloadAfter(wpWelcome);
end;
