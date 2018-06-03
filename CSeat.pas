//Author: Ahmed El-Naggar
//aelna0@eq.edu.au

unit CSeat;

interface

uses ShowFrame, Vcl.ExtCtrls, Vcl.Forms; // TShape, TFrame

type TSeat = class

    private
        id         : Integer; // The ID of the seat, ideally should be static and then iterated within this class for every instance,
                              // but that is not possible in delphi apparently
        taken      : Boolean;

        price      : Real; 
        _type      : Integer; // The type of seat, is it premium or normal
        

    published

        constructor create(id : Integer);

        function is_taken()                : Boolean;
        function get_num()                 : Integer; // Return the seat number
        function get_type()                : String;
        function get_price()               : Real;

        procedure set_price(price : Real);
        procedure set_id(new_id : Integer);
        procedure set_type(_type : Integer);
        procedure occupy(taken : Boolean);

end;

implementation

constructor TSeat.create(id : Integer);
begin

    self.id     := id;
    self.taken  := false;

end;

function Tseat.is_taken() : Boolean;
begin

    Result := self.taken;

end;

procedure TSeat.set_price(price : Real);
begin
  self.price := price
end;

procedure TSeat.set_type(_type : Integer);
begin
  self._type := _type;
end;


procedure TSeat.set_id(new_id : Integer);
begin
  self.id := new_id;
end;

procedure TSeat.occupy(taken : Boolean);
begin
  
    self.taken := taken;

end;

function TSeat.get_num(): Integer;
begin
  
    Result := self.id;

end;

function TSeat.get_type(): String;
begin
  
    if(self._type = 0) then 
        Result := 'Regular'
    else
        Result := 'Premium'

end;

function TSeat.get_price(): Real;
begin
  
    Result := self.price;

end;

end.
