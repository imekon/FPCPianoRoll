unit pianorollfilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  { TPianoRollFilter }

  TPianoRollFilter = class
  private
    m_name: string;
    m_notes: array of integer;
  public
    constructor Create(aname: string; anotes: array of integer);
  end;

  TPianoRollFilterList = specialize TFPGList<TPianoRollFilter>;

  { TPianoRollManager }

  TPianoRollManager = class
  private
    m_filters: TPianoRollFilterList;
  public
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TPianoRollFilter }

constructor TPianoRollFilter.Create(aname: string; anotes: array of integer);
begin
  m_name := aname;
  m_notes := aNotes;
end;

{ TPianoRollManager }

constructor TPianoRollManager.Create;
begin
  m_filters := TPianoRollFilterList;

  m_filters.Add(TPianoRollFilter.Create('chromatic', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
  m_filters.Add(TPianoRollFilter.Create('major', [0, 2, 4, 6, 7, 9, 11]);
end;

destructor TPianoRollManager.Destroy;
var
  filter: TPianoRollFilter;

begin
  for filter in m_filters do
    filter.Free;

  m_filters.Free;
  inherited Destroy;
end;

end.

