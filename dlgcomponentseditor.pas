{
componentseditor.pas

Components editor window

Copyright (C) 2007 Felipe Monteiro de Carvalho

This file is part of Turbo Circuit.

Turbo Circuit is free software;
you can redistribute it and/or modify it under the
terms of the GNU General Public License version 2
as published by the Free Software Foundation.

Turbo Circuit is distributed in the hope
that it will be useful, but WITHOUT ANY WARRANTY; without even
the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE. See the GNU General Public License for more details.

Please note that the General Public License version 2 does not permit
incorporating Turbo Circuit into proprietary programs.

AUTHORS: Felipe Monteiro de Carvalho
}
unit dlgcomponentseditor;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  DbCtrls, ExtCtrls, StdCtrls, db, SdfData,
  drawer, constants, tcsettings, dbcomponents, translationstc;

type

  { TvComponentsEditor }

  TvComponentsEditor = class(TForm)
    btnClose: TButton;
    btnPreview: TButton;
    FDatasource: TDatasource;
    lblInstructions: TLabel;
    txtID: TDBEdit;
    txtNameEn: TDBEdit;
    txtWidth: TDBEdit;
    txtNamePt: TDBEdit;
    txtHeight: TDBEdit;
    txtPins: TDBEdit;
    FNavigator: TDBNavigator;
    imgPreview: TImage;
    lblID: TLabel;
    lblNameEn: TLabel;
    lblNamePt: TLabel;
    lblWidth: TLabel;
    lblDrawingCode: TLabel;
    lblPins: TLabel;
    lblHeight: TLabel;
    procedure btnPreviewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    memoDrawingCode: TDBDrawingCodeMemo;
    procedure TranslateUserInterface();
  public
    { public declarations }
  end; 

var
  vComponentsEditor: TvComponentsEditor;

implementation

{ TvComponentsEditor }

procedure TvComponentsEditor.btnPreviewClick(Sender: TObject);
begin
  { Clear the image area }
  imgPreview.Canvas.Brush.Color := clWhite;
  imgPreview.Canvas.FillRect(0, 0, imgPreview.Width, imgPreview.Height);

  { Draw a preview of the component }
  vItemsDrawer.DeltaX := 0;
  vItemsDrawer.DeltaY := 0;
  vItemsDrawer.DrawComponentFromStringList(imgPreview.Canvas, memoDrawingCode.Lines);
end;

procedure TvComponentsEditor.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  // Avoids errors if we call Post without an edit or insert mode
  if (FDatasource.DataSet.State = dsEdit) or (FDatasource.DataSet.State = dsInsert) then
    FDatasource.DataSet.Post;
  // Detach from dataset
  FDatasource.DataSet := nil;
end;

procedure TvComponentsEditor.FormCreate(Sender: TObject);
begin
  // Create the special memo for the drawing code
  // cannot be done in the form designer because it is a custom class
  memoDrawingCode := TDBDrawingCodeMemo.Create(nil);
  memoDrawingCode.Parent := Self;
  memoDrawingCode.Left := 16;
  memoDrawingCode.Top := 232;
  memoDrawingCode.Height := 162;
  memoDrawingCode.Width := 176;
  memoDrawingCode.DataField := 'DRAWINGCODE';
  memoDrawingCode.DataSource := FDatasource;

  // Translate the UI
  TranslateUserInterface;
end;

procedure TvComponentsEditor.FormDestroy(Sender: TObject);
begin
  memoDrawingCode.Free;
end;

procedure TvComponentsEditor.FormShow(Sender: TObject);
begin
  FDatasource.DataSet := vComponentsDatabase.FDataset;
  vComponentsDatabase.FDataset.First;
end;

procedure TvComponentsEditor.TranslateUserInterface();
begin
  lblInstructions.Caption := vTranslations.lpCEInstructions;
  lblID.Caption := vTranslations.lpCEID;
  lblNameEN.Caption := vTranslations.lpCENameEN;
  lblNamePT.Caption := vTranslations.lpCENamePT;
  lblWidth.Caption := vTranslations.lpCEWidth;
  lblHeight.Caption := vTranslations.lpCEHeight;
  lblPins.Caption := vTranslations.lpCEPins;
  lblDrawingCode.Caption := vTranslations.lpCEDrawingCode;
  btnPreview.Caption := vTranslations.lpCEPreview;
  btnClose.Caption := vTranslations.lpCEClose;
  Caption := vTranslations.lpCECaption;
end;

initialization
  {$I dlgcomponentseditor.lrs}

end.

