program rawname;

{$APPTYPE CONSOLE}

uses
  SysUtils, Windows;

var
  i, k: Integer;
  Name: String;

begin
  for i:=0 to 9
  do
    begin
      for k:=0 to 9
      do
        begin
          if (i = 0)
          then Name:='sfx'+IntToStr(k)+'_psp.raw'
          else Name:='sfx'+IntToStr(i)+IntToStr(k)+'_psp.raw';

          if (FileExists('SET'+IntToStr(i)+'\'+Name) = True)
          then
            begin
            end;
        end;
    end;
end.
