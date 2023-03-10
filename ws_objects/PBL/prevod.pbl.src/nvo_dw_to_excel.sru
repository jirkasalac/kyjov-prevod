$PBExportHeader$nvo_dw_to_excel.sru
$PBExportComments$Export DataWindow do Excelu
forward
global type nvo_dw_to_excel from nonvisualobject
end type
type o_str_dw_obj from structure within nvo_dw_to_excel
end type
end forward

type o_str_dw_obj from structure
	string		obj_name
	string		obj_band
	string		obj_type
	boolean		obj_visible
	integer		obj_order
end type

global type nvo_dw_to_excel from nonvisualobject
end type
global nvo_dw_to_excel nvo_dw_to_excel

type variables
public:
  string		p_work_dir	= "C:\Windows\Temp"
  string		p_tmp_file	= "Export.tmp"
  string		p_win_name	= "Export dat"
  string		p_sheet_data	= "Data"
  string		p_sheet_graph	= "Graf"
	n_cst_filesrv	inv_filesrv
  // 1	.. OLE
  // 2	.. DDE	neni funkcni
  // 3	.. File	neni funkcni
  // 4	.. Clipboard
  integer		p_export_data	= 4

  string		p_Def_Format_Char		= "@"
  string		p_Def_Format_Date	= "dd.mm.yyyy"
  string		p_Def_Format_DateTime	= "dd.mm.yyyy" // hh:mm
  string		p_Def_Format_Decimal	= "# ##0.00"
  string		p_Def_Format_Int		= "# ##0"
  string		p_Def_Format_Long	= "# ##0"
  string		p_Def_Format_Number	= "# ##0.00"
  string		p_Def_Format_Time	= "hh:mm"
  string		p_Def_Format_Timestamp	= "dd.mm.yyyy" // h:mm
  string		p_Def_Format_Other	= ""		// Excel default

  boolean		p_lg_Graph		= True	// Zpracuje Graf

  boolean		p_lg_Stitk_Color		= False
  boolean		p_lg_Col_Dnes		= True	// Pokud se najde je zpracovana
  constant string	p_Col_Dnes		= "dnes"
  boolean		p_lg_Col_Sestava		= True	// Pokud se najde je zpracovana
  constant string	p_Col_Sestava		= "sestava"
  boolean		p_lg_Col_Stitek		= True	// Prenese i ostatni stitky
  constant string	p_Col_Stitek		= "stitek"

  boolean		p_Interactive		= True	// False => Zakazano zasahovat do prubehu (Pracovat s Excelem)
  boolean		p_Visible			= True

  boolean		p_lg_Save		= False	// Po skonceni uloz
  boolean		p_lg_Save_Dialog		= True	// pro ulozeni nabydni dialog
				//	= False	// uloz do souboru viz nize
  string		p_Save_Path		= ""
  string		p_Save_File		= "Export.xls"
  
  boolean		p_lg_Close		= False	// Po exportu zavreni WorkBook
  boolean		p_lg_Quit			= False	// Po export zavreni Excelu

  boolean		p_lg_Col_Format		= True	// Formatovani sloupcu typove
  boolean		p_lg_Col_Def_Format	= True	// Pouzij default format
  boolean		p_lg_Col_Type_Format	= False	// Zda se ma provadet formatovat typ sloupecku z dw, pokud se v dw nenajde pak se pouzije default pokud je True
  boolean		p_lg_Col_Label_Format	= True	// Headers -> text
  boolean		p_lg_Col_Group_Format	= True	// Formatuje podle dw typu, False -> da char

  boolean		p_lg_Format_Label		= True	// Formatovani hlavicet (labels)
  boolean		p_lg_Label_Wrap_Text	= True	// Lamani textu
  boolean		p_lg_Label_Font		= True	// Font z dw, Bold, Italic, Underline, Size, FontName
  boolean		p_lg_Label_Color		= False	// Color
  boolean		p_lg_Label_HAlign		= True	// Align z dw
  long		p_Label_VAlign		= -4108	// Default align pro vertikal xlVAlignCenter

  boolean		p_lg_Format_Data		= True	// Formatovani dat
  boolean		p_lg_Data_Font		= True	// Font z dw
  boolean		p_lg_Data_Color		= False
  boolean		p_lg_Data_HAlign		= True  
  boolean		p_lg_Data_Width		= True

  boolean		p_lg_Format_Group		= True	// Formatuj skupiny
  boolean		p_lg_Group_Add_Col	= False	// True - vlozeni A sloupce
  boolean		p_lg_Group_Add_Cols	= True	// pro dalsi urovne vkladani sloupcu a zapis hodnot na tyto sloupce
  boolean		p_lg_Group_Krok		= False	// udela schody
  integer		p_Group_Add_Rows	= 1	// pocet radek mezera mezi skupinou

private:
  nvo_OLE_Excel	p_ole		// komunikacni objekt
//  OLEObject	p_ole		// komunikacni objekt
  DataWindow	p_dw		// exportovany objekt

  boolean		p_Except	  = False	// vyjimka

  string		p_Excel_Version	// verze Excelu

  string		p_detail_obj_spec
  string		p_detail_obj_label		// totozne s p_detail_obj_label_text ale ne texty
  string		p_detail_obj_label_text

  boolean		p_interactive_old		// puvodni rezim

  constant int	p_chunk_size	= 200

  string		p_group_col[]		// slp rozdelujici skupiny
  integer		p_group_cnt		// pocet skupin

  integer		p_col_cnt			// pocet datovych sloupecku
  integer		p_add_group_col		// pocet pridanych sloupecku pro skupiny

  integer		p_dw_type		// interni typ DW

  constant int	ci_NORMAL	= 1
  constant int	ci_GROUP	= 2
  constant int	ci_MATRIX	= 3

end variables

forward prototypes
public function integer fp_connect ()
public function integer fp_disconnect ()
protected function integer fp_parse_string_into_array (string a_string, ref string a_array[], string a_find)
protected function string fp_int_to_char (integer a_number)
protected function long fp_align_to_xlhalign (integer a_align)
public function integer fp_export_data_file (string a_file_name)
protected function integer fp_get_obj_atributes (string a_obj_name, ref string a_font_name, ref integer a_font_size, ref long a_font_color, ref long a_font_bg_color, ref boolean a_font_bold, ref boolean a_font_italic, ref boolean a_font_underline, ref long a_align_h, ref double a_col_width, ref integer a_escapement, ref integer a_border)
public function integer fp_get_objects ()
public function integer x_fp_get_report_layout ()
protected function integer fp_export_group_data_2 ()
public function integer x_fp_format_group ()
protected function integer fp_export_group_data_4 ()
public function integer fp_export_data_dde ()
public function integer fp_export_data_ole ()
protected function integer fp_export_group_data ()
protected function string fp_replace (string a_text, string a_find, string a_paste)
public function integer fp_export_analyza ()
public function integer fp_format_column ()
protected function string fp_get_col_format (string a_col_name)
public function integer fp_format_stitek ()
public function integer fp_export_data_clipboard ()
public function integer f_export (ref datawindow a_dw, string a_win_title)
protected function integer fp_format_label ()
public function integer fp_format_data ()
public function integer fp_export ()
public function integer f_export_p (ref datawindow a_dw, string a_win_title, string as_1, string as_2)
public function integer fp_export_p (string as_1, string as_2)
public function integer fp_nadpis (string as_1, string as_2)
end prototypes

public function integer fp_connect ();
////////////////////////////////////////////////////////
//
// Vytvoreni komunikacniho kanalu (OLE Object)
//	a spusteni aplikace Excel
//

boolean		lg_new	= False
integer		cnt
integer		ret

p_ole = Create nvo_OLE_Excel

ret = p_ole.ConnectToObject( "", "excel.application" )
if ret = -5 then															// Can't connect to the currently active object
	ret = p_ole.ConnectToNewObject( "excel.application" )
	lg_new = True
end if
if ret <> 0 then goto Finish

ret = p_ole.Fp_SetVisible( p_Visible )
if ret <> 0 then goto Finish

ret = p_ole.Fp_GetVersion( p_Excel_Version )
if ret <> 0 then goto Finish

if lg_new then
	ret = p_ole.Fp_WorkBooksCount( cnt )
	if ret <> 0 then goto Finish
	if cnt = 0 then
		ret = p_ole.Fp_WorkBooksAdd()
		if ret <> 0 then goto Finish
	end if
else
	ret = p_ole.Fp_WorkBooksAdd()
	if ret <> 0 then goto Finish
end if

ret = p_ole.Fp_IsInteractive( p_interactive_old )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SetInteractive( p_Interactive )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SetWindowsCaption( 1, p_win_name )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SetSheetName( 0, p_sheet_data )
if ret <> 0 then goto Finish

ret = 0
Finish:
	if ret <> 0 then
		if isValid( p_ole ) then Destroy p_ole
	end if
	return ret

end function

public function integer fp_disconnect ();
////////////////////////////////////////////////////////
//
// Odpojeni od Excelu
//

string		file_name
integer		ret			= 0

if isValid( p_ole ) then

	ret = p_ole.Fp_SetVisible( True )
	if ret <> 0 then return ret

	ret = p_ole.Fp_RangeSelect( "A1" )
	if ret <> 0 then return ret

	ret = p_ole.Fp_SetInteractive( p_Interactive_old )
	if ret <> 0 then return ret

	if p_lg_Save then
		if p_lg_Save_Dialog then
			ret = p_ole.Fp_GetSaveAsFileName( Trim( p_Save_File ) )
			if ret <> 0 then return ret
		else
			if Trim( p_Save_Path ) <> "" then file_name = Trim( p_Save_Path ) + "\"
			file_name += Trim( p_Save_File )
			ret = p_ole.Fp_SaveAs( file_name )
			if ret <> 0 then return ret
		end if
	end if
	
	if p_lg_Close then
		ret = p_ole.Fp_Close()
		if ret <> 0 then return ret
	end if
	if p_lg_Quit then
		ret = p_ole.Fp_Quit()
		if ret <> 0 then return ret
	end if
	
	ret = p_ole.DisconnectObject()
	Destroy p_ole

end if

return ret

end function

protected function integer fp_parse_string_into_array (string a_string, ref string a_array[], string a_find);
integer		pos_s1
string		arr_name
integer		arr_cnt	= 0

a_string = Trim( a_string )
do while a_string <> ""
	pos_s1 = Pos( a_string, a_find )
	if pos_s1 = 0 then pos_s1 = Len( a_string ) +1
	
	arr_name = Trim( Left( a_string, pos_s1 -1 ))
	a_string	= Trim( Mid(  a_string, pos_s1 +1 ))
	
	arr_cnt ++
	a_array[ arr_cnt ] = arr_name
loop

return arr_cnt

end function

protected function string fp_int_to_char (integer a_number);
string		ret_number	= ""
integer		grp			= 0

a_number --
grp = a_number / 26
a_number = Mod( a_number, 26 )

if grp > 0 then ret_number = Char( grp + 64 )
ret_number += String( Char( a_number + 65 ) )

return ret_number

end function

protected function long fp_align_to_xlhalign (integer a_align);
choose case a_align
	case 0;	return -4131		// Left
	case 1;	return -4152		// Right
	case 2;	return -4108		// Center
	case 3;	return -4130		// Justify
end choose

return -4131

end function

public function integer fp_export_data_file (string a_file_name);
//long			row_cnt, start_row, end_row
//integer		chunk_max, i
//integer		file_num
//integer		ret
//string		row_select
//string		row_data
//
//
//// Export Dat Soubor
//// -----------------
//row_cnt = p_dw.RowCount()
//chunk_max = ( row_cnt / p_chunk_size ) + 1
//
//if FileExists( a_file_name ) then FileDelete( a_file_name )
//
//file_num = FileOpen( a_file_name, StreamMode!, Write!, LockReadWrite!, Append! )
//if file_num < 0 then
//	ret = 1001
//	goto Finish
//end if
//
//start_row = 1
//for i = 1 to chunk_max
//	end_row = i * p_chunk_size
//	if end_row > row_cnt then end_row = row_cnt
//	
//	row_select = String( start_row ) + "/" + String( end_row ) + "/" + p_detail_obj_spec
//	p_dw.Object.DataWindow.Selected = row_select
//	row_data = p_dw.Object.DataWindow.Selected.Data + "~r~n"
//	
//	FileWrite( file_num, row_data )
//	start_row = end_row + 1
//next
//FileClose( file_num )
//
//ret = 0
//Finish:
//	return ret

return -999

end function

protected function integer fp_get_obj_atributes (string a_obj_name, ref string a_font_name, ref integer a_font_size, ref long a_font_color, ref long a_font_bg_color, ref boolean a_font_bold, ref boolean a_font_italic, ref boolean a_font_underline, ref long a_align_h, ref double a_col_width, ref integer a_escapement, ref integer a_border);
////////////////////////////////////////////////////////
//
// Zjisteni potrebnych informaci a objektu z DW
//

if p_dw.Describe( a_obj_name + ".name" ) = "!" then return 1

a_font_name 		= p_dw.Describe( a_obj_name + ".font.face" )
a_font_size			= Abs( Integer( p_dw.Describe( a_obj_name + ".font.height" )))
a_font_color		= Long( p_dw.Describe( a_obj_name + ".color" ))
a_font_bg_color	= Long( p_dw.Describe( a_obj_name + ".backGround.color" ))
a_font_bold			= ( p_dw.Describe( a_obj_name + ".font.weight" ) = "700" )
a_font_italic		= ( Lower( p_dw.Describe( a_obj_name + ".font.italic" )) 	= "yes" )
a_font_underline	= ( Lower( p_dw.Describe( a_obj_name + ".font.underline" )) = "yes" )
a_align_h			= This.Fp_Align_To_XlHAlign( Integer( p_dw.Describe( a_obj_name + ".alignment" )))
a_col_width			= Double( Long( p_dw.Describe( a_obj_name + ".Width" )) / 31.5 )
a_escapement		= 0
a_border				= 0

return 0

end function

public function integer fp_get_objects ();
string		objects
string		obj_name
string		obj_band
string		obj_type
string		obj_visible
boolean		obj_show
string		obj_select		= ""
string		obj_label		= ""
string		obj_label_text	= ""
integer		pos_s1

p_col_cnt = 0

// Vsechny objekty v DataWindow
// ----------------------------
objects = p_dw.Object.DataWindow.Objects
do while objects <> ""
	pos_s1 = Pos( objects, "~t" )
	if pos_s1 = 0 then pos_s1 = Len( objects ) +1
	
	obj_name = Trim( Left( objects, pos_s1 -1 ))
	objects	= Trim( Mid(  objects, pos_s1 +1 ))
	
	obj_band	= Lower( p_dw.Describe( obj_name + ".band" ))
	obj_type = Lower( p_dw.Describe( obj_name + ".type" ))
	obj_visible = p_dw.Describe( obj_name + ".visible" )
	//obj_show	= ( obj_visible = "1" or obj_visible = "1~t1" )
	obj_show		= ( obj_visible = "1" or Mid( obj_visible, 2, 2 ) = "1~t" )
	
	// Pouze ty co jsou v detailu a videt
	// ----------------------------------
	if obj_type = "column" or obj_type = "compute" then
		if obj_band = "detail" and obj_show then
			obj_select += "/" + obj_name
			p_col_cnt ++
		end if
	end if
loop
obj_select = "1/1" + obj_select

p_dw.SetRedraw( False )

// Setrideni objektu (detail a videt)
// podle umisteni v DataWindow
// ----------------------------------
p_dw.Object.DataWindow.Selected = obj_select
obj_select = p_dw.Object.DataWindow.Selected
obj_select = Mid( obj_select, 5 )
p_dw.Object.DataWindow.Selected = ""

p_dw.SetRedraw( True )

p_detail_obj_spec = obj_select

// Popisky (labels) k objektum
// ---------------------------
do while obj_select <> ""
	pos_s1 = Pos( obj_select, "/" )
	if pos_s1 = 0 then pos_s1 = Len( obj_select ) +1
	
	obj_name 	= Trim( Left( obj_select, pos_s1 -1 ))
	obj_select 	= Trim( Mid(  obj_select, pos_s1 +1 ))

	// Popisky (texty a name)
	// ----------------------
	if obj_label <> "" then
		obj_label 		+= "~t"
		obj_label_text += "~t"
	end if
	if p_dw.Describe( obj_name + "_t.name" ) <> "!" then
		obj_label 		+= p_dw.Describe( obj_name + "_t.name" )
		obj_label_text	+= This.Fp_Replace( p_dw.Describe( obj_name + "_t.text" ), "~r~n", "  " )
	else
		obj_label 		 += "?"
		obj_label_text  += " "
	end if
loop
p_detail_obj_label 		= obj_label
p_detail_obj_label_text = obj_label_text

return 0

end function

public function integer x_fp_get_report_layout ();
//string		objects
//string		obj_name
//string		obj_band
//string		obj_type
//string		obj_visible
//boolean		obj_show
//string		obj_select		= ""
//string		obj_label		= ""
//string		obj_label_text	= ""
//integer		pos_s1
//
//// Build detail object information
//// -------------------------------
//objects = p_dw.Object.DataWindow.Objects
//do while objects <> ""
//	pos_s1 = Pos( objects, "~t" )
//	if pos_s1 = 0 then pos_s1 = Len( objects ) +1
//	
//	obj_name = Trim( Left( objects, pos_s1 -1 ))
//	objects	= Trim( Mid(  objects, pos_s1 +1 ))
//	
//	obj_band	= Lower( p_dw.Describe( obj_name + ".band" ))
//	obj_type = Lower( p_dw.Describe( obj_name + ".type" ))
//	obj_visible = p_dw.Describe( obj_name + ".visible" )
//	obj_show	= ( obj_visible = "1" or obj_visible = "1~t1" )
//	
//	// Get only visible data field
//	// objects in the detail band
//	// ---------------------------
//	if obj_type = "column" or obj_type = "compute" then
//		if obj_band = "detail" and obj_show then obj_select += "/" + obj_name
//	end if
//loop
//obj_select = "1/1" + obj_select
//
//// Select object in detail 
//// based on selection spec.
//// ------------------------
//p_dw.SetRedraw( False )
//
//p_dw.Object.DataWindow.Selected = obj_select
//obj_select = p_dw.Object.DataWindow.Selected
//obj_select = Mid( obj_select, 5 )
//p_dw.Object.DataWindow.Selected = ""
//
//p_dw.SetRedraw( True )
//
//p_detail_obj_spec = obj_select
//
//// Get objet labels from 
//// ordered object list
//// ---------------------
//do while obj_select <> ""
//	pos_s1 = Pos( obj_select, "/" )
//	if pos_s1 = 0 then pos_s1 = Len( obj_select ) +1
//	
//	obj_name 	= Trim( Left( obj_select, pos_s1 -1 ))
//	obj_select 	= Trim( Mid(  obj_select, pos_s1 +1 ))
//	
//	// Get object Label
//	// ----------------
//	if obj_label <> "" then
//		obj_label 		+= "~t"
//		obj_label_text += "~t"
//	end if
//	if p_dw.Describe( obj_name + "_t.name" ) <> "!" then
//		obj_label 		+= p_dw.Describe( obj_name + "_t.name" )
//		obj_label_text	+= p_dw.Describe( obj_name + "_t.text" )
//	else
//		obj_label 		 += "?"
//		obj_label_text  += "?"
//	end if
//loop
//p_detail_obj_label 		= obj_label
//p_detail_obj_label_text = obj_label_text

return 0

end function

protected function integer fp_export_group_data_2 ();
string		row_data		= ""
string		group_data	= ""
string		fill_group_data	= ""
string		fill_row_data		= ""
string		row_select
long			row_cnt, group_row, new_group_row
long			i
integer		ret

for i = 1 to p_group_cnt -1
	fill_group_data += " ~t"
next
fill_group_data += "~r~n"

for i = 1 to p_col_cnt
	fill_row_data += " ~t"
next
fill_row_data += "~r~n"


p_dw.SetRedraw( False )

row_cnt = p_dw.RowCount()
group_row = 1
new_group_row = 1
do
	new_group_row = p_dw.FindGroupChange( group_row, p_group_cnt )
	if new_group_row = group_row then
		group_row = new_group_row
		new_group_row = p_dw.FindGroupChange( group_row + 1, p_group_cnt )
	end if
	new_group_row --
	if new_group_row <= 0 then new_group_row = row_cnt
	
	for i = 1 to p_group_cnt
		p_dw.Object.DataWindow.Selected = String( group_row ) + "/" + String( group_row ) + "/" + p_group_col[ i ] + "/" + p_group_col[ i ]
		group_data += p_dw.Object.DataWindow.Selected.Data
		if i <> p_group_cnt then group_data += "~t"
	next
	group_data += "~r~n"
	for i = group_row to new_group_row -1
		group_data += fill_group_data
	next

	row_select = String( group_row ) + "/" + String( new_group_row ) + "/" + p_detail_obj_spec
	p_dw.Object.DataWindow.Selected = row_select
	row_data += p_dw.Object.DataWindow.Selected.Data
	row_data += "~r~n"
	
	for i = 1 to p_Group_Add_Rows
		group_data 	+= fill_group_data
		row_data 	+= fill_row_data
	next
	
	group_row = new_group_row + 1
	
loop while group_row < row_cnt

Clipboard( group_data )
ret = p_ole.Fp_RangeSelect( "A2" )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SheetPaste()
if ret <> 0 then goto Finish

Clipboard( row_data )
ret = p_ole.Fp_RangeSelect( This.Fp_Int_To_Char( p_add_group_col + 1 ) + "2" )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SheetPaste()
if ret <> 0 then goto Finish

ret = 0
Finish:
	p_dw.Object.DataWindow.Selected = ""
	p_dw.SetRedraw( True )

	return ret

end function

public function integer x_fp_format_group ();
//boolean		lg_add_col		= False
//string		dw_syntax
//integer		pos_s1
//string		group_col[]
//integer		group_cnt
//integer		group_level, j
//long			group_row
//integer		add_excel_row
//integer		excel_row
//integer		excel_col
//
//if not p_lg_Format_Group then return 0
//
//dw_syntax = p_dw.Object.DataWindow.Syntax
//pos_s1 = Pos( dw_syntax, "group(level=" )
//do while pos_s1 > 0
//	
//	dw_syntax = Mid( dw_syntax, pos_s1 )
//
//	pos_s1 = Pos( dw_syntax, "by=(~"" )
//	dw_syntax = LeftTrim( Mid( dw_syntax, pos_s1 + Len( "by=(~"" ) ))
//	pos_s1 = Pos( dw_syntax, "~"" )
//	
//	group_cnt ++
//	group_col[ group_cnt ] = Trim( Mid( dw_syntax, 1, pos_s1 -1 ))
//	
//	if p_lg_Group_Add_Col then
//		if not lg_add_col then p_ole.Columns( 1 ).Insert
//		if p_lg_Group_Add_Cols and lg_add_col then p_ole.Columns( 1 ).Insert
//		lg_add_col = True
//	end if
//
//	pos_s1 = Pos( dw_syntax, "group(level=" )
//loop
//
//excel_row = 1
//excel_col = 1
//add_excel_row = 1
//
//for group_level = 1 to group_cnt
//
//	group_row = p_dw.FindGroupChange( 1, group_level )
//	do while group_row <> 0
//
//		for j = 1 to p_Group_Add_Rows + 1
//			p_ole.Rows( add_excel_row + group_row ).Insert
//			add_excel_row ++
//		next
//		
//		if p_lg_Group_Add_Col then
//			if p_lg_Group_Add_Cols then excel_col = group_level
//		end if
//		excel_row = add_excel_row + group_row -1
//		
//		Clipboard( p_dw.GetItemString( group_row, group_col[ group_level ] ) )
//		p_ole.Cells( excel_row, excel_col ).Select
//		p_ole.ActiveSheet.Paste()
//		
//		group_row = p_dw.FindGroupChange( group_row +1, group_level )
//	loop
//	
//	ClipBoard( "" )
//next

return 0

end function

protected function integer fp_export_group_data_4 ();
string		row_data		= ""
string		group_data	= ""
string		fill_group_data	= ""
string		fill_row_data		= ""
string		row_select
long			row_cnt, group_row, new_group_row
long			i
integer		ret

for i = 1 to p_col_cnt - 1
//	fill_group_data += " ~t"
next
fill_group_data += "~r~n"

for i = 1 to p_col_cnt
	fill_row_data += " ~t"
next
fill_row_data += "~r~n"


p_dw.SetRedraw( False )

row_cnt = p_dw.RowCount()
group_row = 1
new_group_row = 1
do
	new_group_row = p_dw.FindGroupChange( group_row, p_group_cnt )
	if new_group_row = group_row then
		group_row = new_group_row
		new_group_row = p_dw.FindGroupChange( group_row + 1, p_group_cnt )
	end if
	new_group_row --
	if new_group_row <= 0 then new_group_row = row_cnt
	
	for i = 1 to p_group_cnt
		p_dw.Object.DataWindow.Selected = String( group_row ) + "/" + String( group_row ) + "/" + p_group_col[ i ] + "/" + p_group_col[ i ]

		row_data += p_dw.Object.DataWindow.Selected.Data
		row_data += fill_group_data
	next

	row_select = String( group_row ) + "/" + String( new_group_row ) + "/" + p_detail_obj_spec
	p_dw.Object.DataWindow.Selected = row_select
	row_data += p_dw.Object.DataWindow.Selected.Data
	row_data += "~r~n"
	
	for i = 1 to p_Group_Add_Rows
		row_data 	+= fill_row_data
	next
	
	group_row = new_group_row + 1
loop while group_row < row_cnt

Clipboard( row_data )
ret = p_ole.Fp_RangeSelect( "A2" )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SheetPaste()
if ret <> 0 then goto Finish

ret = 0
Finish:
	p_dw.Object.DataWindow.Selected = ""
	p_dw.SetRedraw( True )

	return ret

end function

public function integer fp_export_data_dde ();
//long			DDE_handle
//long			row_cnt, i
//integer		col_cnt, j
//string		row_select
//string		row_data
//string		col_value[]
//string		cell_adr
//integer		ret
//
//// Export Dat DDE
//// --------------
//
//// Inicializace DDE
//// ----------------
//DDE_handle = OpenChannel( "Excel", "System" )
//if DDE_handle < 0 then 
//	ret = DDE_handle; goto Finish
//end if
//
//// Prenos dat DDE
//// --------------
//row_cnt = p_dw.RowCount()
//for i = 1 to row_cnt
//	
//	row_select = String( i ) + "/" + String( i ) + "/" + p_detail_obj_spec
//	
//	p_dw.Object.DataWindow.Selected = row_select
//	row_data = p_dw.Object.DataWindow.Selected.Data
//	
//	col_cnt = This.Fp_Parse_String_Into_Array( row_data, col_value[], "~t" )
//	for j = 1 to col_cnt
//		cell_adr = "R" + String( i + 1 ) + "C" + String( j )
//		ret = SetRemote( cell_adr, This.Fp_Replace( col_value[ j ], "~r~n", " " ), DDE_handle )
//		if ret <> 1 then goto Finish
//	next
//next
//
//ret = 0
//Finish:
//	if DDE_handle > 0 then CloseChannel( DDE_handle )
//	
//	return ret

return -999

end function

public function integer fp_export_data_ole ();
//long			row_cnt, i
//integer		col_cnt, j
//string		row_select
//string		row_data
//string		col_value[]
//
//// Export Dat OLE
//// --------------
//row_cnt = p_dw.RowCount()
//for i = 1 to row_cnt
//	
//	row_select = String( i ) + "/" + String( i ) + "/" + p_detail_obj_spec
//	
//	p_dw.Object.DataWindow.Selected = row_select
//	row_data = p_dw.Object.DataWindow.Selected.Data
//
//	col_cnt = This.Fp_Parse_String_Into_Array( row_data, col_value[], "~t" )
//	for j = 1 to col_cnt
//		p_ole.Cells( i +1, j ).value = This.Fp_Replace( col_value[ j ], "~r~n", " " )
//	next
//next
//
//return 0

return -999

end function

protected function integer fp_export_group_data ();


//  boolean		p_lg_Format_Group		= True	// Formatuj skupiny
//  boolean		p_lg_Group_Add_Col	= False	// True - vlozeni A sloupce
//  boolean		p_lg_Group_Add_Cols	= False	// pro dalsi urovne vkladani sloupcu a zapis hodnot na tyto sloupce
//  boolean		p_lg_Group_Krok		= False	// udela schody
//  integer		p_Group_Add_Rows	= 1	// pocet radek mezera mezi skupinou

integer		group_type
integer		ret

if p_lg_Format_Group then
	if p_lg_Group_Add_Col then
		if p_lg_Group_Add_Cols then
			if p_lg_Group_Krok then
				group_type = 1
				// gr1
				//			gr2
				//					gr3
				//							Data
			else
				group_type = 2
				//	gr1	gr2	gr3	Data
			end if
		else
			if p_lg_Group_Krok then
				group_type = 3
				//	gr1
				//	gr2
				//	gr3
				//			Data
			else
				//	gr1	Data
				//	gr2
				//	gr3
			end if
		end if
	else
		group_type = 4
		// gr1
		//	gr2
		//	gr3
		//	Data
	end if
else
	group_type = 4
	// gr1
	// gr2
	// gr3
	// Data
end if

choose case group_type
	case 1
	case 2
		ret = This.Fp_Export_Group_Data_2()
	case 3
	case 4
		ret = This.Fp_Export_Group_Data_4()
end choose

return 0

end function

protected function string fp_replace (string a_text, string a_find, string a_paste);
integer		len_repl
integer		pos_s1

len_repl = Len( a_find )

pos_s1 = Pos( a_text, a_find )
do while pos_s1 > 0
	a_text = Replace( a_text, pos_s1, len_repl, a_paste )
	pos_s1 = Pos( a_text, a_find, pos_s1 + len_repl )
loop

return a_text

end function

public function integer fp_export_analyza ();
////////////////////////////////////////////////////////
//
// Zjisteni o jaky druh DataWindow se jedna
//

string		dw_syntax
long			row_cnt, group_row, new_group_row
integer		pos_s1
integer		i
integer		ret


// Zjisteni poctu skupin
// ---------------------
p_group_cnt = 0
dw_syntax = p_dw.Object.DataWindow.Syntax
pos_s1 = Pos( dw_syntax, "group(level=" )
do while pos_s1 > 0
	dw_syntax = Mid( dw_syntax, pos_s1 )

	pos_s1 = Pos( dw_syntax, "by=(~"" )
	dw_syntax = LeftTrim( Mid( dw_syntax, pos_s1 + Len( "by=(~"" ) ))
	pos_s1 = Pos( dw_syntax, "~"" )

	// Slp rozdelujici skupinu
	// -----------------------
	p_group_cnt ++
	p_group_col[ p_group_cnt ] = Trim( Mid( dw_syntax, 1, pos_s1 -1 ))

	// Kontrola existence slp k grp
	// ----------------------------
	if p_dw.Describe( p_group_col[ p_group_cnt ] + ".Type" ) = "!" then p_group_cnt --
	
	pos_s1 = Pos( dw_syntax, "group(level=" )
loop

// Jakeho typu je DW
// -----------------
if p_group_cnt > 0 then
	row_cnt = p_dw.RowCount()
	group_row = p_dw.FindGroupChange( 0, p_group_cnt )
	if group_row = 1 then
		new_group_row = p_dw.FindGroupChange( group_row +1, p_group_cnt )
		if new_group_row = 0 then
			p_dw_type = ci_NORMAL
		else
			choose case new_group_row - group_row
				case 1
					group_row = new_group_row
					new_group_row = p_dw.FindGroupChange( group_row +1, p_group_cnt )
					if new_group_row - group_row > 1 then
						p_dw_type = ci_GROUP
					else
						p_dw_type = ci_MATRIX
					end if
				case is > 1
					p_dw_type = ci_GROUP
			end choose					
		end if
	else
		
	end if
else
	p_dw_type = ci_NORMAL
end if

// Pridani sloupcu
// ---------------
choose case p_dw_type
	case ci_NORMAL
		p_add_group_col = 0

	case ci_MATRIX
		// Pridat pocet skupin
		// -------------------
		for i = 1 to p_group_cnt
			ret = p_ole.Fp_ColumnsInsert( 1 )
			if ret <> 0 then goto Finish
		next
		p_add_group_col = p_group_cnt

	case ci_GROUP
		if not p_lg_Format_Group or not p_lg_Group_Add_Col then
			p_add_group_col = 0
			goto Finish
		end if

		ret = p_ole.Fp_ColumnsInsert( 1 )
		if ret <> 0 then goto Finish
		
		p_add_group_col = 1
		if p_lg_Group_Add_Cols then
			for i = 2 to p_group_cnt
				ret = p_ole.Fp_ColumnsInsert( 1 )
				if ret <> 0 then goto Finish
			next
			p_add_group_col = p_group_cnt
		end if
end choose

Finish:
	return 0

end function

public function integer fp_format_column ();
////////////////////////////////////////////////////////
//
// Predformatovani policek
//

//OLEObject	ole_tmp
string		col_type
string		col_name[]
string		col_num_format
integer		col_cnt, j
integer		ret

if not p_lg_Col_Format then return 0

// Formatovani sloupecku
// ---------------------
col_cnt = This.Fp_Parse_String_Into_Array( p_detail_obj_spec, col_name[], "/" )
for j = 1 to col_cnt + p_add_group_col

	if j <= p_add_group_col then
		if p_lg_Col_Group_Format then
			col_num_format = This.Fp_Get_Col_Format( p_group_col[ j ] )
		else
			col_num_format = p_Def_Format_Char	
		end if
	else
		col_num_format = This.Fp_Get_Col_Format( col_name[ j - p_add_group_col ] )
	end if
	
	if col_num_format = "" then continue
	ret = p_ole.Fp_SetColumnsNumberFormat( j, col_num_format )
	if ret <> 0 then goto Finish
next
if p_lg_Col_Label_Format then 
	ret = p_ole.Fp_SetRowsNumberFormat( 1, p_Def_Format_Char )
	if ret <> 0 then goto Finish
end if

ret = 0
Finish:
	return ret


end function

protected function string fp_get_col_format (string a_col_name);
string		col_num_format
string		col_type

col_num_format 	= p_dw.Describe( a_col_name + ".format" )
if col_num_format = "!" or col_num_format = "[general]" or not p_lg_Col_Type_Format then col_num_format = ""

col_type = Lower( p_dw.Describe( a_col_name + ".colType" ))
//MessageBox (a_col_name, col_type + "," + col_num_format + "," + String (p_lg_Col_Def_Format))
choose case Left( col_type, 5 )
	case "char(";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Char
	case "date";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Date
	case "datet";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_DateTime
	case "decim";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Decimal
	case "int";			if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Int
	case "long";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Long
	case "numbe";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Number
	case "time";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Time
	case "times";		if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Timestamp
	case else;			if col_num_format = "" and p_lg_Col_Def_Format then col_num_format = p_Def_Format_Other
end choose
//MessageBox (a_col_name, col_type + "," + col_num_format + "," + String (p_lg_Col_Def_Format))

return col_num_format

end function

public function integer fp_format_stitek ();
//OLEObject	ole_tmp
string		font_name
integer		font_size
long			font_color
long			font_bg_color
boolean		is_font_bold
boolean		is_font_italic
boolean		is_font_underline
long			align_h
double		col_width
integer		escapement
integer		border
boolean		lg_Row_Add		= False
integer		ret


// Ostatni Stitek<n>
// -----------------
if p_lg_Col_Stitek then
end if


// Stitek Sestava
// --------------
if p_lg_Col_Sestava then
	ret = This.Fp_Get_Obj_Atributes( p_Col_Sestava, font_name, font_size, font_color, font_bg_color, &
										is_font_bold, is_font_italic, is_font_underline, &
										align_h, col_width, escapement, border )

	if ret = 0 then
		ret = p_ole.Fp_RowsInsert( 1 )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_RowsInsert( 1 )
		if ret <> 0 then goto Finish

		ret = p_ole.Fp_SetCellsNumberFormat( 1, 1, "@" )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsFontName( 1, 1, font_name )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontSize( 1, 1, font_size )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontBold( 1, 1, is_font_bold )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontItalic( 1, 1, is_font_italic )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontUnderline( 1, 1, is_font_underline )
		if ret <> 0 then goto Finish

		if p_lg_Stitk_Color then
			ret = p_ole.Fp_SetCellsFontColor( 1, 1, font_color )
			if ret <> 0 then goto Finish
			ret = p_ole.Fp_SetCellsInteriorColor( 1, 1, font_bg_color )
			if ret <> 0 then goto Finish
		end if

		ret = p_ole.Fp_SetCellsHorizontalAlignment( 1, 1, -4108 )		// xlHAlignCenter
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsVerticalAlignment( 1, 1, -4108 )			// xlVAlignCenter 
		if ret <> 0 then goto Finish

		Clipboard( Trim( This.Fp_Replace( This.Fp_Replace( p_dw.Describe( p_Col_Sestava + ".expression" ), "~"", " " ), "~~", "" ) ) )
		ret = p_ole.Fp_RangeSelect( "A1" )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SheetPaste()
		if ret <> 0 then goto Finish
		Clipboard( "" )
		
		ret = p_ole.Fp_RangeMerge( "A1:" + This.Fp_Int_To_Char( p_col_cnt + p_add_group_col ) + "1" )
		if ret <> 0 then goto Finish
	end if
end if

// Stitek DNES
// -----------
if p_lg_Col_Dnes then

	ret = This.Fp_Get_Obj_Atributes( p_Col_Dnes, font_name, font_size, font_color, font_bg_color, &
										is_font_bold, is_font_italic, is_font_underline, &
										align_h, col_width, escapement, border )

	if ret = 0 then
		ret = p_ole.Fp_RowsInsert( 1 )
		if ret <> 0 then goto Finish

		ret = p_ole.Fp_SetCellsNumberFormat( 1, 1, "@" )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsFontName( 1, 1, font_name )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontSize( 1, 1, font_size )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontBold( 1, 1, is_font_bold )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontItalic( 1, 1, is_font_italic )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsFontUnderline( 1, 1, is_font_underline )
		if ret <> 0 then goto Finish

		if p_lg_Stitk_Color then
			ret = p_ole.Fp_SetCellsFontColor( 1, 1, font_color )
			if ret <> 0 then goto Finish
			ret = p_ole.Fp_SetCellsInteriorColor( 1, 1, font_bg_color )
			if ret <> 0 then goto Finish
		end if

		ret = p_ole.Fp_SetCellsHorizontalAlignment( 1, 1, -4131 )		// xlHAlignLeft
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SetCellsVerticalAlignment( 1, 1, -4160 )			// xlVAlignTop
		if ret <> 0 then goto Finish

		Clipboard( Trim( This.Fp_Replace( This.Fp_Replace( p_dw.Describe( p_Col_Dnes + ".expression" ), "~"", "" ), "~~", "" ) ) )
		ret = p_ole.Fp_RangeSelect( "A1" )
		if ret <> 0 then goto Finish
		ret = p_ole.Fp_SheetPaste()
		if ret <> 0 then goto Finish
		Clipboard( "" )
	end if
end if

ret = 0
Finish:
	return ret

end function

public function integer fp_export_data_clipboard ();
long			row_cnt
integer		i
//integer		chunk_max
//long			start_row, end_row
//string		row_select		= ""
string		row_data
string		header_data		= ""
string		obj_dw_select	= ""
string		select_row
integer		ret

// Export Header
// -------------
for i = 1 to p_add_group_col
	header_data += " ~t"
next
header_data += p_detail_obj_label_text

Clipboard( header_data )

ret = p_ole.Fp_RangeSelect( "A1" )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SheetPaste()
if ret <> 0 then goto Finish

// Export Dat a Skupin
// -------------------
row_cnt = p_dw.RowCount()
if row_cnt <= 0 then return 0

select_row = "1/" + String( row_cnt ) + "/"
p_dw.SetRedraw( False )

// Export Skupin
// -------------
choose case p_dw_type
	case ci_NORMAL

	case ci_MATRIX
		for i = 1 to p_group_cnt
/**/			obj_dw_select = select_row + p_group_col[ i ] + "/" + p_group_col[ i ]

			p_dw.Object.DataWindow.Selected = obj_dw_select
			row_data = p_dw.Object.DataWindow.Selected.Data
			Clipboard( row_data )

			ret = p_ole.Fp_RangeSelect( This.Fp_Int_To_Char( i ) + "2" )
			if ret <> 0 then goto Finish
			
			ret = p_ole.Fp_SheetPaste()
			if ret <> 0 then goto Finish
		next

	case ci_GROUP
		ret = This.Fp_Export_Group_Data()
		goto Finish
	case else
		MessageBox( "Fp_Export_Data_Clipboard()", "Pro skupinu toto neni zatim implementovano" )
		return 100
end choose

// Export Dat
// ----------
p_dw.Object.DataWindow.Selected = select_row + p_detail_obj_spec
row_data = p_dw.Object.DataWindow.Selected.Data
//mb(row_data)
Clipboard( row_data )

ret = p_ole.Fp_RangeSelect( This.Fp_Int_To_Char( p_add_group_col + 1 ) + "2" )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SheetPaste()
if ret <> 0 then goto Finish

ret = 0
Finish:
	p_dw.Object.DataWindow.Selected = ""
	p_dw.SetRedraw( True )
	Clipboard( "" )
	
	return ret


// Starsi verze
// ------------
	//row_cnt = p_dw.RowCount()
	//chunk_max = ( row_cnt / p_chunk_size ) + 1
	//
	//start_row = 1
	//for i = 1 to chunk_max
	//	end_row = i * p_chunk_size
	//	if end_row > row_cnt then end_row = row_cnt
	//
	//	row_select = String( start_row ) + "/" + String( end_row ) + "/" + p_detail_obj_spec
	//	
	//	p_dw.Object.DataWindow.Selected = row_select
	//	row_data = p_dw.Object.DataWindow.Selected.Data
	//
	//	Clipboard( row_data )
	//	
	//	p_ole.Range( "A" + String( start_row +1 ) ).Select
	//	p_ole.ActiveSheet.Paste()
	//	
	//	start_row = end_row +1
	//next


end function

public function integer f_export (ref datawindow a_dw, string a_win_title);
////////////////////////////////////////////////////////
//
// Export DataWindow do aplikace Excel
//
//	return:
//		+0		.. Success
//		-1  	..	Invalid Call: the argument is the Object property of a control
//		-2  	..	Class name not found
//		-3  	..	Object could not be created
//		-4  	..	Could not connect to object
//		-5  	..	Can't connect to the currently active object
//		-6  	..	Filename is not valid
//		-7  	..	File not found or file couldn't be opened
//		-8  	.. Load from file not supported by server
//		-9  	..	Other error
//		-20	.. dataWindow is Null
//		-30	..	dataWindow nema Data neni co Exportovat
//

integer		ret

// Prevzeti parametru
// ------------------
if isNull( a_dw ) then return -20
p_dw = a_dw

SetPointer (HourGlass!)
if isNull( a_win_title ) or Len( Trim( a_win_title )) = 0 then a_win_title = p_win_name
p_win_name = a_win_title

if p_dw.RowCount() <= 0 then return -30

// Pripojeni na Excel
// ------------------
ret = This.Fp_Connect()
if ret <> 0 then goto Finish

// Export DataWindow
// -----------------  
ret = This.Fp_Export()
if ret <> 0 then goto Finish

// Odpojeni
// --------
ret = This.Fp_Disconnect()
if ret <> 0 then goto Finish

ret = 0
Finish:
	SetPointer (Arrow!)
	return ret

end function

protected function integer fp_format_label ();
//OLEObject	ole_tmp
integer		col_cnt, j, col_num
string		col_name[]
string		font_name
integer		font_size
long			font_color
long			font_bg_color
boolean		is_font_bold
boolean		is_font_italic
boolean		is_font_underline
long			align_h
double		col_width
integer		escapement
integer		border
integer		ret


if not p_lg_Format_Label then return 0

col_cnt = This.Fp_Parse_String_Into_Array( p_detail_obj_label, col_name[], "~t" )
for j = 1 to col_cnt
	
	col_num = j + p_add_group_col
	
	if col_name[ j ] = "?" then continue

	ret = This.Fp_Get_Obj_Atributes( col_name[ j ], font_name, font_size, font_color, font_bg_color, &
										is_font_bold, is_font_italic, is_font_underline, &
										align_h, col_width, escapement, border )
										
	// Formatovani podle DW
	// --------------------
	if p_lg_Label_Font then
		ret = p_ole.Fp_SetCellsFontName( 1, col_num, font_name )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsFontSize( 1, col_num, font_size )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsFontBold( 1, col_num, is_font_bold )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsFontItalic( 1, col_num, is_font_italic )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsFontUnderline( 1, col_num, is_font_underline )
		if ret <> 0 then goto Finish
	end if
	if p_lg_Label_Color then
		ret = p_ole.Fp_SetCellsFontColor( 1, col_num, font_color )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetCellsInteriorColor( 1, col_num, font_bg_color )
		if ret <> 0 then goto Finish
	end if
	
	if p_lg_Label_HAlign then 
		ret = p_ole.Fp_SetCellsHorizontalAlignment( 1, col_num, align_h )
		if ret <> 0 then goto Finish
	end if
	ret = p_ole.Fp_SetCellsVerticalAlignment( 1, col_num, p_Label_VAlign )
	if ret <> 0 then goto Finish

	ret = p_ole.Fp_SetCellsWrapText( 1, col_num, p_lg_Label_Wrap_Text )
	if ret <> 0 then goto Finish
next

ret = 0
Finish:
	return ret

end function

public function integer fp_format_data ();
//OLEObject	ole_tmp
string		col_name[]
integer		col_cnt, j
string		column_name
string		font_name
integer		font_size
long			font_color
long			font_bg_color
boolean		is_font_bold
boolean		is_font_italic
boolean		is_font_underline
long			align_h
double		col_width
integer		escapement
integer		border
integer		ret

if not p_lg_format_data then return 0

col_cnt = This.Fp_Parse_String_Into_Array( p_detail_obj_spec, col_name[], "/" )
for j = 1 to col_cnt + p_add_group_col
	
	if j <= p_add_group_col then
		column_name = p_group_col[ j ]
	else
		column_name = col_name[ j - p_add_group_col ]
	end if
	
	ret = This.Fp_Get_Obj_Atributes( column_name, font_name, font_size, font_color, font_bg_color, &
										is_font_bold, is_font_italic, is_font_underline, &
										align_h, col_width, escapement, border )

	if p_lg_Data_Font then
		ret = p_ole.Fp_SetColumnsFontName( j, font_name )
		if ret <> 0 then goto Finish
		
		ret = p_ole.Fp_SetColumnsFontSize( j, font_size )
		if ret <> 0 then goto Finish

		ret = p_ole.Fp_SetColumnsFontBold( j, is_font_bold )
		if ret <> 0 then goto Finish

		ret = p_ole.Fp_SetColumnsFontItalic( j, is_font_italic )
		if ret <> 0 then goto Finish

		ret = p_ole.Fp_SetColumnsFontUndetline( j, is_font_underline )
		if ret <> 0 then goto Finish
	end if
	if p_lg_Data_Color then
		ret = p_ole.Fp_Set_ColumnsFontColor( j, font_color )
		if ret <> 0 then goto Finish

		ret = p_ole.Fp_SetColumnsInteriorColor( j, font_bg_color )
		if ret <> 0 then goto Finish
	end if

	if p_lg_Data_HAlign then 
		ret = p_ole.Fp_SetColumnsHorizontalAlignment( j, align_h )
		if ret <> 0 then goto Finish
	end if
	if p_lg_Data_Width  then
		ret = p_ole.Fp_SetColumnsColumnWidth( j, col_width )
		if ret <> 0 then goto Finish
	end if
	
next

ret = 0
Finish:
	return ret

end function

public function integer fp_export ();
string		file_name
integer		ret

// Analyza Dat
// -----------
ret = p_ole.Fp_SetStatusBar( "Analýza Dat ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Get_Objects()
if ret <> 0 then goto Finish

// Analyza DW
// ----------
ret = p_ole.Fp_SetStatusBar( "Analýza Struktury ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Export_Analyza()
if ret <> 0 then goto Finish

// Pre Format Dat
// --------------
ret = p_ole.Fp_SetStatusBar( "Formátování Sloupců ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Column()
if ret <> 0 then goto Finish

// Export Dat
// ----------
ret = p_ole.Fp_SetStatusBar( "Export Dat ..." )
if ret <> 0 then goto Finish

choose case p_export_data
	case 4			// Clipboard
		ret = This.Fp_Export_Data_Clipboard()		
	case 2			// DDE
		ret = This.Fp_Export_Data_DDE()
	case 1			// OLE
		ret = This.Fp_Export_Data_OLE()
	case 3			// File
		file_name = p_work_dir + "\" + p_tmp_file
		ret = This.Fp_Export_Data_File( file_name )
		if ret <> 0 then goto Finish

//		p_ole.Range( "A2" ).Select
//		
//		p_ole.WorkBooks.OpenText( file_name )
//		
//		p_ole.WorkBooks.Window(1).Visible = False
//		p_ole.WorkBooks( p_tmp_file ).ActiveSheet.Copy()
//		p_ole.WorkBooks( p_tmp_file ).Close( False )
//		
//		p_ole.ActiveSheet.Paste()
//		
//		FileDelete( file_name )
//		
//		ret = 0
end choose
if ret <> 0 then goto Finish

// Formatovani dat
// ---------------
ret = p_ole.Fp_SetStatusBar( "Formátování Dat ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Data()
if ret <> 0 then goto Finish

// Format Labels
// -------------
ret = p_ole.Fp_SetStatusBar( "Formátování Hlaviček ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Label()
if ret <> 0 then goto Finish

// Format Groups
// -------------
		//p_ole.StatusBar = "Formátování Skupin ..."
		//ret = This.Fp_Format_Group()
		//if ret <> 0 then goto Finish


// Preneseni Stitku
// ----------------
ret = p_ole.Fp_SetStatusBar( "Formátování Stránky ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Stitek()
if ret <> 0 then goto Finish

ret = 0
Finish:
	ret = p_ole.Fp_SetStatusBar( "" )

	return ret

end function

public function integer f_export_p (ref datawindow a_dw, string a_win_title, string as_1, string as_2);
////////////////////////////////////////////////////////
//
// Export DataWindow do aplikace Excel
//
//	return:
//		+0		.. Success
//		-1  	..	Invalid Call: the argument is the Object property of a control
//		-2  	..	Class name not found
//		-3  	..	Object could not be created
//		-4  	..	Could not connect to object
//		-5  	..	Can't connect to the currently active object
//		-6  	..	Filename is not valid
//		-7  	..	File not found or file couldn't be opened
//		-8  	.. Load from file not supported by server
//		-9  	..	Other error
//		-20	.. dataWindow is Null
//		-30	..	dataWindow nema Data neni co Exportovat
//

integer		ret

// Prevzeti parametru
// ------------------
if isNull( a_dw ) then return -20
p_dw = a_dw

SetPointer (HourGlass!)
if isNull( a_win_title ) or Len( Trim( a_win_title )) = 0 then a_win_title = p_win_name
p_win_name = a_win_title

if p_dw.RowCount() <= 0 then return -30

// Pripojeni na Excel
// ------------------
ret = This.Fp_Connect()
if ret <> 0 then goto Finish

// Export DataWindow
// -----------------
ret = This.Fp_Export_p (as_1, as_2)
if ret <> 0 then goto Finish

// Odpojeni
// --------
ret = This.Fp_Disconnect()
if ret <> 0 then goto Finish

ret = 0
Finish:
	SetPointer (Arrow!)
	return ret

end function

public function integer fp_export_p (string as_1, string as_2);
string		file_name
integer		ret

// Analyza Dat
// -----------
ret = p_ole.Fp_SetStatusBar( "Analýza Dat ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Get_Objects()
if ret <> 0 then goto Finish

// Analyza DW
// ----------
ret = p_ole.Fp_SetStatusBar( "Analýza Struktury ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Export_Analyza()
if ret <> 0 then goto Finish

// Pre Format Dat
// --------------
ret = p_ole.Fp_SetStatusBar( "Formátování Sloupců ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Column()
if ret <> 0 then goto Finish

// Export Dat
// ----------
ret = p_ole.Fp_SetStatusBar( "Export Dat ..." )
if ret <> 0 then goto Finish

choose case p_export_data
	case 4			// Clipboard
		ret = This.Fp_Export_Data_Clipboard()		
	case 2			// DDE
		ret = This.Fp_Export_Data_DDE()
	case 1			// OLE
		ret = This.Fp_Export_Data_OLE()
	case 3			// File
		file_name = p_work_dir + "\" + p_tmp_file
		ret = This.Fp_Export_Data_File( file_name )
		if ret <> 0 then goto Finish

//		p_ole.Range( "A2" ).Select
//		
//		p_ole.WorkBooks.OpenText( file_name )
//		
//		p_ole.WorkBooks.Window(1).Visible = False
//		p_ole.WorkBooks( p_tmp_file ).ActiveSheet.Copy()
//		p_ole.WorkBooks( p_tmp_file ).Close( False )
//		
//		p_ole.ActiveSheet.Paste()
//		

//		FileDelete( file_name )
//		
//		ret = 0
end choose
if ret <> 0 then goto Finish

// Formatovani dat
// ---------------
ret = p_ole.Fp_SetStatusBar( "Formátování Dat ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Data()
if ret <> 0 then goto Finish

// Format Labels
// -------------
ret = p_ole.Fp_SetStatusBar( "Formátování Hlaviček ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Label()
if ret <> 0 then goto Finish

// Format Groups
// -------------
		//p_ole.StatusBar = "Formátování Skupin ..."
		//ret = This.Fp_Format_Group()
		//if ret <> 0 then goto Finish


// Preneseni Stitku
// ----------------
ret = p_ole.Fp_SetStatusBar( "Formátování Stránky ..." )
if ret <> 0 then goto Finish

ret = This.Fp_Format_Stitek()
if ret <> 0 then goto Finish

// Nadpis a Parametry sestavy
fp_nadpis (as_1, as_2)

ret = 0
Finish:
	ret = p_ole.Fp_SetStatusBar( "" )

	return ret

end function

public function integer fp_nadpis (string as_1, string as_2);long ret, ll, ll_radku = 5

// počet volných řádků
if as_2 = '' or isnull (as_2) then
	ll_radku = 3
	as_2 = ''		// aby nebyl null
end if

ret = p_ole.Fp_RangeSelect( "A1" )
for ll = 1 to ll_radku
	p_ole.worksheets(1).Rows(1).Insert
next

// nadpis - do 2. řádku
ret = p_ole.Fp_RangeSelect( "A2" )
if ret <> 0 then goto Finish

ret = p_ole.Fp_SetCellsFontBold( 2, 1, TRUE )
if ret <> 0 then goto Finish

clipboard (as_1)

ret = p_ole.Fp_SheetPaste()
if ret <> 0 then goto Finish

// parametry - do 4. řádku
if as_2 <> '' then

	ret = p_ole.Fp_RangeSelect( "A4" )
	if ret <> 0 then goto Finish
	
	clipboard (as_2)
	
	ret = p_ole.Fp_SheetPaste()
	if ret <> 0 then goto Finish
	
end if

finish:
return ret
end function

on nvo_dw_to_excel.create
call super::create
TriggerEvent( this, "constructor" )
end on

on nvo_dw_to_excel.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;
string		test_env

test_env = String( 1.23 )
f_SetFilesrv (inv_filesrv, TRUE)
IF NOT inv_filesrv.of_DirectoryExists (p_work_dir) THEN
	p_work_dir = "C:\winnt\temp"
	IF NOT inv_filesrv.of_DirectoryExists (p_work_dir) THEN
		p_work_dir = "C:"
	END IF
END IF
 
if Pos( test_env, "." ) > 0 then
	p_Def_Format_Decimal	= "# ##0.00"
	p_Def_Format_Number	= "# ##0.00"
else
	p_Def_Format_Decimal	= "# ##0,00"
	p_Def_Format_Number	= "# ##0,00"
end if	

//test_env = gs_rokexcel
test_env = gnv_app.is_rokexcel
IF test_env <> "yyyy" THEN
	p_Def_Format_Date	= "dd.mm." + test_env
	p_Def_Format_DateTime	= "dd.mm." + test_env //+ " hh:mm"
	p_Def_Format_Timestamp	= "dd.mm." + test_env //+ " h:mm"
END IF
end event

event destructor;
// uklid

if isValid( p_ole ) then Fp_Disconnect()
f_SetFilesrv (inv_filesrv, FALSE)

end event

