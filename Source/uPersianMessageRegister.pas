unit uPersianMessageRegister;

interface

procedure Register;

implementation

uses
  System.Classes,
 // uAppMessageService,
  uModernDialogs;

procedure Register;
begin
//  RegisterComponents('Persian Message', [TAppMessageService]);
  RegisterComponents('Persian Message', [TModernDialogs]);
end;

end.

