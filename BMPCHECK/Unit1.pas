unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure Calc_LR(str1,str2:string);
var
  bmp1,bmp2:TBitmap;
  clr1,clr2:Tcolor;
  i,j,s,sum:integer;
  bmp1_bool:array[0..1920] of boolean;
  bmp2_bool:array[0..1920] of boolean;

begin
  for i:=0 to 1920 do
     begin
       bmp1_bool[i]:=false;
       bmp2_bool[i]:=false;
     end;

  bmp1:=tbitmap.create;
  bmp2:=tbitmap.create;
  bmp1.loadfromfile(str1);
  bmp2.loadfromfile(str2);
  s:=0;
  //Calc Bmp 1!

  for i:=0 to 1920 do
    begin
      sum:=0;
      for j:=65 to 72 do
        if bmp1.canvas.Pixels[j,i]=clblack then inc(sum);
      if sum>=4 then bmp1_bool[i]:=true;
    end;

  //Calc Bmp 2!
  for i:=0 to 1920 do
    begin
      sum:=0;
      for j:=0 to 7 do
        if bmp2.canvas.Pixels[j,i]=clblack then inc(sum);
      if sum>=4 then bmp2_bool[i]:=true;
    end;

  bmp1.free;
  bmp2.free;

  s:=0;
  for i:=0 to 1920 do
    if (bmp1_bool[i]) and (bmp2_bool[i]) then inc(s);

  if s>=30 then showmessage(str1+' RIGHT Matches '+str2+' LEFT');
end;





procedure CALC_4D(str1,str2:string);
var
  bmp1,bmp2:TBitmap;
  clr1,clr2:TColor;
  i:integer;


procedure Calc(WorkMode:integer);
var
  i,j,s,sum:integer;
  bmp1_bool:array[0..180] of boolean;
  bmp2_bool:array[0..180] of boolean;

begin

   for i:=0 to 180 do
     begin
       bmp1_bool[i]:=false;
       bmp2_bool[i]:=false;
     end;


   s:=0;


//WorkMode1:A's up and B's bot.

if WorkMode=1 then
begin
  for i:=0 to 72 do
    begin
      sum:=0;
      for j:=0 to 15 do
       if bmp1.canvas.Pixels[i,j]=clblack then inc(sum);
       if sum>=7 then bmp1_bool[i]:=true;
    end;

   for i:=0 to 72 do
    begin
      sum:=0;
      for j:=165 to 180 do
        if bmp2.canvas.Pixels[i,j]=clblack then inc(sum);
      IF sum>=7 then bmp2_bool[i]:=true;
    end;


    s:=0;
  for i:=0 to 72 do
    if (bmp1_bool[i]) and (bmp2_bool[i]) then inc(s);
  if s>=5 then showmessage(inttostr(s)+'!!'+str1+'TOP Matches '+str2+' BOTTOM.');
  end;

 //WorkMode4:A's bot and B's UP.

if WorkMode=4 then
begin
  for i:=0 to 72 do
    begin
      sum:=0;
      for j:=165 to 180 do
        if bmp1.canvas.Pixels[i,j]=clblack then inc(sum);
       if sum>=7 then bmp1_bool[i]:=true;
    end;

   for i:=0 to 72 do
    begin
      sum:=0;
      for j:=0 to 15 do
        if bmp2.canvas.Pixels[i,j]=clblack then inc(sum);
      IF sum>=7 then bmp2_bool[i]:=true;
    end;


    s:=0;
  for i:=0 to 72 do
    if (bmp1_bool[i]) and (bmp2_bool[i]) then inc(s);
  if s>=5 then showmessage(inttostr(s)+'!!'+str1+'BOTTOM Matches '+str2+' TOP.');
  end;




//WorkMode2:A's left and B's right.
 if WorkMode=2 then
   begin
     for i:=0 to 180 do
    begin
      sum:=0;
      for j:=0 to 15 do
        if bmp1.canvas.Pixels[j,i]=clblack then inc(sum);
       if sum>=7 then bmp1_bool[i]:=true;
    end;

   for i:=0 to 180 do
    begin
      sum:=0;
      for j:=58 to 72 do
        if bmp2.canvas.Pixels[j,i]=clblack then inc(sum);
      IF sum>=7 then bmp2_bool[i]:=true;
    end;


    s:=0;
  for i:=0 to 180 do
    if (bmp1_bool[i]) and (bmp2_bool[i]) then inc(s);
  if s>=16 then showmessage(inttostr(s)+'!!'+str1+'LEFT Matches '+str2+' RIGHT.');
 end;


//WorkMode3:A'right is to B's left.
if WorkMode=3 then
   begin
     for i:=0 to 180 do
    begin
      sum:=0;
      for j:=58 to 72 do
        if bmp1.canvas.Pixels[j,i]=clblack then inc(sum);
       if sum>=7 then bmp1_bool[i]:=true;
    end;

   for i:=0 to 180 do
    begin
      sum:=0;
      for j:=0 to 15 do
        if bmp2.canvas.Pixels[j,i]=clblack then inc(sum);
      IF sum>=7 then bmp2_bool[i]:=true;
    end;


    s:=0;
  for i:=0 to 180 do
    if (bmp1_bool[i]) and (bmp2_bool[i]) then inc(s);
  if s>=16 then showmessage(inttostr(s)+'!!'+str1+'RIGHT Matches '+str2+' LEFT.');

 end;





  bmp1.free;
  bmp2.free;






end;

begin


  for i:=1 to 4 do
    begin
       bmp1:=TBitmap.create;
       bmp2:=TBitmap.Create;
       bmp1.LoadFromFile(str1);
       bmp2.LoadFromFile(str2);
       Calc(i);
    end;


end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j:integer;
  str1,str2:string;
begin
  for i:=0 to 18 do
    for j:=0 to 18 do
        if i<>j then
          begin
            str1:='0';
            str2:='0';
            if i<10 then str1:=str1+'0';
            if j<10 then str2:=str2+'0';
            str1:=str1+inttostr(i)+'.bmp';
            str2:=str2+inttostr(j)+'.bmp';
            Calc_LR(str1,str2);
            Application.ProcessMessages;
          end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i,j:integer;
  str1,str2:string;
begin
   for i:=0 to 208 do
    for j:=0 to 208 do
        if i<>j then
          begin
            str1:='';
            str2:='';
            if i<10 then str1:=str1+'00';
            if j<10 then str2:=str2+'00';
            if (i>=10) and (i<100) then str1:=str1+'0';
            if (j>=10) and (j<100) then str2:=str2+'0';
            str1:=str1+inttostr(i)+'.bmp';
            str2:=str2+inttostr(j)+'.bmp';
            Calc_4D(str1,str2);
            application.ProcessMessages;
          end;
end;

end.
