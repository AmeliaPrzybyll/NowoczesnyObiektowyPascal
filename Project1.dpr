program Project1;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.StrUtils,
  Unit1 in 'Unit1.pas',
  Unit2 in 'Unit2.pas' {DataModule2: TDataModule};

type
  TSkarb = (Brak, Miecz, Pierscien);

var
  Skarb: TSkarb;
  HP: Integer;
  Sword: TItem;

procedure PokazMape(Aktualna: string);
begin
  Writeln;
  Writeln('======================');
  Writeln('|        Zamek       | ', IfThen(Aktualna = 'Zamek', '<-- tutaj'));
  Writeln('|         |          |');
  Writeln('|        Las         | ', IfThen(Aktualna = 'Las', '<-- tutaj'));
  Writeln('|         |          |');
  Writeln('|      Jaskinia      | ', IfThen(Aktualna = 'Jaskinia', '<-- tutaj'));
  Writeln('|   |           |    |');
  Writeln('|Komora1   Komora2   | ',
          IfThen(Aktualna = 'Komora1', '<-- tutaj'),
          IfThen(Aktualna = 'Komora2', '<-- tutaj'));
  Writeln('======================');
  Writeln;
end;


procedure Troll;
var
  C: Char;
  GraczRzut, TrollRzut: Integer;
begin
  Writeln('Na twojej drodze staje troll! Walczysz? (t/n)');
  Readln(C);

  case C of
    't':
      begin
        Randomize;
        TrollRzut := Random(6) + 1;
        GraczRzut := Random(6) + 1;
        if DataModule2.Miecz.Owns then
          Inc(GraczRzut, DataModule2.Miecz.Damage);


        Writeln('Twój rzut: ', GraczRzut, ', rzut trolla: ', TrollRzut);

        if GraczRzut > TrollRzut then
        begin
          Writeln('Pokonałeś trolla!');
          Writeln('Zyskujesz +1 punkt życia.');
          Inc(HP);
        end
        else
        begin
          Dec(HP);
          Writeln('Przegrałeś walkę z trollem. Tracisz 1 punkt życia.');
          if HP <= 0 then
          begin
            Writeln('Zmarłeś w walce. Koniec gry.');
            Halt;
          end;
        end;
      end;
    'n':
      begin
        Writeln('Uciekłeś przed trollem.');
      end;
  else
    begin
      Writeln('Nieprawidłowa odpowiedź, jeszcze raz');
      Troll;
    end;
  end;
end;


procedure Jaskinia; forward;
procedure Las; forward;
procedure Zamek; forward;
procedure Komora1; forward;
procedure Komora2; forward;

procedure Jaskinia;
var
  C: Char;
begin
  PokazMape('Jaskinia');
  Writeln('Jesteś w jaskini.');
  Writeln('l - ide w lewo');
  Writeln('p - idę w prawo');
  Writeln('w - wracasz do lasu');
  Readln(C);

  case C of
    'l': Komora1;
    'p': Komora2;
    'w': Las;
  else
    begin
      Writeln('Nieprawidłowa odpowiedż, jeszcze raz');
      Jaskinia;
    end;
  end;
end;

procedure Komora1;
var
  C: Char;
  GraczRzut, SmokRzut: Integer;
begin
  PokazMape('Komora1');
  Writeln('Słyszysz dziwne dzwięki.');
  Writeln('W komorze jest smok! Walczysz? (t/n)');
  Readln(C);

  case C of
    't': begin
          Randomize;
          SmokRzut := Random(6) + 1;
          GraczRzut := Random(6) + 1;

          if DataModule2.Miecz.Owns then
            Inc(GraczRzut, DataModule2.Miecz.Damage);

          Writeln('Twój rzut: ', GraczRzut, ', rzut smoka: ', SmokRzut);

          if GraczRzut > SmokRzut then
          begin
            Writeln('Pokonałeś smoka!');
            Jaskinia;
          end
          else
          begin
            Dec(HP);
            Writeln('Przegrałeś walkę. Tracisz 1 punkt życia.');
            if HP <= 0 then
            begin
              Writeln('Zmarłeś w walce. Koniec gry.');
            end
            else
              Jaskinia;
          end;
        end;
    'n': begin
           Writeln('Uciekłeś z powrotem do jaskini.');
           Jaskinia;
         end;
  else
    begin
      Writeln('Nieprawidłowa odpowiedż, jeszcze raz');
      Komora1;
    end;
  end;
end;

procedure Komora2;
var
  Los: Integer;
begin
  PokazMape('Komora2');
  if Skarb <> Brak then
  begin
    Writeln('Zabrałeś już skarb. Wracasz do jaskini.');
  end
  else
  begin
    Randomize;
    Los := Random(2);
    if Los = 0 then
    begin
      DataModule2.Miecz.Owns := True;
      Writeln('Znalazłeś miecz: ', DataModule2.Miecz.Name, ' (siła: ', DataModule2.Miecz.Damage, ')');
    end
    else
    begin
      Skarb := Pierscien;
      Writeln('Znalazłeś pierścień!');
    end;
  end;
  Jaskinia;
end;

procedure Las;
var
  C: Char;
  Spotkanie: Integer;
begin
  PokazMape('Las');
  Writeln;

  Randomize;
  Spotkanie := Random(100);
  if Spotkanie < 50 then
    Troll;

  Writeln('Jesteś w lesie');
  Writeln('l - idę w lewo (zamek)');
  Writeln('p - idę w prawo (jaskinia)');
  Readln(C);

  case C of
    'l': Zamek;
    'p': Jaskinia;
  else
    begin
      Writeln('Nieprawidłowa odpowiedź, jeszcze raz');
      Las;
    end;
  end;
end;


procedure Zamek;
var
  C: Char;
  R: Integer;
begin
  PokazMape('Zamek');
  Writeln('Jesteś w zamku');
  Writeln('w - wróć do lasu');
  Writeln('z - zostań');

  Readln(C);

  case C of
    'w': Las;
    'z':
      begin
        if DataModule2.Miecz.Owns then
        begin
          Writeln('Masz miecz: ', DataModule2.Miecz.Name, '! Zostałeś pasowany na rycerza');
        end
        else if Skarb = Pierscien then
        begin
          Writeln('Masz pierścień!');
          Writeln('Księżniczka zakochała się w pierścieniu!');
          Writeln('Poślubiasz księżniczkę! Gratulacje!');
        end
        else
        begin
          Writeln('Nie masz nic do zaoferowania...');
          Randomize;
          R := Random(100);
          if R < 25 then
          begin
            Writeln('Zostajesz ścięty! Koniec gry.');
          end
          else
          begin
            Writeln('Zostajesz wyrzucony z zamku.');
            Las;
            Exit;
          end;
        end;
      end;
  else
    begin
      Writeln('Nieprawidłowa odpowiedź, jeszcze raz');
      Las;
    end;
  end;
end;



begin
  DataModule2 := TDataModule2.Create(nil);
  Skarb := Brak;
  HP := 3;
  Las;
  Writeln('Koniec');
  Readln;
end.
