program weak_ref_trap;

{ THIS EXAMPLE HAS A DELIBERATE, QUITE SUBTLE TO NOTICE, ERROR.

  Run it to see:

    Dracula attacks!
    Wolfie tickles!
    No creature with which to attack!
    Wolfie tickles!
    Wolfie attacks!
    Wolfie tickles!
    No creature with which to attack!
    tickles!

  Last line is weird -- looks like Name='' when invoking TickleWithMostFurry
  from ThisFails?
  Why?
  How to fix it?
 }

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Classes;

type
  TCreature = class(TComponent)
  public
    Name: String;
  end;

  TMyCreatureManager = class(TComponent)
  strict private
    FMostFearsome: TCreature;
    FMostFurry: TCreature;
    procedure SetMostFearsome(const Value: TCreature);
    procedure SetMostFurry(const Value: TCreature);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    destructor Destroy; override;
    property MostFearsome: TCreature read FMostFearsome write SetMostFearsome;
    property MostFurry: TCreature read FMostFurry write SetMostFurry;
    procedure AttackWithMostFearsome;
    procedure TickleWithMostFurry;
  end;

{ TMyCreatureManager }

procedure TMyCreatureManager.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
//  if (Operation = opRemove) and (AComponent = FMostFearsome) then
//    { set to nil by SetMostFearsome to clean nicely }
//    MostFearsome := nil;
//  if (Operation = opRemove) and (AComponent = FMostFurry) then
//    { set to nil by SetMostFurry to clean nicely }
//    MostFurry := nil;

//zmodyfikowa³am to tak ¿e ustawia oba pola na nil, gdy ktoreœ z nich wskazuje an nieuzywany komponent
  if (Operation = opRemove) then
  begin
    if AComponent = FMostFearsome then
      SetMostFearsome(nil);
    if AComponent = FMostFurry then
      SetMostFurry(nil);
  end;
end;

procedure TMyCreatureManager.SetMostFearsome(const Value: TCreature);
begin
  if FMostFearsome <> Value then
  begin
    if FMostFearsome <> nil then
      FMostFearsome.RemoveFreeNotification(Self);
    FMostFearsome := Value;
    if FMostFearsome <> nil then
      FMostFearsome.FreeNotification(Self);
  end;
end;

procedure TMyCreatureManager.SetMostFurry(const Value: TCreature);
begin
  if FMostFurry <> Value then
  begin
    if FMostFurry <> nil then
      FMostFurry.RemoveFreeNotification(Self);
    FMostFurry := Value;
    if FMostFurry <> nil then
      FMostFurry.FreeNotification(Self);
  end;
end;

destructor TMyCreatureManager.Destroy;
begin
  { set to nil by SetMostFearsome, to detach free notification }
  MostFearsome := nil;
  { set to nil by SetMostFurry, to detach free notification }
  MostFurry := nil;
  inherited;
end;

procedure TMyCreatureManager.AttackWithMostFearsome;
begin
  if MostFearsome <> nil then
    Writeln(MostFearsome.Name, ' attacks!')
  else
    Writeln('No creature with which to attack!');
end;

procedure TMyCreatureManager.TickleWithMostFurry;
begin
  if MostFurry <> nil then
    Writeln(MostFurry.Name, ' tickles!')
  else
    Writeln('No creature with which to tickle!');
end;

{ Main program }

procedure ThisWorks;
var
  MyCreatureManager: TMyCreatureManager;
  Werewolf: TCreature;
  Vampyre: TCreature;
begin
  try
    Werewolf := TCreature.Create(nil);
    Werewolf.Name := 'Wolfie';

    Vampyre := TCreature.Create(nil);
    Vampyre.Name := 'Dracula';

    MyCreatureManager := TMyCreatureManager.Create(nil);
    MyCreatureManager.MostFearsome := Vampyre;
    MyCreatureManager.MostFurry := Werewolf;
    MyCreatureManager.AttackWithMostFearsome;
    MyCreatureManager.TickleWithMostFurry;

    MyCreatureManager.MostFearsome := nil;

    MyCreatureManager.AttackWithMostFearsome;
    MyCreatureManager.TickleWithMostFurry;
  finally
    FreeAndNil(MyCreatureManager); // najpierw manager
    FreeAndNil(Werewolf);
  end;
end;

procedure ThisFails;
var
  MyCreatureManager: TMyCreatureManager;
  Werewolf: TCreature;
begin
  try
    Werewolf := TCreature.Create(nil);
    Werewolf.Name := 'Wolfie';

    MyCreatureManager := TMyCreatureManager.Create(nil);
    MyCreatureManager.MostFearsome := Werewolf;
    MyCreatureManager.MostFurry := Werewolf;

    MyCreatureManager.AttackWithMostFearsome;
    MyCreatureManager.TickleWithMostFurry;

    MyCreatureManager.MostFearsome := nil;
    FreeAndNil(Werewolf); // manager zostanie o tym poinformowany przez Notification

    MyCreatureManager.AttackWithMostFearsome;
    MyCreatureManager.TickleWithMostFurry;
  finally
    FreeAndNil(MyCreatureManager); // <- tylko manager do zwolnienia
  end;
end;


begin
  ReportMemoryLeaksOnShutdown := True;

  try
    ThisWorks;
    ThisFails;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

  Readln;
end.
