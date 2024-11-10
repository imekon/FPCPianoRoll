unit PianoRoll;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  PianoRollNote, PianoRollFilter;

type

  { TPianoRoll }

  TPianoRoll = class(TCustomControl)
  private
    m_notes: TPianoRollNoteList;
    m_manager: TPianoRollManager;
    m_selectedFilter: TPianoRollFilter;
    m_selectedFilterType: TFilterType;
    m_notesPerOctave: integer;
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

    property Height;
    property Width;
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

  m_selectedFilter := m_manager.FindFilter(AValue);
  if Assigned(m_selectedFilter) then
    m_notesPerOctave := Length(m_selectedFilter.Notes)
  else
    m_notesPerOctave := 12;

  Refresh;
end;

procedure TPianoRoll.Paint;
var
  x, y: integer;
  note: TPianoRollNote;

begin
  inherited Paint;

  for y := 0 to 35 do
  begin
    Canvas.MoveTo(0, m_noteHeight * y);
    Canvas.LineTo(Width, m_noteHeight * y);
  end;

  for x := 0 to 15 do
  begin
    Canvas.MoveTo(x * 24, 0);
    Canvas.LineTo(x * 24, Height);
  end;

  Canvas.Pen.Color := clBlack;
  Canvas.Brush.Color := clYellow;
  for note in m_notes do
  begin
    // TODO: take filtering into account
    // TODO: reverse Y
    Canvas.Rectangle(note.Start, note.Note * m_noteHeight,
      note.Start + note.Length, note.Note * m_noteHeight + m_noteHeight);
  end;
end;

constructor TPianoRoll.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  m_notes := TPianoRollNoteList.Create;
  m_manager := TPianRollManager.Create;
  m_selectedFilter := nil;
  m_selectedFilterType := ftChromatic;
  m_notesPerOctave := 12;
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

  Refresh;
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
