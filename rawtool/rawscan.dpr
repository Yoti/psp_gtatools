program rawscan;

{$APPTYPE CONSOLE}

uses
  Windows, SysUtils;

var
  b: Cardinal; //b: Byte;
  s: String;
  OffFile: TextFile;
  RawFile: File; //RawFile: File of Byte;
  VagFile: File; //VagFile: File of Byte;
  Items, Size, i, k, RawSize, VagSize: Integer;
  //Debug
  d: Byte;
  n: Integer;
  Debug: Boolean;
  FileName: String;
  NamFile: TextFile;

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
  SetConsoleTitle(PChar('rawscan'));
  Sleep(50);
  WriteLn(' RawScan by Yoti @ gtamodding.ru # build 27.03.2011/R4');
  WriteLn(' -----------------------------------------------------');

  if (ParamCount = 0) then
  begin
    WriteLn(' Using: rawscan.exe filename.raw');
    WriteLn;
    {WriteLn('Press any key to exit...');
    ReadLn;
    Exit;}
  end;

  if (ParamCount >= 1) then
  begin
    if (ParamStr(2) <> 'debug')
    then Debug:=False
    else
      begin
        Debug:=True;
        WriteLn(' ----------------{ THERE iS NO SPOON }----------------');
        WriteLn(' -----------------------------------------------------');
      end;

    if (FileExists(ParamStr(1)) = True) then
      begin
        i:=0;
        Size:=0;
        Items:=0;

        AssignFile(RawFile, ParamStr(1));
        Reset(RawFile, 1);
          RawSize:=FileSize(RawFile);
        CloseFile(RawFile);

        WriteLn;
        WriteLn(' Source file ['+ExtractFileName(ParamStr(1))+'] is '+IntToStr(RawSize)+' bytes');
        WriteLn;
        WriteLn('     OFFSET  SiGN           SiZE');
             // ' 0x????????: VAGp, size is ????? (0x30+0x????) bytes'

        AssignFile(OffFile, ExtractFilePath(ParamStr(1))+ChangeFileExt(ExtractFileName(ParamStr(1)), '.OLS'));
        Rewrite(OffFile);
        AssignFile(RawFile, ParamStr(1));
        Reset(RawFile, 4);
        if (Debug = True)
        then
          begin
            AssignFile(NamFile, ExtractFilePath(ParamStr(1))+ChangeFileExt(ExtractFileName(ParamStr(1)), '.FLS'));
            Rewrite(NamFile);
          end;
        while not EOF(RawFile) //for i:=0 to RawSize-4
        do
          begin
            BlockRead(RawFile, b, 1);
            if b = $70474156 then
              begin
                writeln('ok!');
               {
                            s:='';
                            Seek(RawFile, i+14);
                            Read(RawFile, b);
                            s:=s+IntToHex(b, 2);
                            Seek(RawFile, i+15);
                            Read(RawFile, b);
                            s:=s+IntToHex(b, 2);
                            VagSize:=StrToInt('$'+s)+StrToInt('$30');
                            WriteLn(' 0x'+IntToHex(i, 8)+': VAGp, size is '+IntToStrEx(VagSize, 5)+' (0x30+0x'+s+') bytes');

                            WriteLn(OffFile, IntToHex(i, 8)+','+IntToStrEx(VagSize, 5));
                            if (Debug = True)
                            then
                              begin
                                FileName:='';
                                for n:=$20 to $2F do
                                  begin
                                    Seek(RawFile, i+n);
                                    Read(RawFile, d);
                                    if (d <> $00)
                                    then FileName:=FileName+Chr(d);
                                  end;
                                WriteLn(NamFile, IntToHex(i, 8)+','+FileName);
                              end;

                            Inc(Items);
                            Size:=Size+VagSize;

                            if DirectoryExists(ExtractFilePath(ParamStr(1))+ChangeFileExt(ExtractFileName(ParamStr(1)), '.DiR')) = False
                            then MkDir(ExtractFilePath(ParamStr(1))+ChangeFileExt(ExtractFileName(ParamStr(1)), '.DiR'));
                            AssignFile(VagFile, ExtractFilePath(ParamStr(1))+ChangeFileExt(ExtractFileName(ParamStr(1)), '.DiR')+'\'+IntToHex(i, 8)+'.VAG');
                            Rewrite(VagFile);
                            for k:=0 to VagSize-1
                            do
                              begin
                                Seek(RawFile, i+k);
                                Read(RawFile, b);
                                Seek(VagFile, k);
                                Write(VagFile, b);
                              end;
                            CloseFile(VagFile);
                          end;
                      end;}
              end;
            i:=i+4;
          end;
        CloseFile(RawFile);
        CloseFile(OffFile);
        if (Debug = True)
        then CloseFile(NamFile);
        WriteLn;
        WriteLn(' Total: '+IntToStr(Items)+' items, '+IntToStr(Size)+' bytes - done!');
      end
    else
      begin
        WriteLn;
        WriteLn(' Source file "'+ParamStr(1)+'" not exists =(');
      end;
    WriteLn;
    {WriteLn('Press any key to exit...');
    ReadLn;
    Exit;}
  end;

end.
