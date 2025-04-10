unit Unit2;

interface

uses
  System.SysUtils, System.Classes, Unit1;

type
  TDataModule2 = class(TDataModule)
    Miecz: TItem;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule2: TDataModule2;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

end.
