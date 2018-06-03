//CShow class
//This class will handle everything related to a show
//A show contains seats and has guests

//Author: Ahmed El-Naggar
//aelna0@eq.edu.au

unit CShow;

interface

uses CSeat, 
     CGuest,
     System.Generics.Collections, // TObjectList
     Vcl.Forms,
     Vcl.ExtCtrls; //TShape
  

type
  TShow = class

  private
    id        : Integer;
    seats     : TObjectList<CSeat.TSeat>;  // Seats, instances of CSeat

    gfx_seats : TObjectList<TShape>; // The actual viewable seats

    seat      : CSeat.TSeat;
    guests    : TObjectList<CGuest.TGuest>; // Guests, instances of Guests

    name      : String; // Name of the show

  published

    constructor create(name : String);

    function add_guest(guest   : CGuest.TGuest)              : Boolean;
    function add_guests(guests : TObjectList<CGuest.TGuest>) : Boolean;
    function add_seat(seat   : CSeat.TSeat)                  : Boolean;
    function add_seats(seats : TObjectList<CSeat.TSeat>)     : Boolean;

    function get_seats()                                     : TObjectList<TSeat>;
    function get_seat(seat_num : Integer)                    : TSeat;
    function get_num_guests()                                : Integer; // Returns the number of guests attending
    function get_num_seats()                                 : Integer;

end;

implementation

constructor TShow.create(name : String);
begin
  self.name := name;

  self.seats      := TObjectList<CSeat.TSeat>.Create();
  self.guests     := TObjectList<CGuest.TGuest>.Create();

  self.gfx_seats  := TObjectList<TShape>.Create();

end;

function TShow.add_guest(guest : CGuest.TGuest) : Boolean;
begin

  //Assign the user his/her seat
  //Make sure that seats are made first

  self.guests.Add(guest);

  guest.set_seat(self.seats[guest.get_seat()]);

  Result := true;
end;
function TShow.add_guests(guests : TObjectList<CGuest.TGuest>) : Boolean;
begin

  Result := true;
end;

function TShow.add_seat(seat : CSeat.TSeat) : Boolean;
begin
  
  self.seats.Add(seat);

  // If the seat ID is between 0 to 18
  // then the seat is considered to be a premium seat as it is close to the stage | Premium seat: 1, Regular seat: 0
  if((seat.get_num >= 0) and (seat.get_num() <= 18)) then
  begin
    seat.set_type(1);
    seat.set_price(30.0);
  end
  else
  begin
    seat.set_type(0);
    seat.set_price(10.0);
  end;

  Result := true;
end;

//Adds seats to show
//Parameters:
// seats (array of TSeat instances)
function TShow.add_seats(seats : TObjectList<CSeat.TSeat>) : Boolean;
begin
  
end;

function TShow.get_seats() : TObjectList<CSeat.TSeat>;
begin
  Result := self.seats;
end;

function TShow.get_seat(seat_num : Integer) : CSeat.TSeat;
begin
  Result := self.seats[seat_num];
end;

function TShow.get_num_seats() : Integer;
begin
  Result := self.seats.Count;
end;



function TShow.get_num_guests() : Integer;
begin
  Result := self.guests.Count;
end;


end.
