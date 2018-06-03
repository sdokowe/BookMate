unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ShowFrame, Data.DB,
  Data.SqlExpr, Data.DbxSqlite, System.Generics.Collections, CShow, CGuest, CSeat, CRender,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit, System.RegularExpressions, Data.FMTBcd, Math;

type Tickets = class

  guest : CGuest.TGuest;
  _type : String;
  price : Real; 

end;

type
  TForm1 = class(TForm)
    
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
    mainConnection: TSQLConnection;
    SQLQuery1: TSQLQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure gridTicketsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure addticketBtnClick(Sender: TObject);
    procedure proceedBtnClick(Sender: TObject);
  private
    { Private declarations }
    render : TRender;

    tickets : TObjectList<main.Tickets>; // The number of tickets

    show : TShow;

  public
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
      ticket.guest := guest;
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
var guest   : TGuest;
var i : Integer;
var seat : array[0..50] of TSeat;

var query : String;
var names : TStringList;
var temp_list : TList;
var temp : array [0..1] of String;
var currentField: TField;

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

    // Load the guests

    // SELECT guests.name, bookings.seat FROM `guests` INNER JOIN bookings ON guests.id = bookings.guest WHERE bookings.show = 0

    query := 'SELECT guests.name, bookings.seat FROM `guests` INNER JOIN bookings ON guests.id = bookings.guest WHERE bookings.show = 0';
    // This is not safe, we need to escape names

    try

      self.SQLQuery1.SQL.Text := query;
      self.SQLQuery1.Active := true;

      if not SQLQuery1.IsEmpty then
      begin
        SQLQuery1.First;
        names := TStringList.Create;
        try
          SQLQuery1.GetFieldNames(names);
          while not SQLQuery1.Eof do
          begin
            for i := 0 to names.Count - 1 do
            begin
              currentField := SQLQuery1.FieldByName(names[i]);
              temp[i] := CurrentField.AsString;
            end;

            guest := TGuest.create(temp[0], StrToInt(temp[1]));
            guest.set_seat(seat[ StrToInt(temp[1]) ]);
            show.add_guest(guest);

            SQLQuery1.Next;
          end;

        finally
          names.Free;
        end;
      end;

    except
      on E: Exception do
      begin
        showmessage('Something went wrong :(');
        exit();
      end;

    end;

    {// Add guests to show
    for i := 0 to 9 do
    begin
      guest[i] := TGuest.create('blah', i);

      guest[i].set_seat(seat[i]);
      show.add_guest(guest[i]);
    end;
   }
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




procedure DeleteRow(Grid: TStringGrid; ARow: Integer);
var
  i: Integer;
begin
  for i := ARow to Grid.RowCount - 2 do
    Grid.Rows[i].Assign(Grid.Rows[i + 1]);
  //Grid.RowCount := Grid.RowCount - 1;
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

      // Y : row number, start from 1 because we'll ignore headers

      // Get the name of the guest
      // Then using that, delete it from the
      if(Length(gridTickets.Cells[gc.X, gc.Y]) > 0) then
      begin

        self.show.remove_guest( self.tickets[gc.Y - 1].guest );
        self.tickets.Count := self.tickets.Count - 1;

        DeleteRow(gridTickets, gc.Y);

        self.render.update();

      end;

    end;

    

end;

procedure TForm1.proceedBtnClick(Sender: TObject);

var query : String;
var ticket : main.Tickets;
var ref_num : Integer;
var final_str : String;
begin

  //Save the data into the database

  // Insert guests

  if(self.tickets.count = 0) then
  begin
    showmessage('Please add some tickets!');
    exit();
  end;

  final_str := '';
  
  // Not ideal at all, but I'm lazy...
  for ticket in self.tickets do
  begin
  
    ref_num := RandomRange(500, 100000);
  
    query := 'INSERT INTO `guests` (name, phone_num) VALUES ( "'+ ticket.guest.get_name() +'", '+ IntToStr(ticket.guest.get_phone()) +' )';
  
    final_str := final_str + 'Name : ' + ticket.guest.get_name() + ''+AnsiString(#13#10)+'Seat: ' + IntToStr(ticket.guest.get_seat()) + ''+AnsiString(#13#10)+'Reference number: ' + IntToStr(ref_num) + ''+AnsiString(#13#10)+'--------------'+AnsiString(#13#10)+'';
  
       try
    // Assign the query to the object SQLQuery1.
      SQLQuery1.SQL.Text := query;
      //SQLQuery1.Active := true;
      SQLQuery1.ExecSQL();
    except
      on E: Exception do
      begin
        showmessage('Something went wrong :(');
        exit;
      end;
    end;
    // Inser their bookings

    query := 'INSERT INTO `bookings` (show, guest, seat, ref_num) VALUES (0, (SELECT `id` FROM `guests` WHERE name="'+ ticket.guest.get_name() +'"), '+ IntToStr(ticket.guest.get_seat()) +', '+ IntToStr(ref_num) +')';

    try
    // Assign the query to the object SQLQuery1.
      SQLQuery1.SQL.Text := query;
      //SQLQuery1.Active := true;
      SQLQuery1.ExecSQL();
    except
      on E: Exception do
      begin
        showmessage('Something went wrong :(');
        exit();
      end;
    end;  
  end;

  showmessage(final_str);

  
end;


end.


