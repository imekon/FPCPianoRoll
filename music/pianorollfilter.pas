unit pianorollfilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fgl;

type

  TFilterType = (ftChromatic, ftMajor, ftMinor);

  { TPianoRollFilter }

  TPianoRollFilter = class
  private
    m_name: string;
    m_type: TFilterType;
    m_notes: array of integer;
  public
    constructor Create(aname: string; filterType: TFilterType; anotes: array of integer);

    property Name: string read m_name;
    property FilterType: TFilterType read m_filterType;
    property Notes: array of integer read m_notes;
  end;

  TPianoRollFilterList = specialize TFPGList<TPianoRollFilter>;

  { TPianoRollManager }

  TPianoRollManager = class
  private
    m_filters: TPianoRollFilterList;
  public
    constructor Create;
    destructor Destroy; override;
    function FindFilter(filterType: TFilterType): TPianoRollFilter;
  end;

implementation

{ TPianoRollFilter }

constructor TPianoRollFilter.Create(aname: string; filterType: TFilterType;
  anotes: array of integer);
begin
  m_name := aname;
  m_type := filterType;
  m_notes := aNotes;
end;

{ TPianoRollManager }

constructor TPianoRollManager.Create;
begin
  m_filters := TPianoRollFilterList;

  m_filters.Add(TPianoRollFilter.Create('Chromatic', ftChromatic, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
  m_filters.Add(TPianoRollFilter.Create('Major', ftMajor, [0, 2, 4, 6, 7, 9, 11]);
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

function TPianoRollManager.FindFilter(filterType: TFilterType
  ): TPianoRollFilter;
var
  filter: TPianoRollFilter;

begin
  result := nil;
  for filter in m_filters do
    if filter.FilterType = filterType then
    begin
      result := filter;
      break;
    end;
end;

end.

