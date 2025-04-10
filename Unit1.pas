unit Unit1;

interface

uses
  System.Classes;

type
  TItem = class(TComponent)
private
  FName: string;
  FDamage: Integer;
  FOwns: Boolean;
published
  property Name: string read FName write FName;
  property Damage: Integer read FDamage write FDamage;
  property Owns: Boolean read FOwns write FOwns;
end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('GameItems', [TItem]);
end;

end.

