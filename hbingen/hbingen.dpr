program hbingen;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils;

var
  B: Byte;
  FlsFile: TextFile;
  HdrFile, RadioFile: File of Byte;
  i, k, RadioCount, HdrSize: Integer;
  FlsString, FlsRadio, FlsOffset: String;

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
  SetConsoleTitle(PChar('hbingen'));
  Sleep(50);
  WriteLn('     HEADER.BIN Creator  by Yoti    ');
  WriteLn(' build 08.07.2011/R3  [chlorhydrikk]');
  WriteLn(' -----------------------------------');

  if (ParamCount = 0)
  then WriteLn(' usage: hbingen.exe gamecode');

  if (ParamCount = 1)
  then
    begin
      if (FileExists(ExtractFilePath(ParamStr(0))+'Base\'+ParamStr(1)+'.HDR') = True)
      then
        begin
          AssignFile(HdrFile, ExtractFilePath(ParamStr(0))+'Base\'+ParamStr(1)+'.HDR');
          Reset(HdrFile);
          HdrSize:=FileSize(HdrFile);
          CloseFile(HdrFile);
          RadioCount:=Round(HdrSize / $800);
          WriteLn(' File size: '+IntToStr(HdrSize)+' | Block size: '+IntToStr($800));
          WriteLn(' Test size: '+IntToStr(HdrSize)+' = '+IntToStr($800)+' * '+IntToStr(RadioCount)+' <- ok?');
          WriteLn;

          Write(' Writing '+ParamStr(1)+'.BIN... ');
          CopyFile(PChar(ExtractFilePath(ParamStr(0))+'Base\'+ParamStr(1)+'.HDR'), PChar(ExtractFilePath(ParamStr(0))+ParamStr(1)+'.BIN'), False);
          if (FileExists(ExtractFilePath(ParamStr(0))+ParamStr(1)+'.BIN') = True)
          then WriteLn('Ok!')
          else WriteLn('Error!');
          WriteLn;

          AssignFile(FlsFile, ExtractFilePath(ParamStr(0))+'Base\'+ParamStr(1)+'.FLS');
          Reset(FlsFile);
          for i:=0 to RadioCount-1
          do
            begin
              ReadLn(FlsFile, FlsString);
              FlsOffset:='$'+Copy(FlsString, 1, Pos(',', FlsString)-1);
              Delete(FlsString, 1, Length(FlsOffset));
              FlsRadio:=FlsString;
              Write(' ');
              Write(FlsOffset:9);
              Write(': ');
              Write(FlsRadio:12);
              Write(' ');

              if (FileExists(FlsRadio) = True)
              then
                begin
                  Write('- found, ');

                  AssignFile(RadioFile, FlsRadio);
                  AssignFile(HdrFile, ParamStr(1)+'.BIN');
                  Reset(RadioFile);
                  Reset(HdrFile);
                  for k:=0 to $7FF
                  do
                    begin
                      Seek(RadioFile, k);
                      Read(RadioFile, B);
                      Seek(HdrFile, k+StrToInt(FlsOffset));
                      Write(HdrFile, B);
                    end;
                  CloseFile(RadioFile);
                  CloseFile(HdrFile);
                  WriteLn('ok');
                end
              else {if (FileExists(FlsRadio) = False) }WriteLn('- not found');
            end;
          CloseFile(FlsFile);
        end
      else {if FileExists() = False }WriteLn(' Game not found!');
    WriteLn;
    end;
  WriteLn(' Press ENTER to shake the Earth...');
  ReadLn;
end.
