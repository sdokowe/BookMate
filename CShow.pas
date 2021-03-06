{
   ____ ____  _                   
  / ___/ ___|| |__   _____      __
 | |   \___ \| '_ \ / _ \ \ /\ / /
 | |___ ___) | | | | (_) \ V  V / 
  \____|____/|_| |_|\___/ \_/\_/  

This class will handle everything related to a show
A show contains seats and has guests - CSeat and CGuest respectively.
This class shall be rendered by CRender.

}

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

    seat      : CSeat.TSeat;
    guests    : TDictionary<Integer, CGuest.TGuest>;//TObjectList<CGuest.TGuest>; // Guests, instances of Guests

    name      : String; // Name of the show

  published

    constructor create(name : String);

    function add_guest(guest   : CGuest.TGuest)              : Boolean;
    function add_guests(guests : TObjectList<CGuest.TGuest>) : Boolean;
    function add_seat(seat   : CSeat.TSeat)                  : Boolean;
    function add_seats(seats : TObjectList<CSeat.TSeat>)     : Boolean;

    function remove_guest(guest : CGuest.TGuest)             : Boolean;                                  

    function get_seats()                                     : TObjectList<TSeat>;
    function get_seat(seat_num : Integer)                    : TSeat;
    function get_num_guests()                                : Integer; // Returns the number of guests attending
    function get_num_seats()                                 : Integer;
    function get_guest(guest_id : Integer)                   : TGuest;//(guest_id : Integer)                   : TGuest;
    function is_fully_booked()                               : Boolean;

end;

implementation

constructor TShow.create(name : String);
begin
{
    Class constructor
    Parameter:
      name (string): the name of the show
}

  self.name := name;

  self.seats      := TObjectList<CSeat.TSeat>.Create();
  self.guests     := TDictionary<Integer, TGuest>.Create();

end;

function TShow.add_guest(guest : CGuest.TGuest) : Boolean;
begin
{
    Adds a guest to the show
    Parameter:
      guest (TGuest): an instance of TGuest
    Return:
        result (Boolean):
          true: successfully added the guest
          false: could not add the guest
}

  //Assign the user his/her seat
  //Make sure that seats are made first
  self.guests.Add(guest.get_id(), guest);

  guest.set_seat(self.seats[guest.get_seat()]);

  Result := true;
end;

function TShow.add_guests(guests : TObjectList<CGuest.TGuest>) : Boolean;
begin
  // TO BE IMPLEMENTED IN A LATER VERSION
  Result := true;
end;

function TShow.add_seat(seat : CSeat.TSeat) : Boolean;
begin
{
    Adds a seat to the show
    Parameter:
      seat (TSeat): an instance of TSeat
    Return:
        result (Boolean):
          true: successfully added the seat
          false: could not add the seat
}
  
  self.seats.Add(seat);

  // If the seat ID is between 0 to 18
  // then the seat is considered to be a premium seat as it is close to the stage | Premium seat: 1, Regular seat: 0
  if((seat.get_num >= 0) and (seat.get_num() <= 18)) then
  begin
    seat.set_type(1);
    seat.set_price(20.0);
  end
  else
  begin
    seat.set_type(0);
    seat.set_price(10.0);
  end;

  Result := true;
end;

function TShow.get_guest(guest_id: Integer) : TGuest;
var guest : TGuest;
begin
{
    Retrieves a specific guest
    Parameter:
      guest_id (Integer): the ID of the guest
    Return:
        result (TGuest): instance of TGuest for the requested guest
}

  if(self.guests.TryGetValue(guest_id, guest)) then
    Result := guest
  else
    Result := Nil;

end;

//Adds seats to show
//Parameters:
// seats (array of TSeat instances)
function TShow.add_seats(seats : TObjectList<CSeat.TSeat>) : Boolean;
begin
  // TO BE IMPLEMENTED IN A LATER VERSION
end;

function TShow.remove_guest(guest : CGuest.TGuest) : Boolean;
begin
{
    Removes a guest from the show
    Return:
        result (Boolean): Was the operation successful or not
}

  self.guests.Remove(guest.get_id());

  self.seats[ guest.get_seat ].occupy(false);

  Result := true;
end;

function TShow.get_seats() : TObjectList<CSeat.TSeat>;
begin
{
    Retrieves the seats in the show
    Return:
        result (TObjectList<TSeat>): A list of TSeat class instances
}

  Result := self.seats;
end;

function TShow.get_seat(seat_num : Integer) : CSeat.TSeat;
begin
{
    Retrieves a specific seat in the show
    Parameter:
      seat_num (Integer): the ID of the seat needed
    Return:
        result (TSeat): the class instance of the requested seat 
}

  Result := self.seats[seat_num];
end;

function TShow.get_num_seats() : Integer;
begin
{
    Retrieves the number of seats in the show
    Return:
        result (Integer): number of seats in show
}

  Result := self.seats.Count;
end;



function TShow.get_num_guests() : Integer;
begin
{
    Retrieves the number of guests attending the show
    Return:
        result (Integer): number of guests
}

  Result := self.guests.Count;
end;

function TShow.is_fully_booked() : Boolean;
begin
{
    Returns whether or not the show is fully booked
    Return:
        result (Boolean):
          true: show is fully booked
          false: show is not fully booked
}

  if(self.seats.Count = self.guests.Count) then
    Result := true
  else
    Result := false

end;

end.
