unit pianorollnote;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TPianoRollNote }

  TPianoRollNote = class
  private
    m_start, m_length, m_velocity, m_note: integer;
    m_data: Pointer;
  public
    constructor Create(start, length, velocity, anote: integer; adata: Pointer);
    property Start: integer read m_start;
    property Length: integer read m_length;
    property Velocity: integer read m_velocity;
    property Note: integer read m_note;
    property Data: Pointer read m_data;
  end;

  TPianoRollNoteList = specialize TFPGList<TPianoRollNote>;

implementation

{ TPianoRollNote }

constructor TPianoRollNote.Create(start, length, velocity, anote: integer;
  adata: Pointer);
begin
  m_start := start;
  m_length := length;
  m_velocity := velocity;
  m_note := anote;
  m_data := adata;
end;

end.

