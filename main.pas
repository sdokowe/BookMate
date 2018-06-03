unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ShowFrame, Data.DB,
  Data.SqlExpr, Data.DbxSqlite, System.Generics.Collections, CShow, CGuest, CSeat, CRender,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit, System.RegularExpressions;

type Tickets = class

  guest_name : String;
  phone_num  : String;
  seat_num   : Integer;
  _type : String;
  price : Real; 

end;

type
  TForm1 = class(TForm)
    mainConnection: TSQLConnection;
    Frame11: TFrame1;
    StaticText1: TStaticText;
    gridTickets: TStringGrid;
    StaticText2: TStaticText;
    addticketBtn: TButton;
    guestnameEdit: TEdit;
    phonenumEdit: TEdit;
    proceedBtn: TButton;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gridTicketsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure addticketBtnClick(Sender: TObject);
  private
    { Private declarations }
    render : TRender;

    tickets : TObjectList<main.Tickets>; // The number of tickets

    show : TShow;

  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.addticketBtnClick(Sender: TObject);

var guest_name      : String;
var guest_phone_num : String;
var temp            : Integer;
var ticket          : main.Tickets;
var guest           : CGuest.TGuest;
var seat            : CSeat.TSeat;
var num_tickets     : Integer;
begin

  // This procedure handles what happens when the user clicks on the "add ticket" button
  // First we need to check if the user has entered in the name and phone number of the guest
  // Then, we need to check if the user has selected a seat.

  guest_name      := guestnameEdit.Text;
  guest_phone_num := phonenumEdit.Text;

  if ((Length(guest_name) = 0) or (Length(guest_phone_num) = 0)) then
    showmessage('Please make sure that you have completed all of the required fields!')
  else
  begin

    // Make sure that the name is letters and not numbers or anything else
    if(not TRegEx.IsMatch(guest_name, '^([a-zA-Z]{2,}\s[a-zA-z]{1,}''?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)')) then
    begin
      showmessage('Please enter in a valid full name');
      exit;
    end;


    // Make sure that the phone number is actually an integer

    if(not TRegEx.IsMatch(guest_phone_num, '^(?:\+?(61))? ?(?:\((?=.*\)))?(0?[2-57-8])\)? ?(\d\d(?:[- ](?=\d{3})|(?!\d\d[- ]?\d[- ]))\d\d[- ]?\d[- ]?\d{3})$')) then
    begin
      showmessage('Please enter in a valid phone number');
      exit;
    end;

    if(Frame11.Tag <> -1) then
    begin

      ticket := main.Tickets.Create();
      guest  := CGuest.TGuest.create(guest_name, self.show.get_num_guests + 1);
      seat   := self.show.get_seat(Frame11.Tag);

      guest.set_phone(StrToInt(guest_phone_num));
      guest.set_seat(seat);


      // Add the ticket to the list
      ticket.guest_name := guest_name;
      ticket.phone_num := guest_phone_num;
      ticket.seat_num := Frame11.Tag;
      ticket._type := seat.get_type();
      ticket.price := seat.get_price();

      num_tickets := self.tickets.Count + 1; // + 1 Becuase the headers start at 0


      gridTickets.Cells[0, num_tickets]       := guest_name; // Guest name
      gridTickets.Cells[1, num_tickets]       := guest_phone_num; // Phone number
      gridTickets.Cells[2, num_tickets]       := IntToStr(Frame11.Tag);  // Seat number
      gridTickets.Cells[3, num_tickets]       := ticket._type; // Type of ticket
      gridTickets.Cells[4, num_tickets]       := FloatToStr(ticket.price); // Price of ticket

      self.tickets.Add(ticket);

      self.show.add_guest(guest);


      self.render.update();

      // After adding the ticket, reset the edit boxes
      guestnameEdit.Text    := '';
      phonenumEdit.Text     := '';

    
    end
    else
      showmessage('Please select a seat');


  end;


end;

procedure TForm1.FormCreate(Sender: TObject);

var shows   : TObjectList<TShow>;
var guests  : TObjectList<TGuest>;
var guest : array[0..20] of TGuest;
var i : Integer;
var seat : array[0..50] of TSeat;

begin

  self.tickets := TObjectList<main.Tickets>.Create();

  //Set up the tickets grid
  gridTickets.Cells[0, 0]       := 'Guest name';
  gridTickets.Cells[1, 0]       := 'Phone number';
  gridTickets.Cells[2, 0]       := 'Seat #';
  gridTickets.Cells[3, 0]       := 'Type';
  gridTickets.Cells[4, 0]       := 'Price';


  //Connect to database

  mainConnection.Params.Add('Database=main.db');

  try
    
    //Connection established
    mainConnection.Connected := true;

    //Get the shows

  //Create shows

    show := TShow.create('Happy Days');

    //Add seats to show

    for i := 0 to 42 do
    begin
      seat[i] := TSeat.create(i);
      show.add_seat(seat[i]);
    end;

    //Add guests to show
    for i := 0 to 9 do
    begin
      guest[i] := TGuest.create('blah', i);

      guest[i].set_seat(seat[i]);
      show.add_guest(guest[i]);
    end;

  //Render show
  self.render := TRender.create(self.Frame11, show);

  self.render.draw();

  except
    on E: EDatabaseError do
    begin
      ShowMessage('Couldn''t connect to database: ' + E.Message);
    end;
  end;


end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  //Call destructor to free memory
  self.render.destroy();

end;

procedure TForm1.gridTicketsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var gc : TGridCoord;

begin

  // If the user right clicked on the grid, check if he clicked on a row
  if(Button = mbRight) then
    gc := gridTickets.MouseCoord(X, Y);
    if (gc.X > 0) AND (gc.Y > 0) then
    begin



    end;
      
    

end;

end.
