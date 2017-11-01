unit ArrayAssocClass;

interface

uses
  Classes, SysUtils, Variants;

type

  IArray = interface
  ['{E781B510-8FD6-49E6-A1BE-B2BDF4074898}']
    function GetItem: Variant;
    procedure SetItem(AItem: Variant);
    function GetValues(Index: string): IArray;
    procedure SetValues(Index: string; const Value: IArray);
    function GetItemIsEmpty: Boolean;
    property IsEmpty: Boolean read GetItemIsEmpty;
    property Value: Variant read GetItem write SetItem;
    property Items[Index: string]: IArray read GetValues write SetValues; default;
  end;

  TArrayAssocProperty = class(TInterfacedObject, IArray)
  private
    FKey: String;
    FItem: Variant;
    function GetItem: Variant;
    procedure SetItem(AItem: Variant);
    function GetValues(Index: string): IArray;
    procedure SetValues(Index: string; const Value: IArray);
    function GetItemIsEmpty: Boolean;       
    property IsEmpty: Boolean read GetItemIsEmpty;
    property Items[Index: string]: IArray read GetValues write SetValues; default;
  public
    constructor Create(AKey: String; AItem: Variant);
    property Key: String read FKey write FKey;
    property Value: Variant read GetItem write SetItem;
  end;

  TArrayAssocClass = class(TInterfacedObject, IArray)
  private
    Owner: TObject;
    FKeyItems: Array of String;
    FItems: Array of IArray;
    function GetItemIsEmpty: Boolean;
    procedure Edit(Key: Integer; KeyName: String; Value: IArray);
    function GetValues(Index: string): IArray;
    procedure SetValues(Index: string; const Value: IArray);
    function GetValuesAtIndex(Index: Integer): IArray;
    function ValueExists(Index: string; const Value: IArray): boolean;
    function KeyExists(Index: String): boolean;   
    function GetItem: Variant;
    procedure SetItem(AItem: Variant);
    function IndexOf(AIndex: String): Integer;        
    property Value: Variant read GetItem write SetItem;
  public
    constructor Create(Index: Array of String; FArrayAssoc: Array of IArray);
    procedure Add(Key: String; Value: IArray);
    property IsEmpty: Boolean read GetItemIsEmpty;
    property ItemsAtIndex[Index: Integer]: IArray read GetValuesAtIndex;
    property Items[Index: string]: IArray read GetValues write SetValues; default;
  end;

implementation

{ TArrayAssocClass }

function TArrayAssocClass.GetItem: Variant;
begin
  
end;

function TArrayAssocClass.GetItemIsEmpty: Boolean;
var
  I: Integer;
begin
  for I := 0 to High(FItems) do
    if I > 0 then
      Break;
  Result := (I > -1);
end;

{ TArrayAssoc }

function TArrayAssocClass.ValueExists(Index: string; const Value: IArray): boolean;
begin
  Result := Assigned(FItems[IndexOf(Index)]);
end;   

function TArrayAssocClass.KeyExists(Index: String): boolean;
begin
  Result := IndexOf(Index) > -1;
end;

procedure TArrayAssocClass.Add(Key: String; Value: IArray);
var
  I: Integer;
begin
  if not KeyExists(Key) then
  begin
    I := Length(FKeyItems);
    SetLength(FKeyItems, Length(FKeyItems)+ 1);
    FKeyItems[I] := Key;
  end;
  I := Length(FItems);
  SetLength(FItems, Length(FItems)+ 1);
  FItems[I] := Value;
end;

constructor TArrayAssocClass.Create(Index: Array of String; FArrayAssoc: array of IArray);
var
  I: Integer;
begin
  for I := 0 to High(FArrayAssoc) do
    Add(Index[I], FArrayAssoc[I]);
end;

procedure TArrayAssocClass.Edit(Key: Integer; KeyName: String; Value: IArray);
begin
  FKeyItems[Key] := KeyName;
  FItems[Key] := Value;
end;

function TArrayAssocClass.GetValues(Index: string): IArray;
var
  VIndex: Integer;
begin
  VIndex := IndexOf(Index);
  if Assigned(FItems[VIndex]) then
    Result := FItems[VIndex];
end;

function TArrayAssocClass.GetValuesAtIndex(Index: Integer): IArray;
begin
  Result := FItems[Index];
end;

function TArrayAssocClass.IndexOf(AIndex: String): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to High(FKeyItems) do
    if FKeyItems[I] = AIndex then
    begin
      Result := I;
      Break;
    end;
end;

procedure TArrayAssocClass.SetItem(AItem: Variant);
begin

end;

procedure TArrayAssocClass.SetValues(Index: string; const Value: IArray);
var
  VIndex: Integer;
begin
  VIndex := IndexOf(Index);
  if VIndex > -1 then
    if FKeyItems[VIndex] <> '' then
      FItems[VIndex] := Value
    else
      Add(Index, Value)
  else
  begin
    if (High(FItems) = 0) and (not ValueExists(Index, Value)) then
      if not Assigned(FItems[High(FItems)]) then
        Edit(High(FItems), Index, Value)
      else
        Add(Index, Value)
    else
      Add(Index, Value);
  end;
end;

{ TArrayAssocProperty }

constructor TArrayAssocProperty.Create(AKey: String; AItem: Variant);
begin
  FKey := AKey;
  FItem := AItem;
end;

function TArrayAssocProperty.GetItem: Variant;
begin
  Result := FItem;
end;

function TArrayAssocProperty.GetItemIsEmpty: Boolean;
begin
  Result := VarIsNull(FItem) or VarIsEmpty(FItem)
end;

function TArrayAssocProperty.GetValues(Index: string): IArray;
begin
  Result := nil;
end;

procedure TArrayAssocProperty.SetItem(AItem: Variant);
begin
  FItem := AItem;
end;

procedure TArrayAssocProperty.SetValues(Index: string; const Value: IArray);
begin

end;

end.
