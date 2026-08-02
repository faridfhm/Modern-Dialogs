unit uAppMessageService;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  System.Types,
  System.Math,
  Vcl.Forms,
  Vcl.Controls,
  Vcl.ExtCtrls,
  Vcl.Graphics,
  Vcl.StdCtrls;

type
  TAppMessageType = (mtInfo, mtSuccess, mtWarning, mtError, mtQuestion);
  TBackupExitResult = (berExit, berStay, berBackup);

  TAppMessageItemStyle = class(TPersistent)
  private
    FAccentColor: Cardinal;
    FBadgeColor: Cardinal;
    FIconChar: string;
    FIconColor: Cardinal;
    procedure SetAccentColor(const Value: TColor);
    procedure SetBadgeColor(const Value: TColor);
    procedure SetIconColor(const Value: TColor);
    function GetAccentColor: TColor;
    function GetBadgeColor: TColor;
    function GetIconColor: TColor;
  public
    constructor Create;
  published
    property AccentColor: TColor read GetAccentColor write SetAccentColor;
    property BadgeColor:  TColor read GetBadgeColor write SetBadgeColor;
    property IconChar:    string read FIconChar write FIconChar;
    property IconColor:   TColor read GetIconColor write SetIconColor;
  end;

  TAppMessageService = class(TComponent)
  private
    FFont: TFont;
    FProducer: string;
    FBackgroundColor: TColor;
    FInfoStyle: TAppMessageItemStyle;
    FSuccessStyle: TAppMessageItemStyle;
    FWarningStyle: TAppMessageItemStyle;
    FErrorStyle: TAppMessageItemStyle;
    FQuestionStyle: TAppMessageItemStyle;
    procedure SetFont(const Value: TFont);
    procedure SetBackgroundColor(const Value: TColor);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function GetStyle(AType: TAppMessageType): TAppMessageItemStyle;
    function Ask(const ATitle, AMessage: string; AMsgType: TAppMessageType; const AButtons: array of string): Integer;
    procedure Info(const Msg: string; const ATitle: string = 'اطلاع');
    procedure Success(const Msg: string; const ATitle: string = 'موفقیت');
    procedure Warning(const Msg: string; const ATitle: string = 'هشدار');
    procedure Error(const Msg: string; const ATitle: string = 'خطا');
    function Confirm(const Msg: string; const ATitle: string = 'تأیید عملیات'): Boolean;
    function BackupWarning: TBackupExitResult;
    procedure ShowNotification(const Msg: string; TimeoutMs: Integer = 3000);
  published
    property Producer: string read FProducer;
    property Font: TFont read FFont write SetFont;
    property BackgroundColor: TColor read FBackgroundColor write SetBackgroundColor;
    property StyleInfo: TAppMessageItemStyle read FInfoStyle write FInfoStyle;
    property StyleSuccess: TAppMessageItemStyle read FSuccessStyle write FSuccessStyle;
    property StyleWarning: TAppMessageItemStyle read FWarningStyle write FWarningStyle;
    property StyleError: TAppMessageItemStyle read FErrorStyle write FErrorStyle;
    property StyleQuestion: TAppMessageItemStyle read FQuestionStyle write FQuestionStyle;
  end;

  { TFlatButton: متن مستقیماً روی Canvas خود دکمه رسم می‌شود (بدون TLabel فرزند)
    تا هیچ کنترلی سطح دکمه را نپوشاند و رویدادهای Hover/Focus به‌درستی به خود دکمه برسند. }
  TFlatButton = class(TCustomControl)
  private
    FCaption: string;
    FIsPrimary: Boolean;
    FIsHovered: Boolean;
    FIsPressed: Boolean;
    FAccentColor: TColor;
    FBtnFont: TFont;
    procedure SetCaptionText(const Value: string);
    procedure WMMouseLeave(var Message: TMessage); message WM_MOUSELEAVE;
    procedure WMGetDlgCode(var Message: TWMGetDlgCode); message WM_GETDLGCODE;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyUp(var Key: Word; Shift: TShiftState); override;
    procedure DoEnter; override;
    procedure DoExit; override;
  public
    Tag2: Integer;
    constructor CreateStyled(AOwner: TComponent; const ACaption: string; IsPrimary: Boolean; AAccent: TColor; AFont: TFont);
    destructor Destroy; override;
  published
    property Caption: string read FCaption write SetCaptionText;
  end;

  TfrmAppMessage = class(TForm)
  private
    FComponent: TAppMessageService;
    FStyle: TAppMessageItemStyle;
    FAccentBar: TPanel;
    pnlClient: TPanel;
    pnlHeader: TPanel;
    pnlFooter: TPanel;
    pnlButtons: TPanel;
    pbBadge: TPaintBox;
    lblTitle: TLabel;
    lblMessage: TLabel;
    lblCountdown: TLabel;
    pnlProgressTrack: TPanel;
    pnlProgressFill: TPanel;
    FTimer: TTimer;
    FTotalMs, FElapsedMs, FLastSec: Integer;

    procedure BuildUI;
    procedure BuildNotificationUI;
    procedure ApplyStyle(AMsgType: TAppMessageType);
    procedure DrawBadge(Sender: TObject);
    procedure CreateButtons(const Buttons: array of string; out FirstBtn: TFlatButton);
    procedure ButtonClick(Sender: TObject);
    procedure TimerTick(Sender: TObject);
    procedure ApplyRoundRegion;
    procedure FormPaint(Sender: TObject);
  public
    constructor CreateCustom(AOwner: TComponent; AComp: TAppMessageService);
    function Execute(AMsgType: TAppMessageType; const ATitle, AMessage: string; Buttons: array of string; TimeoutMs: Integer = 0): Integer;
  end;

implementation

const
  DefaultCornerRadius = 14;
  DefaultBadgeRadius  = 40;
  HeaderRowHeight     = 52;
  C_PRODUCER_TEXT     = 'AFSoft2010@gmail.com';

function AlterColor(C: TColor; Percent: Integer): TColor;
var
  R, G, B: Byte;
  ColorRGB: Cardinal;
  NewR, NewG, NewB: Integer;
begin
  ColorRGB := Cardinal(ColorToRGB(C));
  R := GetRValue(ColorRGB); G := GetGValue(ColorRGB); B := GetBValue(ColorRGB);

  if Percent < 0 then begin
    NewR := R + MulDiv(R, Percent, 100);
    NewG := G + MulDiv(G, Percent, 100);
    NewB := B + MulDiv(B, Percent, 100);
  end else begin
    NewR := R + MulDiv(255 - R, Percent, 100);
    NewG := G + MulDiv(255 - G, Percent, 100);
    NewB := B + MulDiv(255 - B, Percent, 100);
  end;

  R := System.Math.EnsureRange(NewR, 0, 255);
  G := System.Math.EnsureRange(NewG, 0, 255);
  B := System.Math.EnsureRange(NewB, 0, 255);
  Result := TColor(RGB(R, G, B));
end;

function CalcTextHeight(ACanvas: TCanvas; const AText: string; AWidth: Integer; AFont: TFont): Integer;
var R: TRect;
begin
  ACanvas.Font.Assign(AFont);
  R := Rect(0, 0, AWidth, 0);
  Winapi.Windows.DrawText(ACanvas.Handle, PChar(AText), Length(AText), R, DT_CALCRECT or DT_WORDBREAK or DT_RIGHT or DT_NOPREFIX);
  Result := R.Bottom - R.Top;
end;

{ TAppMessageItemStyle }

constructor TAppMessageItemStyle.Create;
begin inherited Create; end;

function TAppMessageItemStyle.GetAccentColor: TColor; begin Result := TColor(FAccentColor); end;
function TAppMessageItemStyle.GetBadgeColor: TColor; begin Result := TColor(FBadgeColor); end;
function TAppMessageItemStyle.GetIconColor: TColor; begin Result := TColor(FIconColor); end;

procedure TAppMessageItemStyle.SetAccentColor(const Value: TColor); begin FAccentColor := Cardinal(ColorToRGB(Value)); end;
procedure TAppMessageItemStyle.SetBadgeColor(const Value: TColor); begin FBadgeColor := Cardinal(ColorToRGB(Value)); end;
procedure TAppMessageItemStyle.SetIconColor(const Value: TColor); begin FIconColor := Cardinal(ColorToRGB(Value)); end;

{ TAppMessageService }

constructor TAppMessageService.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FProducer := C_PRODUCER_TEXT;
  FFont := TFont.Create; FFont.Name := 'IRANSansFaNum'; FFont.Size := 9;
  FBackgroundColor := clWhite;

  FInfoStyle := TAppMessageItemStyle.Create;
  FSuccessStyle := TAppMessageItemStyle.Create;
  FWarningStyle := TAppMessageItemStyle.Create;
  FErrorStyle := TAppMessageItemStyle.Create;
  FQuestionStyle := TAppMessageItemStyle.Create;

  FInfoStyle.AccentColor    := TColor(Cardinal($00D97706)); FInfoStyle.BadgeColor    := TColor(Cardinal($00FBEEDD)); FInfoStyle.IconColor    := TColor(Cardinal($00D97706)); FInfoStyle.IconChar    := 'i';
  FSuccessStyle.AccentColor := TColor(Cardinal($0057A64C)); FSuccessStyle.BadgeColor := TColor(Cardinal($00E1F2DE)); FSuccessStyle.IconColor := TColor(Cardinal($0057A64C)); FSuccessStyle.IconChar := '✔';
  FWarningStyle.AccentColor := TColor(Cardinal($000099E6)); FWarningStyle.BadgeColor := TColor(Cardinal($00D8F1FF)); FWarningStyle.IconColor := TColor(Cardinal($000099E6)); FWarningStyle.IconChar := '⚠';
  FErrorStyle.AccentColor   := TColor(Cardinal($003838DC)); FErrorStyle.BadgeColor   := TColor(Cardinal($00DEDEFB)); FErrorStyle.IconColor   := TColor(Cardinal($003838DC)); FErrorStyle.IconChar   := '✘';
  FQuestionStyle.AccentColor:= TColor(Cardinal($00AAAA00)); FQuestionStyle.BadgeColor:= TColor(Cardinal($00FFFFC8)); FQuestionStyle.IconColor:= TColor(Cardinal($00AAAA00)); FQuestionStyle.IconChar:= '؟';
end;

destructor TAppMessageService.Destroy;
begin
  FFont.Free; FInfoStyle.Free; FSuccessStyle.Free; FWarningStyle.Free; FErrorStyle.Free; FQuestionStyle.Free;
  inherited Destroy;
end;

procedure TAppMessageService.SetFont(const Value: TFont); begin FFont.Assign(Value); end;
procedure TAppMessageService.SetBackgroundColor(const Value: TColor); begin if FBackgroundColor <> Value then FBackgroundColor := Value; end;

function TAppMessageService.GetStyle(AType: TAppMessageType): TAppMessageItemStyle;
begin
  case AType of
    mtInfo: Result := FInfoStyle;
    mtSuccess: Result := FSuccessStyle;
    mtWarning: Result := FWarningStyle;
    mtError: Result := FErrorStyle;
    mtQuestion: Result := FQuestionStyle;
  else Result := FInfoStyle; end;
end;

function TAppMessageService.Ask(const ATitle, AMessage: string; AMsgType: TAppMessageType; const AButtons: array of string): Integer;
var frm: TfrmAppMessage;
begin
  frm := TfrmAppMessage.CreateCustom(nil, Self);
  try Result := frm.Execute(AMsgType, ATitle, AMessage, AButtons); finally frm.Free; end;
end;

procedure TAppMessageService.Info(const Msg, ATitle: string); begin Ask(ATitle, Msg, mtInfo, ['متوجه شدم']); end;
procedure TAppMessageService.Success(const Msg, ATitle: string); begin Ask(ATitle, Msg, mtSuccess, ['بستن']); end;
procedure TAppMessageService.Warning(const Msg, ATitle: string); begin Ask(ATitle, Msg, mtWarning, ['متوجه شدم']); end;
procedure TAppMessageService.Error(const Msg, ATitle: string); begin Ask(ATitle, Msg, mtError, ['بستن']); end;
function TAppMessageService.Confirm(const Msg, ATitle: string): Boolean; begin Result := Ask(ATitle, Msg, mtQuestion, ['بله', 'خیر']) = 0; end;

function TAppMessageService.BackupWarning: TBackupExitResult;
var Res: Integer;
begin
  Res := Ask('هشدار پشتیبان گیری', 'امروز از پایگاه داده پشتیبان‌گیری نکرده‌اید.' + sLineBreak + 'آیا از نرم‌افزار خارج می‌شوید؟', mtWarning, ['بله', 'خیر', 'پشتیبان‌گیری']);
  case Res of
    0: Result := berExit; 1: Result := berStay; 2: Result := berBackup;
  else Result := berStay; end;
end;

procedure TAppMessageService.ShowNotification(const Msg: string; TimeoutMs: Integer);
var frm: TfrmAppMessage;
begin
  frm := TfrmAppMessage.CreateCustom(nil, Self);
  try frm.Execute(mtInfo, 'پیام سیستم', Msg, [], TimeoutMs); finally frm.Free; end;
end;

{ TFlatButton }

constructor TFlatButton.CreateStyled(AOwner: TComponent; const ACaption: string; IsPrimary: Boolean; AAccent: TColor; AFont: TFont);
begin
  inherited Create(AOwner);
  FIsPrimary := IsPrimary;
  FAccentColor := AAccent;
  FIsHovered := False;
  FIsPressed := False;
  FCaption := ACaption;
  TabStop := True;

  FBtnFont := TFont.Create;
  FBtnFont.Assign(AFont);
  FBtnFont.Style := [fsBold];

  ControlStyle := ControlStyle + [csOpaque];
  Cursor := crHandPoint;
end;

destructor TFlatButton.Destroy;
begin
  FBtnFont.Free;
  inherited Destroy;
end;

procedure TFlatButton.SetCaptionText(const Value: string);
begin
  if FCaption <> Value then begin
    FCaption := Value;
    Invalidate;
  end;
end;

procedure TFlatButton.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  Message.Result := Message.Result or DLGC_BUTTON or DLGC_WANTALLKEYS;
end;

procedure TFlatButton.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  TME: TTrackMouseEvent;
begin
  inherited;
  if not FIsHovered then begin
    FIsHovered := True;
    Invalidate;

    if CanFocus and not Focused then
      SetFocus;

    TME.cbSize := SizeOf(TME);
    TME.dwFlags := TME_LEAVE;
    TME.hwndTrack := Handle;
    TME.dwHoverTime := 0;
    TrackMouseEvent(TME);
  end;
end;

procedure TFlatButton.WMMouseLeave(var Message: TMessage);
begin
  inherited;
  FIsHovered := False;
  Invalidate;
end;

procedure TFlatButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited;
  if Button = mbLeft then begin
    FIsPressed := True;
    if CanFocus then SetFocus;
    Invalidate;
  end;
end;

procedure TFlatButton.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var WasPressed: Boolean;
begin
  inherited;
  WasPressed := FIsPressed;
  FIsPressed := False;
  Invalidate;
  if (Button = mbLeft) and WasPressed and PtInRect(ClientRect, Point(X, Y)) then
    Click;
end;

procedure TFlatButton.KeyDown(var Key: Word; Shift: TShiftState);
begin
  inherited KeyDown(Key, Shift);
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    FIsPressed := True;
    Invalidate;
  end;
end;

procedure TFlatButton.KeyUp(var Key: Word; Shift: TShiftState);
begin
  inherited KeyUp(Key, Shift);
  if (Key = VK_RETURN) or (Key = VK_SPACE) then
  begin
    if FIsPressed then
    begin
      FIsPressed := False;
      Invalidate;
      Click;
    end;
  end;
end;

procedure TFlatButton.DoEnter;
begin
  inherited DoEnter;
  Invalidate;
  Repaint;
end;

procedure TFlatButton.DoExit;
begin
  inherited DoExit;
  FIsPressed := False;
  Invalidate;
  Repaint;
end;

procedure TFlatButton.Paint;
var
  R: TRect;
  BGColor, BorderColor, TextColor: TColor;
  Active: Boolean;
begin
  R := ClientRect;
  Active := Focused;

  if Active then begin
    BGColor := FAccentColor;
    if FIsPressed then BGColor := AlterColor(FAccentColor, -18)
    else if FIsHovered then BGColor := AlterColor(FAccentColor, -10);
    BorderColor := AlterColor(FAccentColor, -15);
    TextColor := clWhite;
  end else begin
    BGColor := TColor(Cardinal($00F3F4F6));
    BorderColor := TColor(Cardinal($00D1D5DB));
    TextColor := TColor(Cardinal($00374151));
  end;

  Canvas.Brush.Color := BGColor;
  Canvas.Brush.Style := bsSolid;
  Canvas.Pen.Color := BorderColor;
  Canvas.Pen.Width := 1;
  Canvas.Pen.Style := psSolid;
  Canvas.RoundRect(R.Left, R.Top, R.Right, R.Bottom, 6, 6);

  Canvas.Brush.Style := bsClear;
  Canvas.Font.Assign(FBtnFont);
  Canvas.Font.Color := TextColor;
  Winapi.Windows.DrawText(Canvas.Handle, PChar(FCaption), Length(FCaption), R,
    DT_CENTER or DT_VCENTER or DT_SINGLELINE or DT_NOPREFIX);
end;

{ TfrmAppMessage }

constructor TfrmAppMessage.CreateCustom(AOwner: TComponent; AComp: TAppMessageService);
begin
  inherited CreateNew(AOwner); FComponent := AComp;
  BorderStyle := bsNone; Position := poDesigned; Width := 360; Height := 220; Color := FComponent.BackgroundColor; DoubleBuffered := True;
  Font.Assign(FComponent.Font); BiDiMode := bdRightToLeft; ParentBiDiMode := False;

  OnPaint := FormPaint;
  SetClassLong(Handle, GCL_STYLE, GetClassLong(Handle, GCL_STYLE) or CS_DROPSHADOW);
end;

procedure TfrmAppMessage.ApplyRoundRegion;
var Rgn: HRGN;
begin
  Rgn := CreateRoundRectRgn(0, 0, Width + 1, Height + 1, DefaultCornerRadius, DefaultCornerRadius);
  SetWindowRgn(Handle, Rgn, True);
end;

procedure TfrmAppMessage.FormPaint(Sender: TObject);
var
  R: TRect;
begin
  R := ClientRect;
  Canvas.Brush.Style := bsClear;

  if Assigned(FStyle) then
    Canvas.Pen.Color := AlterColor(FStyle.AccentColor, -15)
  else
    Canvas.Pen.Color := TColor(Cardinal($00D1D5DB));

  Canvas.Pen.Width := 1;
  Canvas.Pen.Style := psSolid;
  Canvas.RoundRect(R.Left, R.Top, R.Right - 1, R.Bottom - 1, DefaultCornerRadius, DefaultCornerRadius);
end;

procedure TfrmAppMessage.BuildUI;
begin
  FAccentBar := TPanel.Create(Self); FAccentBar.Parent := Self; FAccentBar.Align := alRight; FAccentBar.Width := 6; FAccentBar.BevelOuter := bvNone; FAccentBar.ParentBackground := False;
  pnlClient := TPanel.Create(Self); pnlClient.Parent := Self; pnlClient.Align := alClient; pnlClient.BevelOuter := bvNone; pnlClient.Color := FComponent.BackgroundColor; pnlClient.ParentBackground := False; pnlClient.Padding.Left := 16; pnlClient.Padding.Right := 16; pnlClient.Padding.Top := 12;
  pnlFooter := TPanel.Create(Self); pnlFooter.Parent := Self; pnlFooter.Align := alBottom; pnlFooter.Height := 46; pnlFooter.BevelOuter := bvNone; pnlFooter.Color := AlterColor(FComponent.BackgroundColor, -3); pnlFooter.ParentBackground := False;
  pnlButtons := TPanel.Create(Self); pnlButtons.Parent := pnlFooter; pnlButtons.Align := alClient; pnlButtons.BevelOuter := bvNone; pnlButtons.Color := pnlFooter.Color; pnlButtons.ParentBackground := False;
  pnlHeader := TPanel.Create(Self); pnlHeader.Parent := pnlClient; pnlHeader.Align := alTop; pnlHeader.Height := HeaderRowHeight; pnlHeader.BevelOuter := bvNone; pnlHeader.Color := pnlClient.Color; pnlHeader.ParentBackground := False;
  pbBadge := TPaintBox.Create(Self); pbBadge.Parent := pnlHeader; pbBadge.Align := alLeft; pbBadge.Width := DefaultBadgeRadius + 16; pbBadge.OnPaint := DrawBadge;
  lblTitle := TLabel.Create(Self); lblTitle.Parent := pnlHeader; lblTitle.Align := alClient; lblTitle.Margins.Left := 10; lblTitle.AlignWithMargins := True; lblTitle.Font.Assign(Font); lblTitle.Font.Size := Font.Size + 3; lblTitle.Font.Style := [fsBold]; lblTitle.Font.Color := TColor(Cardinal($00333333)); lblTitle.Layout := tlCenter;
  lblMessage := TLabel.Create(Self); lblMessage.Parent := pnlClient; lblMessage.Align := alClient; lblMessage.Margins.Right := 10; lblMessage.Margins.Top := 2; lblMessage.Margins.Bottom := 12; lblMessage.AlignWithMargins := True; lblMessage.WordWrap := True; lblMessage.Font.Assign(Font); lblMessage.Font.Color := TColor(Cardinal($00555555)); lblMessage.Layout := tlTop;
end;

procedure TfrmAppMessage.BuildNotificationUI;
begin
  lblCountdown := TLabel.Create(Self); lblCountdown.Parent := pnlClient; lblCountdown.Align := alBottom; lblCountdown.Height := 22; lblCountdown.Alignment := taLeftJustify; lblCountdown.Layout := tlCenter; lblCountdown.Font.Assign(Font); lblCountdown.Font.Size := Font.Size - 1; lblCountdown.Font.Color := TColor(Cardinal($00999999));
  pnlProgressTrack := TPanel.Create(Self); pnlProgressTrack.Parent := Self; pnlProgressTrack.Align := alBottom; pnlProgressTrack.Height := 4; pnlProgressTrack.BevelOuter := bvNone; pnlProgressTrack.Color := TColor(Cardinal($00F0F0F0)); pnlProgressTrack.ParentBackground := False;
  pnlProgressFill := TPanel.Create(Self); pnlProgressFill.Parent := pnlProgressTrack; pnlProgressFill.BevelOuter := bvNone; pnlProgressFill.ParentBackground := False; pnlProgressFill.Color := FStyle.AccentColor; pnlProgressFill.Top := 0; pnlProgressFill.Height := 4; pnlProgressFill.Left := 0; pnlProgressFill.Width := pnlProgressTrack.Width;
end;

procedure TfrmAppMessage.DrawBadge(Sender: TObject);
var CX, CY, R: Integer; TextRect: TRect;
begin
  CX := pbBadge.Width div 2; CY := pbBadge.Height div 2; R := DefaultBadgeRadius div 2;
  pbBadge.Canvas.Brush.Color := pnlClient.Color; pbBadge.Canvas.FillRect(pbBadge.ClientRect);
  pbBadge.Canvas.Brush.Color := FStyle.BadgeColor; pbBadge.Canvas.Pen.Color := FStyle.BadgeColor; pbBadge.Canvas.Ellipse(CX - R, CY - R, CX + R, CY + R);
  pbBadge.Canvas.Brush.Style := bsClear; pbBadge.Canvas.Font.Assign(Font); pbBadge.Canvas.Font.Size := Font.Size + 9; pbBadge.Canvas.Font.Style := [fsBold]; pbBadge.Canvas.Font.Color := FStyle.IconColor;
  TextRect := Rect(CX - R, CY - R, CX + R, CY + R);
  Winapi.Windows.DrawText(pbBadge.Canvas.Handle, PChar(FStyle.IconChar), Length(FStyle.IconChar), TextRect, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
end;

procedure TfrmAppMessage.ApplyStyle(AMsgType: TAppMessageType);
begin
  FStyle := FComponent.GetStyle(AMsgType); FAccentBar.Color := FStyle.AccentColor;
  if Assigned(pbBadge) then pbBadge.Invalidate;
end;

procedure TfrmAppMessage.CreateButtons(const Buttons: array of string; out FirstBtn: TFlatButton);
var i: Integer; Btn: TFlatButton; TotalWidth, BtnWidth, BtnSpacing: Integer; pnlContainer: TPanel;
begin
  BtnWidth := 96; BtnSpacing := 8; TotalWidth := Length(Buttons) * (BtnWidth + BtnSpacing) - BtnSpacing;
  pnlContainer := TPanel.Create(Self); pnlContainer.Parent := pnlButtons; pnlContainer.BevelOuter := bvNone; pnlContainer.Width := TotalWidth; pnlContainer.Height := 32; pnlContainer.Top := 7; pnlContainer.Left := (pnlButtons.Width - TotalWidth) div 2; pnlContainer.Anchors := [akTop]; pnlContainer.Color := pnlButtons.Color; pnlContainer.ParentBackground := False;

  FirstBtn := nil;
  for i := 0 to High(Buttons) do begin
    Btn := TFlatButton.CreateStyled(Self, Buttons[i], i = 0, FStyle.AccentColor, Font);
    Btn.Parent := pnlContainer; Btn.Width := BtnWidth; Btn.Height := 32; Btn.Tag2 := i; Btn.OnClick := ButtonClick;
    Btn.Left := TotalWidth - (i + 1) * (BtnWidth + BtnSpacing) + BtnSpacing;
    if i = 0 then FirstBtn := Btn;
  end;
end;

procedure TfrmAppMessage.ButtonClick(Sender: TObject);
begin ModalResult := (Sender as TFlatButton).Tag2 + 100; end;

procedure TfrmAppMessage.TimerTick(Sender: TObject);
var RemainingMs, RemainingSec: Integer;
begin
  Inc(FElapsedMs, FTimer.Interval); RemainingMs := FTotalMs - FElapsedMs;
  if RemainingMs <= 0 then begin FTimer.Enabled := False; ModalResult := mrOk; Exit; end;
  pnlProgressFill.Width := Round(pnlProgressTrack.Width * (RemainingMs / FTotalMs));
  RemainingSec := Ceil(RemainingMs / 1000);
  if RemainingSec <> FLastSec then begin FLastSec := RemainingSec; lblCountdown.Caption := Format('بسته می‌شود در %d ثانیه', [RemainingSec]); end;
end;

function TfrmAppMessage.Execute(AMsgType: TAppMessageType; const ATitle, AMessage: string; Buttons: array of string; TimeoutMs: Integer = 0): Integer;
var AvailWidth, MsgHeight, ContentHeight, BottomAreaHeight: Integer; InitialFocusBtn: TFlatButton;
begin
  BuildUI; ApplyStyle(AMsgType);
  lblTitle.Caption := ATitle; lblMessage.Caption := AMessage;
  AvailWidth := Self.Width - FAccentBar.Width - pnlClient.Padding.Left - pnlClient.Padding.Right - lblMessage.Margins.Right - 4;
  MsgHeight := CalcTextHeight(Self.Canvas, AMessage, AvailWidth, lblMessage.Font);
  ContentHeight := pnlClient.Padding.Top + HeaderRowHeight + lblMessage.Margins.Top + MsgHeight + lblMessage.Margins.Bottom;

  InitialFocusBtn := nil;
  if TimeoutMs > 0 then begin
    pnlFooter.Visible := False; BuildNotificationUI; BottomAreaHeight := 26; FTotalMs := TimeoutMs; FElapsedMs := 0; FLastSec := Ceil(TimeoutMs / 1000) + 1;
    FTimer := TTimer.Create(Self); FTimer.Interval := 100; FTimer.OnTimer := TimerTick; FTimer.Enabled := True;
  end else begin
    CreateButtons(Buttons, InitialFocusBtn); BottomAreaHeight := pnlFooter.Height;
  end;

  Self.Height := Max(150, ContentHeight + BottomAreaHeight);
  if Assigned(Screen.ActiveForm) and (Screen.ActiveForm <> Self) then begin
    Left := Screen.ActiveForm.Left + (Screen.ActiveForm.Width - Width) div 2; Top := Screen.ActiveForm.Top + (Screen.ActiveForm.Height - Height) div 2;
  end else Position := poScreenCenter;

  ApplyRoundRegion;

  if Assigned(InitialFocusBtn) then
    ActiveControl := InitialFocusBtn;

  ShowModal;
  if TimeoutMs > 0 then Result := 0 else Result := ModalResult - 100;
end;

end.
