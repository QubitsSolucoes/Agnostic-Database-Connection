unit ArrayAssocClass;

interface

uses
  Classes, SysUtils;

type

  TArrayAssoc = class
    FKeyItems: Array of String;
    FItems: Array of String;
    FObjectItems: Array of TObject;
    function GetItemIsEmpty: Boolean;
    function GetIsObjectsEmpty: Boolean;
  public
    property IsEmpty: Boolean read GetItemIsEmpty;
    property IsObjectsEmpty: Boolean read GetIsObjectsEmpty;
  end;

  TArrayAssocUni = class(TArrayAssoc)
  private
    procedure Edit(Key: Integer; KeyName, Value: string);
    function GetValues(Index: string): string;
    function GetValuesAtIndex(Index: Integer): String;
    procedure SetValues(Index: string; const Value: String);
    function ValueExists(Index: string; const Value: String): boolean;
  public
    procedure Add(Key, Value: string);
    property ItemsAtIndex[Index: Integer]: String read GetValuesAtIndex;
    property Items[Index: string]: String read GetValues write SetValues; default;
  end;

  TArrayAssocMulti = class(TArrayAssoc)
  private
    function GetValues(Index: string): TArrayAssoc;
    function GetValuesAtIndex(Index: Integer): TArrayAssoc;
    procedure SetValues(Index: string; const Value: TArrayAssoc);
  public
    procedure Add(Key: string; Value: String); overload;
    procedure Add(Key: string; Value: TArrayAssoc); overload;
    property ItemsAtIndex[Index: Integer]: TArrayAssoc read GetValuesAtIndex;
    property Items[Index: string]: TArrayAssoc read GetValues write SetValues; default;
  end;

implementation

{ TArrayAssoc }

function TArrayAssoc.GetIsObjectsEmpty: Boolean;
var
  I: Integer;
begin
  for I := 0 to High(FObjectItems) do
    if I > 0 then
      Break;
  Result := (I > -1);
end;

function TArrayAssoc.GetItemIsEmpty: Boolean;
var
  I: Integer;
begin
  for I := 0 to High(FItems) do
    if I > 0 then
      Break;
  Result := (I > -1);
end;

{ TArrayAssocUni }

function TArrayAssocUni.ValueExists(Index: string; const Value: String): boolean;
var
  I, IResult: Integer;
begin
  IResult := -1;
  for I := 0 to High(FItems) do
    if FKeyItems[I] = Index then
    begin
      IResult := I;
      Break;
    end;
  Result := IResult > -1;
end;

procedure TArrayAssocUni.Add(Key, Value: string);
var
  I: Integer;
begin
  I := Length(FKeyItems);
  SetLength(FKeyItems, Length(FKeyItems)+ 1);
  FKeyItems[I] := Key;
  I := Length(FItems);
  SetLength(FItems, Length(FItems)+ 1);
  FItems[I] := Value;
end;

procedure TArrayAssocUni.Edit(Key: Integer; KeyName, Value: string);
begin
  FKeyItems[Key] := KeyName;
  FItems[Key] := Value;
end;

function TArrayAssocUni.GetValues(Index: string): string;
var
  I, IResult: Integer;
begin
  IResult := -1;
  Result := '';
  for I := 0 to High(FItems) do
    if FKeyItems[I] = Index then
    begin
      IResult := I;
      Break;
    end;
  if IResult > -1 then
    Result := ItemsAtIndex[IResult]
end;

function TArrayAssocUni.GetValuesAtIndex(Index: Integer): string;
begin
  Result := FItems[Index];
end;

procedure TArrayAssocUni.SetValues(Index: string; const Value: string);
var
  I, IResult: Integer;
begin
  IResult := -1;
  for I := 0 to High(FItems) do
    if FKeyItems[I] = Index then
    begin
      IResult := I;
      Break;
    end;

  if IResult > -1 then
    if FKeyItems[IResult] <> '' then
      Items[Index] := Value
    else
      Add(Index, Value)
  else
  begin
    if (High(FItems) = 0) and (not ValueExists(Index, Value)) then
      if FItems[High(FItems)] = '' then
        Edit(High(FItems), Index, Value)
      else
        Add(Index, Value)
    else
      Add(Index, Value);
  end;
end;

{ TArrayAssocMulti }

procedure TArrayAssocMulti.Add(Key: string; Value: TArrayAssoc);
var
  I, J: Integer;
begin
  I := Length(FKeyItems);
  SetLength(FKeyItems, Length(FKeyItems)+ 1);
  FKeyItems[I] := Key;
  if Length(FKeyItems) > 0 then
  begin
    if Value.IsEmpty then
    begin
      I := Length(FObjectItems);
      SetLength(FObjectItems, Length(FObjectItems)+ 1);
      FObjectItems[I] := Value;
      //Setar valores do array de ArrayAssoc
      J := Length(TArrayAssoc(FObjectItems[I]).FKeyItems);
      SetLength(TArrayAssoc(FItems[I]).FKeyItems, Length(TArrayAssoc(FItems[I]).FKeyItems)+ 1);
      TArrayAssoc(FItems[I]).FKeyItems[J] := '';
      J := Length(TArrayAssoc(FItems[I]).FItems);
      SetLength(TArrayAssoc(FItems[I]).FItems, Length(TArrayAssoc(FItems[I]).FItems)+ 1);
      TArrayAssoc(FItems[I]).FItems[J] := '';
    end
    else
      SetValues(Key, Value);
  end;
end;

procedure TArrayAssocMulti.Add(Key, Value: String);
var
  I: Integer;
begin
  I := Length(FKeyItems);
  SetLength(FKeyItems, Length(FKeyItems)+ 1);
  FKeyItems[I] := Key;
  I := Length(FItems);
  SetLength(FItems, Length(FItems)+ 1);
  FItems[I] := Value;
end;

function TArrayAssocMulti.GetValuesAtIndex(Index: Integer): TArrayAssoc;
begin

end;

function TArrayAssocMulti.GetValues(Index: string): TArrayAssoc;
var
  I, IResult: Integer;
begin
  Result := Nil;
  IResult := -1;
  for I := 0 to High(FItems) do
    if FKeyItems[I] = Index then
    begin
      IResult := I;
      Break;
    end;
  if High(FItems) > 0 then
    Result := GetValuesAtIndex(IResult)
  else
    Result := FItems[Index];
end;

procedure TArrayAssocMulti.SetValues(Index: string; const Value: TArrayAssoc);
begin

end;

end.
