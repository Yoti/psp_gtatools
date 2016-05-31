program rawpack;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

var
  b: Byte;
  LogFile: TextFile;
  RawFile, VagFile: File of Byte;
  LogString, VagSize_s, VagStart_s, VagName: String;
  i, ErrorCount, RawSize, VagSize, VagSize_Real, VagStart: Integer;

procedure Resize(fil: String; siz: Integer);
var
  b: Byte;
  i: Integer;
  f: File of Byte;
begin
  b:=$00;
  AssignFile(f, fil);
  Reset(f);
  for i:=FileSize(f) to (siz-1)
  do
    begin
      Seek(f, i);
      Write(f, b);
    end;
  CloseFile(f);
end;

function IntToStrEx(int, len: Integer): String;
var
  s: String;
  i: Integer;
begin
  s:=IntToStr(int);
  for i:=Length(s) to len-1 do
    begin
      s:='0'+s;
    end;
  IntToStrEx:=s;
end;

begin

  SetConsoleTitle(PChar('rawpack'));
  Sleep(50);
  WriteLn(' RawPack by Yoti @ gtamodding.ru # build 27.03.2011/R2');
  WriteLn(' -----------------------------------------------------');

  if (ParamCount = 0) then
  begin
    WriteLn(' Using: rawpack.exe filename.rad');
    WriteLn;
    {WriteLn('Press any key to exit...');
    ReadLn;
    Exit;}
  end;

  if (ParamCount = 1) then
  begin
    if (FileExists(ParamStr(1)) = True)
    then
      begin
        AssignFile(RawFile, ParamStr(1));
        Reset(RawFile);
        RawSize:=FileSize(RawFile);
        CloseFile(RawFile);
        WriteLn(' Source file ['+ExtractFileName(ParamStr(1))+'] is '+IntToStr(RawSize)+' bytes');
        WriteLn;

        ErrorCount:=0;
        Write(' RAD found: ');
        if (FileExists(ParamStr(1)) = False)
        then
          begin
            WriteLn('false, error');
            Inc(ErrorCount);
          end
        else WriteLn('true, ok');
        Write(' RAW found: ');
        if (FileExists(ChangeFileExt(ParamStr(1), '.RAW')) = True)
        then
          begin
            WriteLn('true, error');
            //Inc(ErrorCount);
          end
        else WriteLn('false, ok');
        Write(' OLS found: '); // OLS = Offset LiSt
        if (FileExists(ChangeFileExt(ParamStr(1), '.OLS')) = False)
        then
          begin
            WriteLn('false, error');
            Inc(ErrorCount);            
          end
        else WriteLn('true, ok');
        Write(' DiR found: ');        
        if (DirectoryExists(ChangeFileExt(ParamStr(1), '.DiR')) = False)
        then
          begin
            WriteLn('false, error');
            Inc(ErrorCount);
          end
        else WriteLn('true, ok');

        if (ErrorCount = 0)
        then
          begin
            WriteLn;
            CopyFile(PChar(ParamStr(1)), PChar(ChangeFileExt(ParamStr(1), '.RAW')), True);
            AssignFile(LogFile, ChangeFileExt(ParamStr(1), '.OLS'));
            Reset(LogFile);
            while(EOF(LogFile) = False)
            do
              begin
                VagName:='';
                VagSize_s:='';
                LogString:='';
                VagStart_s:='';

                ReadLn(LogFile, LogString);
                VagStart_s:='$'+Copy(LogString, 1, Pos(',', LogString)-1);
                VagStart:=StrToInt(VagStart_s);
                Delete(LogString, 1, Length(VagStart_s));
                VagSize_s:=LogString;
                VagSize:=StrToInt(VagSize_s);

                VagName:=ChangeFileExt(ParamStr(1), '.DiR') + '\' + IntToHex(VagStart, 8) + '.VAG';
                WriteLn(' VAG record, offset: 0x'+IntToHex(VagStart, 8)+' / length: '+IntToStrEx(VagSize, 5));
                if (FileExists(VagName) = True)
                then
                  begin
                    AssignFile(VagFile, VagName);
                    Reset(VagFile);
                    VagSize_Real:=FileSize(VagFile);
                    CloseFile(VagFile);
                    if (VagSize_Real <= VagSize)
                    then
                      begin
                        if (VagSize_Real < VagSize)
                        then Resize(VagName, VagSize);
                        //
                        AssignFile(RawFile, ChangeFileExt(ParamStr(1), '.RAW'));
                        AssignFile(VagFile, VagName);
                        Reset(RawFile);
                        Reset(VagFile);
                        for i:=0 to VagSize-1
                        do
                          begin
                            Seek(VagFile, i);
                            Read(VagFile, b);
                            Seek(RawFile, i+VagStart);
                            Write(RawFile, b);
                          end;
                        CloseFile(RawFile);
                        CloseFile(VagFile);
                        //
                        WriteLn(' '+ExtractFileName(VagName)+' -> '+ExtractFileName(ChangeFileExt(ParamStr(1), '.RAW'))+' done');
                      end
                    else if (VagSize_Real > VagSize)
                    then
                      begin
                        WriteLn(' '+ExtractFileName(VagName)+' bigger than older one by '+IntToStr(VagSize_Real-VagSize)+' byte(s)!');
                      end;
                  end
                else WriteLn(' ' + ExtractFileName(ChangeFileExt(ParamStr(1), '.DiR')) + '\' + IntToHex(VagStart, 8) + '.VAG' + ' not found!');
              end;
            CloseFile(LogFile);
            WriteLn;
            WriteLn(' New RAW done!');
          end
        else
          begin
            WriteLn;
            WriteLn(' Unpack RAW with [rawscan] first!');
          end;
      end;
    WriteLn;
  end;

end.
