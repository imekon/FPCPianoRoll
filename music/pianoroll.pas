unit PianoRoll;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  PianoRollNote, PianoRollFilter;

type

  TFilterType = (ftChromatic, ftMajor, ftMinor);

  { TPianoRoll }

  TPianoRoll = class(TCustomControl)
  private
    m_notes: TPianoRollNoteList;
    m_manager: TPianoRollManager;
    m_selectedFilter: TPianoRollFilter;
    m_selectedFilterType: TFilterType;
    m_noteHeight: integer;
    m_ppqn: integer;

    procedure SetFilterType(AValue: TFilterType);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    procedure AddNote(start, length, velocity, anote: integer; adata: Pointer);
    procedure RemoveNote(adata: Pointer);
  published
    property Filter: TFilterType read m_selectedFilterType write SetFilterType default ftChromatic;
    property NoteHeight: integer read m_noteHeight set m_NoteHeight default 20;
    property PPQN: integer read m_ppqn write m_ppqn default 96;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Music', [TPianoRoll]);
end;

{ TPianoRoll }

procedure TPianoRoll.SetFilterType(AValue: TFilterType);
begin
  if m_selectedFilterType = AValue then Exit;
  m_selectedFilterType := AValue;

  // TODO: set selected filter here
end;

procedure TPianoRoll.Paint;
begin
  inherited Paint;

  Canvas.MoveTo(0, 100);
  Canvas.LineTo(Width, 100);
end;

constructor TPianoRoll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_notes := TPianoRollNoteList.Create;
  m_manager := TPianRollManager.Create;
  m_selectedFilter := nil;
  m_selectedFilterType := ftChromatic;
  m_filterList := TStringList.Create;

  m_noteHeight := 20;
  m_ppqn := 96;
end;

destructor TPianoRoll.Destroy;
var
  note: TPianoRollNote;

begin
  for note in m_notes do
    note.Free;

  m_notes.Free;
  m_manager.Free;
  inherited Destroy;
end;

procedure TPianoRoll.Clear;
var
  note: TPianoRollNote;

begin
  for note in m_notes do
    note.Free;

  m_notes.Clear;
end;

procedure TPianoRoll.AddNote(start, length, velocity, anote: integer;
  adata: Pointer);
var
  theNote: TPianoRollNote;

begin
  theNote := TPianoRollNote.Create(start, length, velocity, anote, adata);
  m_notes.Add(theNote);
  Refresh;
end;

procedure TPianoRoll.RemoveNote(adata: Pointer);
var
  theNote: TPianoRollNote;

begin
  for theNote in m_notes do
    if theNote.Data = aData then
    begin
      m_notes.Remove(theNote);
      theNote.Free;
      Refresh;
      break;
    end;
end;

end.
