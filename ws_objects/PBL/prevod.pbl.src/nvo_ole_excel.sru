$PBExportHeader$nvo_ole_excel.sru
$PBExportComments$OLE Object pro komunikaci s M$ Excel
forward
global type nvo_ole_excel from oleobject
end type
end forward

global type nvo_ole_excel from oleobject
end type
global nvo_ole_excel nvo_ole_excel

type variables
public:
  privatewrite int	p_detect_err	= 0

private:
  boolean		p_lg_Debug	= False

public:
  constant int	c_Error	= 1000
  constant int	c_Except	= 1010

public:
  // XlSaveConflictResolution
  constant long	xlUserResolution		= 1
  constant long	xlLocalSessionChanges	= 2
  constant long	xlOtherSessionChanges	= 3

  // XlFileFormat
  constant long	xlWorkbookNormal		= -4143

  // XlSaveAsAccessMode
  constant long	xlNoChange		= 1
  constant long	xlShared			= 2
  constant long	xlExclusive		= 3

  // XlSheetVisibility
  constant long	xlSheetHidden		= 0
  constant long	xlSheetVeryHidden		= 2
  constant long	xlSheetVisible		= -1

  // XlWindowState
  constant long	xlMaximized		= -4137
  constant long	xlMinimized		= -4140
  constant long	xlNormal			= -4143

end variables

forward prototypes
public function integer fp_setvisible (boolean a_visible)
public function integer fp_workbooksadd ()
public function integer fp_isinteractive (ref boolean a_inretactive)
public function integer fp_setinteractive (boolean a_interactive)
public function integer fp_setwindowscaption (integer a_window, string a_caption)
public function integer fp_setsheetname (integer a_sheet, string a_name)
public function integer fp_rangeselect (string a_range)
public function integer fp_getsaveasfilename (ref string a_file)
public function integer fp_saveas (string a_file)
public function integer fp_close ()
public function integer fp_quit ()
public function integer fp_setstatusbar (string a_text)
public function integer fp_columnsinsert (unsignedinteger a_col)
public function integer fp_sheetpaste ()
public function integer fp_setrowsnumberformat (unsignedinteger a_row, string a_format)
public function integer fp_setcolumnsnumberformat (unsignedinteger a_col, string a_format)
public function integer fp_setcolumnsfontname (unsignedinteger a_col, string a_name)
public function integer fp_setcolumnsfontsize (unsignedinteger a_col, integer a_size)
public function integer fp_setcolumnsfontbold (unsignedinteger a_col, boolean a_bold)
public function integer fp_setcolumnsfontitalic (unsignedinteger a_col, boolean a_italic)
public function integer fp_setcolumnsfontundetline (unsignedinteger a_col, boolean a_underline)
public function integer fp_setcolumnsinteriorcolor (unsignedinteger a_col, long a_color)
public function integer fp_setcolumnshorizontalalignment (unsignedinteger a_col, long a_align)
public function integer fp_setcolumnscolumnwidth (unsignedinteger a_col, double a_width)
public function integer fp_setcellsfontname (unsignedinteger a_row, unsignedinteger a_col, string a_name)
public function integer fp_setcellsfontsize (unsignedinteger a_row, unsignedinteger a_col, integer a_size)
public function integer fp_setcellsfontbold (unsignedinteger a_row, unsignedinteger a_col, boolean a_bold)
public function integer fp_setcellsfontitalic (unsignedinteger a_row, unsignedinteger a_col, boolean a_italic)
public function integer fp_setcellsinteriorcolor (unsignedinteger a_row, unsignedinteger a_col, long a_color)
public function integer fp_setcellshorizontalalignment (unsignedinteger a_row, unsignedinteger a_col, long a_align)
public function integer fp_setcellsverticalalignment (unsignedinteger a_row, unsignedinteger a_col, long a_align)
public function integer fp_setcellswraptext (unsignedinteger a_row, unsignedinteger a_col, boolean a_wrap)
public function integer fp_setcellsnumberformat (unsignedinteger a_row, unsignedinteger a_col, string a_format)
public function integer fp_rangemerge (string a_range)
public function integer fp_getversion (ref string a_version)
public function integer fp_rowsinsert (unsignedinteger a_row)
public function integer fp_setcolumnsfontcolor (unsignedinteger a_col, long a_color)
public function integer fp_setcellsfontunderline (unsignedinteger a_row, unsignedinteger a_col, boolean a_underline)
public function integer fp_setcellsfontcolor (unsignedinteger a_row, unsignedinteger a_col, long a_color)
public function integer fp_workbookscount (ref integer a_count)
public function integer fp_workbooksopen (string a_filename)
public function integer fp_worksheetsactivate (string a_sheetname)
public function integer fp_rangedelete (string a_range)
public function integer fp_workbooksaveas (string a_filename)
public function integer Fp_WorkBookClose ()
public function integer fp_workbooksave ()
public function integer fp_worksheetsadd ()
public function integer fp_worksheetscount (ref long a_count)
public function integer fp_worksheetsitemname (long a_sheetnumber, ref string a_sheetname)
public function integer Fp_RangeClear (string a_range)
public function integer fp_worksheetsnamegetvisible (string a_sheetname, ref boolean a_sheetvisible)
public function integer fp_worksheetsnamesetvisible (string a_sheetname, boolean a_sheetvisible)
public function integer fp_windowstate (long a_state)
public function integer Fp_RangeClearContents (string a_range)
public function integer fp_applicationrun (string a_macro)
end prototypes

public function integer fp_setvisible (boolean a_visible);
//This.Application.Visible = a_visible

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Visible = a_visible
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Visible = a_visible
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_workbooksadd ();
// This.Application.WorkBooks.Add

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkBooks
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkBooks
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Add
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Add
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_isinteractive (ref boolean a_inretactive);
// a_inretactive = This.Application.Interactive

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Interactive
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Interactive
if ole_2.p_Detect_Err <> 0 then goto Finish
a_inretactive = ole_tmp

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setinteractive (boolean a_interactive);
// This.Application.Interactive = a_interactive

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Interactive = a_interactive
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Interactive = a_interactive
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setwindowscaption (integer a_window, string a_caption);
// This.Application.ActiveWorkBook.Windows( a_window ).Caption = a_caption

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Windows( a_window )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Windows( a_window )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Caption = a_caption
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Caption = a_caption
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setsheetname (integer a_sheet, string a_name);
// This.Application.ActiveWorkBook.ActiveSheet.Name = a_name

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Name = a_name
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Name = a_name
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_rangeselect (string a_range);
// This.Application.ActiveWorkBook.ActiveSheet.Range( a_range ).Select

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Range( a_range )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Range( a_range )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Select
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Select
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_getsaveasfilename (ref string a_file);
// This.GetSaveAsFileName( a_file )

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> GetSaveAsFileName( a_file )
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.GetSaveAsFileName( a_file )
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_saveas (string a_file);
// This.Application.ActiveWorkBook.SaveAs( a_file )

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> SaveAs( a_file )
ole_2.SetAutomationPointer( ole_tmp )
ole_2.SaveAs( a_file )
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_close ();
//This.ActiveWorkBook.Close()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> ActiveWorkBook
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Close()
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Close()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_quit ();
// This.Quit()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Quit()
ole_2.SetAutomationPointer( This )
ole_2.Quit()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setstatusbar (string a_text);
// This.Application.StatusBar = a_text

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> StatusBar = a_name
ole_2.SetAutomationPointer( ole_tmp )
if a_text = "" then
	ole_2.StatusBar = False
else
	ole_2.StatusBar = a_text
end if
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_columnsinsert (unsignedinteger a_col);
//This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Insert

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Insert
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Insert
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_sheetpaste ();
//This.Application.ActiveWorkBook.ActiveSheet.Paste()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Paste()
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Paste()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setrowsnumberformat (unsignedinteger a_row, string a_format);
// This.Application.ActiveWorkBook.ActiveSheet.Rows( a_row ).NumberFormat = a_format

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Rows( a_row )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Rows( a_row )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> NumberFormat = a_format
ole_2.SetAutomationPointer( ole_tmp )
ole_2.NumberFormat = a_format
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err




end function

public function integer fp_setcolumnsnumberformat (unsignedinteger a_col, string a_format);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).NumberFormat = a_format

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> NumberFormat = a_format
ole_2.SetAutomationPointer( ole_tmp )
ole_2.NumberFormat = a_format
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcolumnsfontname (unsignedinteger a_col, string a_name);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Font.Name = a_name

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Name = a_name
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Name = a_name
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcolumnsfontsize (unsignedinteger a_col, integer a_size);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Font.Size = a_size

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Size = a_size
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Size = a_size
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcolumnsfontbold (unsignedinteger a_col, boolean a_bold);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Font.Bold = a_bold

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Bold = a_bold
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Bold = a_bold
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setcolumnsfontitalic (unsignedinteger a_col, boolean a_italic);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Font.Italic = a_italic

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Italic = a_italic
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Italic = a_italic
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setcolumnsfontundetline (unsignedinteger a_col, boolean a_underline);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Font.Underline = a_underline

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Underline = a_underline
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Underline = a_underline
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcolumnsinteriorcolor (unsignedinteger a_col, long a_color);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Interior.Color = a_color

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Interior
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Interior
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Color = a_color
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Color = a_color
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setcolumnshorizontalalignment (unsignedinteger a_col, long a_align);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).HorizontalAlignment = a_align

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> HorizontalAlignment = a_align
ole_2.SetAutomationPointer( ole_tmp )
ole_2.HorizontalAlignment = a_align
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcolumnscolumnwidth (unsignedinteger a_col, double a_width);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).ColumnWidth = a_width

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ColumnWidth = a_width
ole_2.SetAutomationPointer( ole_tmp )
ole_2.ColumnWidth = a_width
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcellsfontname (unsignedinteger a_row, unsignedinteger a_col, string a_name);
// This.Application.Cells( a_row, a_col ).Font.Name = a_name

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Name = a_name
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Name = a_name
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcellsfontsize (unsignedinteger a_row, unsignedinteger a_col, integer a_size);
// This.Application.Cells( a_row, a_col ).Font.Size = a_size

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Size = a_size
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Size = a_size
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcellsfontbold (unsignedinteger a_row, unsignedinteger a_col, boolean a_bold);
// This.Application.Cells( a_row, a_col ).Font.Bold = a_bold

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Bold = a_bold
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Bold = a_bold
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcellsfontitalic (unsignedinteger a_row, unsignedinteger a_col, boolean a_italic);
// This.Application.Cells( a_row, a_col ).Font.Italic = a_italic

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Italic = a_italic
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Italic = a_italic
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcellsinteriorcolor (unsignedinteger a_row, unsignedinteger a_col, long a_color);
// This.Application.Cells( a_row, a_col ).Interior.Color = a_color

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Interior
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Interior
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Color = a_color
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Color = a_color
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err




end function

public function integer fp_setcellshorizontalalignment (unsignedinteger a_row, unsignedinteger a_col, long a_align);
// This.Application.Cells( a_row, a_col ).HorizontalAlignment = a_align

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> HorizontalAlignment = a_align
ole_2.SetAutomationPointer( ole_tmp )
ole_2.HorizontalAlignment = a_align
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcellsverticalalignment (unsignedinteger a_row, unsignedinteger a_col, long a_align);
// This.Application.Cells( a_row, a_col ).VerticalAlignment = a_align

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> VerticalAlignment = a_align
ole_2.SetAutomationPointer( ole_tmp )
ole_2.VerticalAlignment = a_align
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcellswraptext (unsignedinteger a_row, unsignedinteger a_col, boolean a_wrap);
// This.Application.Cells( a_row, a_col ).WrapText = a_wrap

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WrapText = a_wrap
ole_2.SetAutomationPointer( ole_tmp )
ole_2.WrapText = a_wrap
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_setcellsnumberformat (unsignedinteger a_row, unsignedinteger a_col, string a_format);
// This.Application.Cells( a_row, a_col ).NumberFormat = a_format

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> NumberFormat = a_format
ole_2.SetAutomationPointer( ole_tmp )
ole_2.NumberFormat = a_format
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err




end function

public function integer fp_rangemerge (string a_range);
// This.Application.Range( a_range ).Merge()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Range( a_range )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Range( a_range )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Merge()
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Merge()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_getversion (ref string a_version);
// a_version = String( This.Application.Version )

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Version
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Version
if ole_2.p_Detect_Err <> 0 then goto Finish
a_version = ole_tmp

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_rowsinsert (unsignedinteger a_row);
// This.Aplication.ActiveWorkBook.ActiveSheet.Rows( a_row ).Insert

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Rows( a_row )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Rows( a_row )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Insert
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Insert
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_setcolumnsfontcolor (unsignedinteger a_col, long a_color);
// This.Application.ActiveWorkBook.ActiveSheet.Columns( a_col ).Font.Color = a_color

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Columns( a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Columns( a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Color = a_color
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Color = a_color
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcellsfontunderline (unsignedinteger a_row, unsignedinteger a_col, boolean a_underline);
// This.Application.Cells( a_row, a_col ).Font.Underline = a_underline

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Underline = a_underline
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Underline = a_underline
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_setcellsfontcolor (unsignedinteger a_row, unsignedinteger a_col, long a_color);
// This.Application.Cells( a_row, a_col ).Font.Color = a_color

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Cells( a_row, a_col )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Cells( a_row, a_col )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Font
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Font
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Color = a_color
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Color = a_color
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err



end function

public function integer fp_workbookscount (ref integer a_count);
// return Integer( This.Application.WorkBooks.count )

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkBooks
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkBooks
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Count
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Count
if ole_2.p_Detect_Err <> 0 then goto Finish
a_count = ole_tmp

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_workbooksopen (string a_filename);
// This.Application.WorkBooks.Open( a_fileName )
any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkBooks
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkBooks
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Open
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Open( a_fileName )
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_worksheetsactivate (string a_sheetname);
//This.Application.ActiveWorkBook.WorkSheets( a_sheetName ).Activate()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkSheets
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkSheets( a_sheetName )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Activate()
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Activate()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_rangedelete (string a_range);
// This.Application.ActiveWorkBook.ActiveSheet.Range( a_range ).Delete

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Range( a_range )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Range( a_range )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Delete()
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Delete()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_workbooksaveas (string a_filename);
// This.Application.ActiveWorkBook.SaveAs( a_fileName )

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> SaveAs()
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.SaveAs( a_fileName )
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer Fp_WorkBookClose ();
// This.Application.WorkBooks.Close

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkBooks
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkBooks
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Close
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Close
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_workbooksave ();
// This.Application.ActiveWorkBook.Save()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Save()
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Save()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_worksheetsadd ();
// This.Application.ActiveWorkBook.WorkSheets.Add()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkSheets
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkSheets
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Add()
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Add()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_worksheetscount (ref long a_count);
// This.Application.ActiveWorkBook.WorkSheets.Count( a_count )

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkSheets
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkSheets
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Count
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Count
if ole_2.p_Detect_Err <> 0 then goto Finish
a_count = ole_tmp

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_worksheetsitemname (long a_sheetnumber, ref string a_sheetname);
// This.Application.ActiveWorkBook.WorkSheets.Item( a_sheetNumber ).Name

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkSheets
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkSheets
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Item( a_sheetNumber )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Item( a_sheetNumber )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Name
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Name
if ole_2.p_Detect_Err <> 0 then goto Finish
a_sheetName = ole_tmp

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer Fp_RangeClear (string a_range);
// This.Application.ActiveWorkBook.ActiveSheet.Range( a_range ).Clear()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Range( a_range )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Range( a_range )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Clear()
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Clear()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_worksheetsnamegetvisible (string a_sheetname, ref boolean a_sheetvisible);
//This.Application.ActiveWorkBook.WorkSheets( a_sheetName ).Visible

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkSheets
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkSheets( a_sheetName )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Visible
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Visible
if ole_2.p_Detect_Err <> 0 then goto Finish
a_sheetVisible = ( ole_tmp = xlSheetVisible )

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_worksheetsnamesetvisible (string a_sheetname, boolean a_sheetvisible);
//This.Application.ActiveWorkBook.WorkSheets( a_sheetName ).Visible

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WorkSheets
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.WorkSheets( a_sheetName )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Visible
ole_2.SetAutomationPointer( ole_tmp )
ole_2.Visible = a_sheetVisible
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err

end function

public function integer fp_windowstate (long a_state);
// This.Application.WindowState()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> WindowState()
ole_2.SetAutomationPointer( ole_tmp )
ole_2.WindowState = a_state
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err




end function

public function integer Fp_RangeClearContents (string a_range);
// This.Application.ActiveWorkBook.ActiveSheet.Range( a_range ).ClearContents()

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveWorkBook
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveWorkBook
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> ActiveSheet
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ActiveSheet
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Range( a_range )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Range( a_range )
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Clear()
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.ClearContents()
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

public function integer fp_applicationrun (string a_macro);
// This.Application.Run(a_macro)

any				ole_tmp
nvo_OLE_Excel	ole_2

ole_2 = Create nvo_OLE_Excel

// -> Application
ole_2.SetAutomationPointer( This )
ole_tmp = ole_2.Application
if ole_2.p_Detect_Err <> 0 then goto Finish

// -> Run( a_macro )
ole_2.SetAutomationPointer( ole_tmp )
ole_tmp = ole_2.Run( a_macro )
if ole_2.p_Detect_Err <> 0 then goto Finish

Finish:
	p_Detect_Err = ole_2.p_Detect_Err
	
	if isValid( ole_2 ) then Destroy ole_2
	return p_Detect_Err


end function

on nvo_ole_excel.create
call oleobject::create
TriggerEvent( this, "constructor" )
end on

on nvo_ole_excel.destroy
call oleobject::destroy
TriggerEvent( this, "destructor" )
end on

event error;
////////////////////////////////////////////////////////
//
// Detekce chyby pri komunikaci s Excelem
//
// ----------------------------------------------------
// parm:
//
//	----------------------------------------------------
// return:
//		0		.. OK
//
//	----------------------------------------------------
//	zmeny:
//		26.6.1998	PKozak		vytvoreni
//


MessageBox( "Export Excel", "Byla detekována chyba při komunikaci s Excelem." + &
									"~n~nText:" + &
									"~n" + errorText, StopSign! )

if p_lg_Debug then
	MessageBox( ClassName() + "::Event Error", &
						"~nNumber ~t= " + String( errornumber ) + &
						"~nText   ~t= " + errortext + &
						"~nWindow/Menu = " + errorwindowmenu + &
						"~nObject ~t= " + errorobject + &
						"~nScript ~t= " + errorscript + &
						"~nLine   ~t= " + String( errorline ) )

end if

p_Detect_Err 	= c_Error
action 			= ExceptionIgnore!

end event

event externalexception;
////////////////////////////////////////////////////////
//
// Zpracovani Vyjimky pro komunikaci s Excelem
//
// ----------------------------------------------------
// parm:
//
//	----------------------------------------------------
// return:
//		0		.. OK
//
//	----------------------------------------------------
//	zmeny:
//		26.6.1998	PKozak		vytvoreni
//		26.6.1998	PKozak		Zrusen MessageBox, pouze se chyba ignoruje
//

// PKozak
MessageBox( "Export Excel", "Byla detekována výjímečná situace při komunikaci s Excelem." + &
									"~n~nText:" + &
									"~n" + description, StopSign! )

if p_lg_Debug then
//	MessageBox( ClassName() + "::Event ExternalException", &
//						"~nNumber ~t= " + String( exceptioncode ) + &
//						"~nText   ~t= " + errortext + &
//						"~nWindow/Menu = " + errorwindowmenu + &
//						"~nObject ~t= " + errorobject + &
//						"~nScript ~t= " + errorscript + &
//						"~nLine   ~t= " + String( errorline ) )
//
end if

p_Detect_Err 	= c_Except
action 			= ExceptionIgnore!

end event

