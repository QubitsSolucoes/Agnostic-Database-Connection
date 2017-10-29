unit ArrayAssoc;

interface

uses
  Classes, SysUtils, RTLConsts;

type

  TArrayAssoc = record
  private
    FKeyItems: Array of String;
    FItems: Array of String;
    procedure Edit(Key: Integer; KeyName, Value: string);
    function GetValues(Index: string): string;
    function GetValuesAtIndex(Index: Integer): String;
    procedure SetValues(Index: string; const Value: String);
    function GetIsEmpty: Boolean;
    function ValueExists(Index: string; const Value: String): boolean;
  public
    property IsEmpty: Boolean read GetIsEmpty;
    procedure Add(Key, Value: string);
    property ItemsAtIndex[Index: Integer]: String read GetValuesAtIndex;
    property Items[Index: string]: String read GetValues write SetValues; default;
  end;

  TArrayAssocBi = record
  private
    FKeyItems: Array of String;
    FItems: Array of TArrayAssoc;
    function GetValues(Index: string): TArrayAssoc;
    function GetValuesAtIndex(Index: Integer): TArrayAssoc;
    procedure SetValues(Index: string; const Value: TArrayAssoc);
  public
    procedure Add(Key: string; Value: TArrayAssoc); overload;
    property ItemsAtIndex[Index: Integer]: TArrayAssoc read GetValuesAtIndex;
    property Items[Index: string]: TArrayAssoc read GetValues write SetValues; default;
  end;

implementation

{ TArrayAssoc }

function TArrayAssoc.ValueExists(Index: string; const Value: String): boolean;
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

procedure TArrayAssoc.Add(Key, Value: string);
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

procedure TArrayAssoc.Edit(Key: Integer; KeyName, Value: string);
begin
  FKeyItems[Key] := KeyName;
  FItems[Key] := Value;
end;

function TArrayAssoc.GetIsEmpty: Boolean;
var
  I: Integer;
begin
  for I := 0 to High(FItems) do
    if I > 0 then
      Break;
  Result := I > -1;
end;

function TArrayAssoc.GetValues(Index: string): string;
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

function TArrayAssoc.GetValuesAtIndex(Index: Integer): string;
begin
  Result := FItems[Index];
end;

procedure TArrayAssoc.SetValues(Index: string; const Value: string);
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

{ TArrayAssocBi }

procedure TArrayAssocBi.Add(Key: string; Value: TArrayAssoc);
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
      I := Length(FItems);
      SetLength(FItems, Length(FItems)+ 1);
      FItems[I] := Value;
      //Setar valores do array de ArrayAssoc
      J := Length(FItems[I].FKeyItems);
      SetLength(FItems[I].FKeyItems, Length(FItems[I].FKeyItems)+ 1);
      FItems[I].FKeyItems[J] := '';
      J := Length(FItems[I].FItems);
      SetLength(FItems[I].FItems, Length(FItems[I].FItems)+ 1);
      FItems[I].FItems[J] := '';
    end
    else
      SetValues(Key, Value);
  end;
end;

function TArrayAssocBi.GetValuesAtIndex(Index: Integer): TArrayAssoc;
begin
  Result := FItems[Index];
end;

function TArrayAssocBi.GetValues(Index: string): TArrayAssoc;
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
    Result := ItemsAtIndex[IResult]
  else
  begin
    Add(Index, Result);
    Result := FItems[High(FItems)];
  end;
end;

procedure TArrayAssocBi.SetValues(Index: string; const Value: TArrayAssoc);
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

  if (IResult > -1) then
    if FKeyItems[IResult] <> '' then
      Items[Index] := Value
    else
      Add(Index, Value)
  else
    Add(Index, Value);
end;

end.
