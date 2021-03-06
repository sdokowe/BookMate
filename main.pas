unit main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, ShowFrame, Data.DB,
  Data.SqlExpr, Data.DbxSqlite, System.Generics.Collections, CShow, CGuest, CSeat, CRender,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ValEdit, System.RegularExpressions, Data.FMTBcd, Math, globalVars;

type Tickets = class

  guest : CGuest.TGuest;
  _type : String;
  price : Real; 

end;

type
  TbookingForm = class(TForm)
    
    Frame11: TFrame1;
    select_seatLbl: TStaticText;
    gridTickets: TStringGrid;
    StaticText2: TStaticText;
    addticketBtn: TButton;
    guestnameEdit: TEdit;
    phonenumEdit: TEdit;
    proceedBtn: TButton;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    procedure FormDestroy(Sender: TObject);
    procedure gridTicketsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure addticketBtnClick(Sender: TObject);
    procedure proceedBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure Start(_type : Integer);
    procedure Stop();
    procedure FormHide(Sender: TObject);
    procedure HandleTypeBookings();
    procedure HandleTypeChangeBookings();

  private
    { Private declarations }
    render : TRender;

    tickets : TObjectList<main.Tickets>; // The number of tickets

    show : TShow;

    edit_mode : Boolean;
    guest_id  : Integer; // For edit mode


  public
  end;

var
  bookingForm: TbookingForm;

implementation

{$R *.dfm}

procedure TbookingForm.addticketBtnClick(Sender: TObject);

var guest_name      : String;
var guest_phone_num : String;
var temp            : Integer;
var guest           : CGuest.TGuest;
var seat            : CSeat.TSeat;
var num_tickets     : Integer;
var ticket          : main.Tickets;
begin

  guest_name      := guestnameEdit.Text;
  guest_phone_num := phonenumEdit.Text;

  if ((Length(guest_name) = 0) or (Length(guest_phone_num) = 0)) then
  begin
    showmessage('Please make sure that you have completed all of the required fields!');
    exit;
  end
  else
  begin

    // Make sure that the name is letters and not numbers or anything else
    if(not TRegEx.IsMatch(guest_name, '^([a-zA-Z]{2,}\s[a-zA-z]{1,}''?-?[a-zA-Z]{2,}\s?([a-zA-Z]{1,})?)')) then
    begin
      showmessage('Please enter in a valid full name');
      exit;
    end;


    // Make sure that the phone number is actually an integer

    if(not TRegEx.IsMatch(guest_phone_num, '^ ?(?:\((?=.*\)))?(0?[2-57-8])\)? ?(\d\d(?:(?=\d{3})|(?!\d\d[- ]?\d[- ]))\d\d?\d?\d{3})$')) then
    begin
      showmessage('Please enter in a valid phone number');
      exit;
    end;
  end;


  // If the use is buying a ticket
  if(globalVars.SelectionType = 0)
  then
  begin

    // This procedure handles what happens when the user clicks on the "add ticket" button
    // First we need to check if the user has entered in the name and phone number of the guest
    // Then, we need to check if the user has selected a seat.

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

        num_tickets := self.tickets.Count + 1; // + 1 Becuase the headers occupy the '0' position


        gridTickets.Cells[0, num_tickets]       := guest_name;      // Guest name
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
  end
 else
  begin

    // User is updating his/her ticket
    // Update the grid

    guest  := show.get_guest(self.guest_id);

    gridTickets.Cells[0, 1] := guest_name;
    gridTickets.Cells[1, 1] := guest_phone_num;

    ticket := main.Tickets.Create();


    // User has changed the seat
    if Frame11.Tag <> -1 then
    begin
      // Reset old seat
      guest.change_seat(show.get_seat(Frame11.Tag));
      seat := show.get_seat(Frame11.Tag);
      gridTickets.Cells[2, 1] := IntToStr(Frame11.Tag);
      gridTickets.Cells[3, 1] := seat.get_type;
      gridTickets.Cells[4, 1] := FloatToStr(seat.get_price);
    end
    else
      seat   := show.get_seat(guest.get_seat());

    guest.set_phone(StrToInt(guest_phone_num));
    guest.set_name(guest_name);


    // Add the ticket to the list
    ticket := main.Tickets.Create();

    ticket.guest := guest;
    ticket._type := seat.get_type();
    ticket.price := seat.get_price();

    self.tickets.Clear();
    self.tickets.Add(ticket);

    self.render.update();

  end;


end;

procedure TbookingForm.FormDestroy(Sender: TObject);
begin

  //Call destructor to free memory
  //self.render.destroy();
  //self.mainConnection.Close();
  //self.SQLQuery1.Free();

end;

procedure TbookingForm.FormHide(Sender: TObject);
begin
  self.Stop;
end;

procedure TbookingForm.Start(_type: Integer);

//var shows   : TObjectList<TShow>;
//var guests  : TObjectList<TGuest>;
var guest   : TGuest;
var i : Integer;
var seat : array[0..50] of TSeat;
var query : String;
var names : TStringList;
var temp_list : TList;
var temp : array [0..3] of String;
var currentField: TField;

begin

  // Set button labels
  addticketBtn.Caption    := 'Add ticket';
  select_seatLbl.Caption  := 'Please select your seat';

  self.tickets := TObjectList<main.Tickets>.Create();

  //Set up the tickets grid
  gridTickets.Cells[0, 0]       := 'Guest name';
  gridTickets.Cells[1, 0]       := 'Phone number';
  gridTickets.Cells[2, 0]       := 'Seat #';
  gridTickets.Cells[3, 0]       := 'Type';
  gridTickets.Cells[4, 0]       := 'Price';

  // Create show
  show := TShow.create('Happy Days');
  // Add seats to show
  for i := 0 to 42 do
  begin
    seat[i] := TSeat.create(i);
    show.add_seat(seat[i]);
  end;

  if(globalVars.main_connection.Connected) then
  begin

    // Load the guests
    query := 'SELECT guests.name, bookings.seat, bookings.ref_num, guests.id FROM `guests` INNER JOIN bookings ON guests.id = bookings.guest WHERE bookings.show = 0 ORDER BY guests.id ASC';
    // This is not safe, we need to escape names

    // Get guests from database and add them to show
    try

      globalVars.main_query.SQL.Text := query;
      globalVars.main_query.Active := true;

      if not globalVars.main_query.IsEmpty then
      begin
        globalVars.main_query.First;
        names := TStringList.Create;
        try
          globalVars.main_query.GetFieldNames(names);
          while not globalVars.main_query.Eof do
          begin
            for i := 0 to names.Count - 1 do
            begin
              currentField := globalVars.main_query.FieldByName(names[i]);
              temp[i] := CurrentField.AsString;
            end;

            guest := TGuest.create(temp[0], StrToInt(temp[3]));
            guest.set_ref_num(StrToInt(temp[2]));
            guest.set_seat(seat[ StrToInt(temp[1]) ]);
            show.add_guest(guest);

            globalVars.main_query.Next;
          end;

        finally
          names.Free;
        end;
      end;
      except on E: Exception do
        begin
          showmessage('Something went wrong :(');
          exit();
        end;
    end;
  end;

  //Render show
  self.render := TRender.create(self.Frame11, show);

  self.render.draw();

  if(self.show.is_fully_booked()) then
  begin

    showmessage('The show is fully booked!');

    gridTickets.Enabled   := False;
    addticketBtn.Enabled  := False;
    guestnameEdit.Enabled := False;
    phonenumEdit.Enabled  := False;
    proceedBtn.Enabled    := False;

  end;

  // Handle different type of action
  if(globalVars.SelectionType = 0) then
  begin
    // Change button text accordingly
    self.addticketBtn.Caption := 'Add ticket';

    self.guestnameEdit.Text := '';
    self.phonenumEdit.Text  := '';

    self.HandleTypeBookings()
  end
  else
  begin
    self.addticketBtn.Caption := 'Update ticket';

    self.guestnameEdit.Text := '';
    self.phonenumEdit.Text  := '';

    self.HandleTypeChangeBookings()
  end;

end;

procedure TbookingForm.HandleTypeChangeBookings();

var query : String;
var names : TStringList;
var currentField : TField;
var i : Integer;
var temp : array [0..3] of String;
var guest : TGuest;
var seats : TObjectList<TSeat>;
var ref_num : Integer;
begin
  // Get booking detail using reference number
  seats := self.show.get_seats();

  ref_num := globalVars.ref_num;

  //SELECT guests.name, guests.phone_num, bookings.seat FROM guests JOIN bookings ON bookings.guest = guests.id WHERE bookings.ref_num = 74775
  //query := 'SELECT guests.name, guests.phone_num, bookings.seat, guests.id FROM guests JOIN bookings ON bookings.guest = guests.id WHERE bookings.ref_num = '+ IntToStr(ref_num) + ' AND bookings.active=1 ORDER BY guests.id ASC';

//  globalVars.main_query.SQL.Text := query;
//  globalVars.main_query.Active := true;

  if not globalVars.change_booking_query.IsEmpty then
  begin
    globalVars.change_booking_query.First;
    names := TStringList.Create;
    try
      globalVars.change_booking_query.GetFieldNames(names);
      while not globalVars.change_booking_query.Eof do
      begin
        for i := 0 to names.Count - 1 do
        begin
          currentField := globalVars.change_booking_query.FieldByName(names[i]);
          temp[i] := CurrentField.AsString;
        end;

        //guest := TGuest.create(temp[0], StrToInt(temp[1]));
        //guest.set_seat(seats[ StrToInt(temp[1]) ]);
        //show.add_guest(guest);

        // Add user's info to grid
        gridTickets.Cells[0, 1]       := temp[0];// 'Guest name';
        gridTickets.Cells[1, 1]       := temp[1];// 'Phone number';
        gridTickets.Cells[2, 1]       := temp[2];// 'Seat #';
        gridTickets.Cells[3, 1]       := show.get_seat(StrToInt(temp[2])).get_type();// 'Type';
        gridTickets.Cells[4, 1]       := FloatToStr( show.get_seat(StrToInt(temp[2])).get_price() );// 'Price';

        // Highlight the seat
        self.render.highlight_seat(show.get_seat(StrToInt(temp[2])).get_num());

        // Add text to edits
        self.guestnameEdit.Text := temp[0];
        self.phonenumEdit.Text := temp[1];
        self.guest_id          := StrToInt(temp[3]);


        globalVars.change_booking_query.Next;
      end;
    finally
      names.Free;
  end;
  end
  else
  begin
    self.Hide();
    showmessage('No booking found!');
  end;

end;

procedure TbookingForm.HandleTypeBookings();
begin
  // Enable buttons and text boxes
    gridTickets.Enabled   := True;
    addticketBtn.Enabled  := True;
    guestnameEdit.Enabled := True;
    phonenumEdit.Enabled  := True;
    proceedBtn.Enabled    := True;
end;

procedure ClearStringGrid(Grid: TStringGrid);
var
  I: Integer;
  J: Integer;
begin
  for I := 0 to Grid.ColCount-1 do
    for J := 0 to Grid.RowCount-1 do
      Grid.Cells[I,J] := '';
end;

procedure TbookingForm.Stop;
begin
  ////Call destructor to free memory
  self.render.destroy();

  ClearStringGrid(self.gridTickets);

end;

procedure TbookingForm.FormShow(Sender: TObject);
begin

  self.Start(self.Tag);

end;


procedure DeleteRow(Grid: TStringGrid; ARow: Integer);
var
  i: Integer;
begin
  for i := ARow to Grid.RowCount - 2 do
    Grid.Rows[i].Assign(Grid.Rows[i + 1]);
  //Grid.RowCount := Grid.RowCount - 1;
end;

procedure TbookingForm.gridTicketsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);

var gc : TGridCoord;

begin

  if(globalVars.SelectionType <> 0) then
    exit();

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

procedure TbookingForm.proceedBtnClick(Sender: TObject);

var query : String;
var ticket : main.Tickets;
var ref_num : Integer;
var final_str : String;
var total_price : Real;
begin

  //Save the data into the database

  // Insert guests

  if(self.tickets.count = 0) then
  begin
    showmessage('Please add some tickets!');
    exit();
  end;

  final_str := '';
  total_price := 0.0;
  
  // Not ideal at all, but I'm lazy...
  for ticket in self.tickets do
  begin

    if(globalVars.SelectionType = 0) then
      ref_num := RandomRange(500, 100000)
    else
      ref_num := ticket.guest.get_ref_num();

    if(globalVars.SelectionType = 0) then
      query := 'INSERT INTO `guests` (name, phone_num) VALUES ( "'+ ticket.guest.get_name() +'", '+ IntToStr(ticket.guest.get_phone()) +' )'
    else
      query := 'UPDATE `guests` SET name="'+ ticket.guest.get_name() +'", phone_num='+ IntToStr(ticket.guest.get_phone()) +' WHERE guests.id='+ IntToStr(ticket.guest.get_id()) +'';

    final_str := final_str +
    'Name : ' + ticket.guest.get_name() +
    ''+AnsiString(#13#10)+

    'Seat: ' + IntToStr(ticket.guest.get_seat())
    + ''+AnsiString(#13#10)+

    'Price: $' + FloatToStr(ticket.price)
    + ''+AnsiString(#13#10)+

    'Reference number: ' + IntToStr(ref_num)
    + ''+AnsiString(#13#10)+

    '--------------'
    +AnsiString(#13#10)+'';

    total_price := total_price + ticket.price;
  
       try
    // Assign the query to the object SQLQuery1.
      globalVars.main_query.SQL.Text := query;
      //SQLQuery1.Active := true;
      globalVars.main_query.ExecSQL();
    except
      on E: Exception do
      begin
        showmessage('Something went wrong :(');
        exit;
      end;
    end;
    // Inser their bookings

    if(globalVars.SelectionType = 0) then
      query := 'INSERT INTO `bookings` (show, guest, seat, ref_num) VALUES (0, (SELECT `id` FROM `guests` WHERE name="'+ ticket.guest.get_name() +'"), '+ IntToStr(ticket.guest.get_seat()) +', '+ IntToStr(ref_num) +')'
    else
        query := 'UPDATE `bookings` SET seat='+ IntToStr(ticket.guest.get_seat()) +' WHERE guest='+ IntToStr(ticket.guest.get_id())+'';
    try
    // Assign the query to the object SQLQuery1.
      globalVars.main_query.SQL.Text := query;
      //SQLQuery1.Active := true;
      globalVars.main_query.ExecSQL();
    except
      on E: Exception do
      begin
        showmessage('Something went wrong :(');
        exit();
      end;
    end;  
  end;

  final_str := final_str + 'Total: $' + FloatToStr(total_price);

  showmessage(final_str);

  
end;


end.


