unit ksSlideMenuUI;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  ksTypes, ksVirtualListView, FMX.Effects;

type
  TfrmSlideMenuUI = class(TForm)
    ksVirtualListView1: TksVirtualListView;
    Image1: TImage;
    ShadowEffect1: TShadowEffect;
    procedure Image1Click(Sender: TObject);
  private
    FOnSelectItem: TksVListItemClickEvent;
    { Private declarations }
  protected
    procedure DoShow; override;
    procedure SelectItem(Sender: TObject; AItem: TksVListItem);
  public
    procedure OpenMenu(ACallingForm: TCommonCustomForm);
    procedure CloseMenu;
    property OnSelectItem: TksVListItemClickEvent read FOnSelectItem write FOnSelectItem;
    { Public declarations }
  end;


implementation

uses FMX.Ani, ksCommon, ksSlideMenu;

{$R *.fmx}

{ TfrmSlideMenuUI }

procedure TfrmSlideMenuUI.CloseMenu;
begin
  Application.ProcessMessages;
  Sleep(50);
  ksVirtualListView1.HitTest := False;
  TAnimator.AnimateFloatWait(Image1, 'Position.X', 0, 0.2, TAnimationType.InOut, TInterpolationType.Sinusoidal);
  Visible := False;
end;

procedure TfrmSlideMenuUI.DoShow;
begin
  inherited;
  {$IFDEF IOS}
  Application.ProcessMessages;
  {$ENDIF}
  ksVirtualListView1.HitTest := False;
  TAnimator.AnimateFloatWait(Image1, 'Position.X', C_DEFAULT_MENU_WIDTH, 0.2, TAnimationType.InOut, TInterpolationType.Sinusoidal);
  ksVirtualListView1.HitTest := True;
end;

procedure TfrmSlideMenuUI.Image1Click(Sender: TObject);
begin
  SelectItem(Self, ksVirtualListView1.Items[ksVirtualListView1.ItemIndex]);
end;

procedure TfrmSlideMenuUI.OpenMenu(ACallingForm: TCommonCustomForm);
begin
  if ksVirtualListView1.ItemIndex = -1 then
    ksVirtualListView1.ItemIndex := 0;
  ksVirtualListView1.OnItemClick := SelectItem;
  ksVirtualListView1.Width := C_DEFAULT_MENU_WIDTH;
  Image1.Bitmap := GenerateFormImageExt(ACallingForm);
  Image1.SetBounds(0, 0, ACallingForm.Width, ACallingForm.Height);
  Visible := True;
end;

procedure TfrmSlideMenuUI.SelectItem(Sender: TObject; AItem: TksVListItem);
begin
  if Assigned(FOnSelectItem) then
    FOnSelectItem(Self, AItem);
end;

end.
