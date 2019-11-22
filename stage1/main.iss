[Setup]
AppName                = ra1nstorm
AppVersion             = 0.9
DefaultDirName         = {pf}\ra1nstorm
DefaultGroupName       = ra1nstorm
; Size of files to download:
OutputDir              = ..\

#include "idp\idp.iss"

[Icons]
Name: "{group}\{cm:UninstallProgram,ra1nstorm}"; Filename: "{uninstallexe}"

[UninstallDelete]

[Code]
procedure InitializeWizard();
begin
    idpAddFile('http://127.0.0.1/test1.zip', ExpandConstant('{tmp}\test1.zip'));
    idpAddFile('http://127.0.0.1/test2.zip', ExpandConstant('{tmp}\test2.zip'));
    idpAddFile('http://127.0.0.1/test3.zip', ExpandConstant('{tmp}\test3.zip'));

    idpDownloadAfter(wpReady);
end;

