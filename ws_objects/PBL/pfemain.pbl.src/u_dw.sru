$PBExportHeader$u_dw.sru
$PBExportComments$Extension DataWindow class
forward
global type u_dw from pfc_u_dw
end type
end forward

global type u_dw from pfc_u_dw
event js_zaznamrec ( )
event js_posunrec ( )
event type long js_dwnkey ( keycode key,  unsignedlong keyflags )
event js_excel ( )
event js_invertselection ( )
event js_kopie ( )
event js_mycis ( string as_col )
event js_nactidddw ( )
event js_nahodretrieve ( )
event js_noedit ( )
event js_oznacvse ( )
event js_rowcount ( )
event js_rowselect ( )
event js_status ( )
event js_zrusselection ( )
end type
global u_dw u_dw

type variables
boolean 	ib_excel = FALSE		//povolen export do Excelu
String 	is_veta = ''  			//podmínka pro vyhledávání věty
String 	is_sql = ""				//sql prikaz pro Retrieve
String 	is_resize []			//pole pro dalsi objekty RESIZU
Boolean	ib_detail = FALSE		//je to detail - kvuli postupu pri ruseni
Boolean	ib_closewin = FALSE	//zavřít okno po ruseni
Boolean	ib_potlacikony = FALSE	//potlaceni ikon pro editaci dat
Boolean	ib_retrieve = FALSE	//automatický retreive při GetFocus
end variables

event js_zaznamrec();//slouží k zaznamenání podmínky pro nastavení na aktuální větu - ukládá se do is_veta
end event

event js_posunrec();//nastavení aktivní věty podle podminky sestavené v js_zaznamrec
Long		ll_row, ll_pocet

ll_pocet = This.RowCount ()
IF is_veta <> "" AND ll_pocet > 0 THEN
	ll_row = This.Find (is_veta, 1, ll_pocet)
	IF ll_row > 0 THEN
		This.ScrollToRow (ll_row)
	END IF
END IF

end event

event type long js_dwnkey(keycode key, unsignedlong keyflags);
//pouze pro detail
IF This.RowCount () = 1 AND ib_detail THEN
	IF keyflags = 2 THEN
		CHOOSE CASE key
		CASE KeyHome!, KeyPageUp!
			This.Event Pfc_FirstPage ()
		CASE KeyEnd!, KeyPageDown!
			This.Event Pfc_LastPage ()
		END CHOOSE
	END IF
	IF keyflags = 0 THEN
		CHOOSE CASE key
		CASE KeyPageUp!
			This.Event Pfc_PreviousPage ()
		CASE KeyPageDown!
			This.Event Pfc_NextPage ()
		END CHOOSE
	END IF
ELSE
	//kromě CTROL+HOME také pro CTRL+PageUp
	IF keyflags = 2 THEN
		CHOOSE CASE key
		CASE KeyHome!, KeyPageUp!
			This.Event Pfc_FirstPage ()
		CASE KeyEnd!, KeyPageDown!
			This.Event Pfc_LastPage ()
		END CHOOSE
	END IF
END IF
RETURN 0
end event

event js_excel();//export DW do Excelu
nvo_dw_to_excel	lole_excel
long					ll_row
u_dw					ldw_a

IF ib_excel THEN
	ll_row = This.RowCount ()
	IF ll_row > 0 THEN
		SetPointer (HourGlass!)
		lole_excel = CREATE nvo_dw_to_excel
		ldw_a = This
		lole_excel.f_export (ldw_a, This.Title)
		Destroy lole_excel
		SetPointer (Arrow!)
	END IF
END IF
end event

event js_invertselection();Integer 		li_style

IF IsValid (inv_rowselect) THEN
	li_style = inv_rowselect.of_GetStyle ()
	IF li_style = 1 OR li_style = 2 THEN
		This.inv_rowselect.of_InvertSelection ()
	END IF
ELSE
	MessageBox ("Info", "Označování záznamů není aktivní.")
END IF
end event

event js_kopie();//prázdný Event určený pro kopírování věty
end event

event js_mycis(string as_col);//Event ulozi ID (as_col) vybranych vet do tabulky #MYCIS
long ll_pocet, ll_selected [], ll_i, ll_a

IF IsValid (This.inv_rowselect) THEN
	ll_pocet = This.inv_rowselect.of_SelectedCount(ll_selected)
	IF ll_pocet = 0 THEN
		ll_pocet = 1
		ll_selected [1] = This.getRow ()
	END IF
ELSE
	IF This.RowCount () > 0 THEN
		ll_pocet = 1
		ll_selected [1] = This.getRow ()
	END IF
END IF
DELETE FROM idtab WHERE compname = :gnv_app.is_compname;// USING SQLUPD;
SQLCA.of_Chyba (0, 0)
SQLCA.of_Commit ()
SQLCA.of_chyba (0, 0)
FOR ll_i = 1 TO ll_pocet
	ll_a = This.GetItemNumber (ll_selected [ll_i], as_col)
	INSERT INTO idtab (compname, id) VALUES (:gnv_app.is_compname, :ll_a);// USING SQLUPD;
	SQLCA.of_chyba (0, 0)
NEXT
SQLCA.of_Commit ()
SQLCA.of_chyba (0, 0)

end event

event js_nactidddw();//prázdný Event pro načtení hodnot DDDW - voláno z M_DW

end event

event js_nahodretrieve();//Event na opetovne nahozeni teto promenne v RETRIEVEEND - POST
ib_retrieve = TRUE

end event

event js_noedit();//slouží k převedení DW do režimu zakázané editace
//především pokud je DW editovatelné a je modifikovaná SELECT podmínka v Query okně
end event

event js_oznacvse();Long ll_row
IF NOT This.ib_detail THEN
	IF NOT IsValid (This.inv_rowselect) THEN
		IF This.of_SetRowSelect (TRUE) = -1 THEN
			MessageBox ("Info", "Funkce označování více řádků nebyla inicializována.")
		ELSE
			This.inv_rowselect.of_SetStyle (2)
			ll_row = This.GetRow ()
			IF ll_row > 0 THEN
				This.SelectRow (ll_row, TRUE)
			END IF
		END IF
	END IF
	This.SelectRow (0, TRUE)
ELSE
	MessageBox ("Info", "Pro okno typu detail se označování více řádků nepoužívá.")
END IF
end event

event js_rowcount();Long ll_poc

ll_poc = This.RowCount ()
CHOOSE CASE ll_poc
CASE 0
	MessageBox ("Info", "Datové okno neobsahuje žádný záznam.")
CASE 1
	MessageBox ("Info", "Datové okno obsahuje jeden záznam.")
CASE 2,3,4
	MessageBox ("Info", "Datové okno obsahuje celkem " + String (ll_poc) + " záznamy.")
CASE ELSE
	MessageBox ("Info", "Datové okno obsahuje celkem " + String (ll_poc) + " záznamů.")
END CHOOSE


end event

event js_rowselect();Long ll_row
IF NOT This.ib_detail THEN
	IF IsValid (This.inv_rowselect) THEN
		This.Event js_ZrusSelection ()
		IF This.of_SetRowSelect (FALSE) = -1 THEN
			MessageBox ("Info", "Funkce označování více řádků nebyla zrušena.")
		END IF
	ELSE
		IF This.of_SetRowSelect (TRUE) = -1 THEN
			MessageBox ("Info", "Funkce označování více řádků nebyla inicializována.")
		ELSE
			This.inv_rowselect.of_SetStyle (2)
			ll_row = This.GetRow ()
			IF ll_row > 0 THEN
				This.SelectRow (ll_row, TRUE)
			END IF
		END IF
	END IF
ELSE
	MessageBox ("Info", "Pro okno typu detail se označování více řádků nepoužívá.")
END IF
end event

event js_status();dwItemStatus l_status

l_status = This.GetItemStatus (This.GetRow (), 0, Primary!)
CHOOSE CASE l_status
CASE NotModified!
	messagebox("","Not Modified")
CASE DataModified!
	messagebox("","Data Modified")
CASE New!
	messagebox("","New")
CASE NewModified!
	messagebox("","New Modified")
END CHOOSE


end event

event js_zrusselection();//zruší nastavené označení výběru vět
Long		ll_pocet, ll_selected [], ll_i

IF IsValid (This.inv_rowselect) THEN
	ll_pocet = This.inv_rowselect.of_SelectedCount (ll_selected)
	IF ll_pocet > 0 THEN
		SetPointer (HourGlass!)
		FOR ll_i = 1 TO ll_pocet
			This.SelectRow (ll_selected [ll_i], FALSE)
		NEXT
		SetPointer (Arrow!)
	END IF
ELSE
	MessageBox ("Info", "Označování záznamů není aktivní.")
END IF

end event

event clicked;call super::clicked;string ls_col
w_master		ldw_a
m_master		lm_a

IF Not IsNull (dwo) THEN
	ls_col = dwo.name
	IF row > 0 THEN 
		This.SetRow (row)
		This.ScrollToRow (row)
	END IF
	
	IF UPPER (RIGHT (ls_col, 3)) = "_F9" THEN
		This.of_GetParentWindow (ldw_a)
		IF ldw_a.WindowType = Main! THEN   //pouze ty mají příslušnou volbu a menu
			lm_a = ldw_a.MenuID
			ls_col = LEFT (ls_col, LEN (ls_col) - 3)
			This.SetColumn (ls_col)
			lm_a.m_data.m_vybersez.Event Clicked ()
		END IF
	END IF
END IF

RETURN 0
end event

on u_dw.create
call super::create
end on

on u_dw.destroy
call super::destroy
end on

event constructor;call super::constructor;//ib_rmbmenu = FALSE
This.of_SetTransObject (SQLCA)
This.of_SetRowManager (TRUE)

RETURN 0
end event

event dberror;//////////////////////////////////////////////////////////////////////////////
//	Event:			dberror
//	Description:	Display messagebox that a database error has occurred.
// 					If appropriate delay displaying the database error until the appropriate
// 					Rollback has been performed.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
// 					5.0.02 Suppress error messages until after a rollback has been performed
// 					6.0 	Enhanced to use new dberrorattrib to support all error attributes.
// 					6.0	Enhanced to support Transaction Management by other objects
// 					6.0 	Enhanced to send notification to the SqlSpy service.
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
w_master	lw_parent
string	ls_message
String 	ls_title
string	ls_sqlspyheading
string	ls_sqlspymessage
string	ls_msgparm[1]
powerobject lpo_updaterequestor
n_cst_dberrorattrib lnv_dberrorattrib
Integer 	li_odp
Long		ll_cislo
String 	ls_text

itr_object.of_rollback ()
itr_object.of_Chyba (0, 0)

// The error message.
ls_message = "Byla detekována chyba databáze.~r~n~r~n~r~n" + &
	"Kód chyby:  " + String (sqldbcode) + "~r~n~r~n" + &
	"Text chyby:~r~n" + sqlerrtext

// Set the error attributes.
lnv_dberrorattrib.il_sqldbcode = sqldbcode
lnv_dberrorattrib.is_sqlerrtext = sqlerrtext
lnv_dberrorattrib.is_sqlsyntax = sqlsyntax
lnv_dberrorattrib.idwb_buffer = buffer
lnv_dberrorattrib.il_row = row
lnv_dberrorattrib.is_errormsg = ls_message
lnv_dberrorattrib.ipo_inerror = this

// If available trigger the SQLSpy service.
If IsValid(gnv_app.inv_debug) then
	If IsValid(gnv_app.inv_debug.inv_sqlspy) then

		// Create the heading and message for the SQLSpy.
		ls_sqlspyheading = "DBError - " + this.ClassName() + "(" + string(row) + ")"
		ls_sqlspymessage = "Database error code:  " + String (sqldbcode) + "~r~n" + &
			"Database error message:  " + sqlerrtext
		
		// Send the information to the service for processing.
		gnv_app.inv_debug.inv_sqlspy.of_sqlSyntax  &
			(ls_sqlspyheading, "/*** " + ls_sqlspymessage + " ***/")
	end if
end if

// Determine if Transaction Management is being performed by another object.
If IsValid(ipo_UpdateRequestor) then
	lpo_updaterequestor = ipo_UpdateRequestor
else
	// Determine if the window is in the save process. 
	this.of_GetParentWindow(lw_parent)
	If IsValid(lw_parent) then
		If lw_parent.TriggerEvent ("pfc_descendant") = 1 then	
			If lw_parent.of_GetSaveStatus() then
				lpo_updaterequestor = lw_parent
			end if
		end if
	end if
end if

If IsValid(lpo_updaterequestor) then
	// Suppress the error message (let the UpdateRequestor display it).
	// MetaClass check, Dynamic Function Call.
	IF gnv_app.is_jazyk = "C" OR gnv_app.is_jazyk = "S" THEN
//		IF SQLDBCode = -1 AND POS (SQLErrText, "referenced in another table") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Byla signalizována chyba integrity dat.~n~n" + &
//				"Některou větu nelze zrušit neboť se na ní váží informace v jiné tabulce.~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText)
//		ELSEIF SQLDBCode = -1 AND POS (SQLErrText, "is too big") > 0 AND POS (SQLErrText, "Bind parameter") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Některý z parametrů příkazu je větší (delší) než v databázi.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF SQLDBCode = 8152 AND POS (SQLErrText, "would be truncated") > 0 AND POS (SQLErrText, "Bind parameter") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Některý z parametrů příkazu je větší (delší) než je v databázi.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF SQLDBCode = -3 AND POS (SQLErrText, "ow changed between") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Některá z položek má v databázi již změněnou hodnotu.~n~n" + &
//				"Načtěte znovu data do obrazovky pomocí CTRL+R a změnu proveďte znovu.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF SQLDBCode = -1 AND POS (SQLErrText, "37000") > 0 AND POS (SQLErrText, "Lock request time out period exceeded") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Požadovaná operace nemohla být dokončena.~n" + &
//				"Důvodem je blokování zdroje databáze jiným uživatelem.~n~n" + &
//				"Blokování je možno zobrazit v nabídce Soubor-Otevřít-Další volby-Aktivita v databázi.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF SQLDBCode = -1 AND POS (SQLErrText, "Database transaction information not available") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Spojení s databází bylo přerušeno.~n" + &
//				"Proveďte opětovné přihlášení pomocí dvou stisků klávesy F10.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF POS (SQLErrText, "Communication link failure") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Spojení s databází bylo přerušeno.~n" + &
//				"Proveďte opětovné přihlášení pomocí dvou stisků klávesy F10.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF POS (SQLErrText, "Datetime field overflow") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Datum mimo rozsah platnosti.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		END IF
		IF SQLCA.SQLCode = -1 THEN
			IF  POS (SQLCA.SQLErrText, 'referenced in another table') > 0 THEN
				li_odp =  MessageBox("Chyba DB", "Byla signalizována chyba integrity dat.~n~n" + &
					"Některou větu nelze zrušit neboť se na ni váží informace v jiné tabulce.~n" + &
					"Např. inzerce je již zařazena do FP nebo FP do FV.~n~n" + &
					"Kód chyby  : " + String (ll_cislo) + "~n"+ &
					"Popis chyby: " + ls_Text + "~n~nPokračovat v programu ?", StopSign!, YesNo!) 
			ELSEIF POS (SQLCA.SQLErrText, 'not connected') > 0 THEN
			ELSE
				li_odp =  MessageBox("Chyba DB", "Při práci s databází byla signalizována chyba.~n~n" + &
					"Kód chyby  : " + String (ll_cislo) + "~n"+ &
					"Popis chyby: " + ls_Text + "~n~nPokračovat v programu ?", StopSign!, YesNo!) 
			END IF
		ELSE
			li_odp =  MessageBox("Chyba DB", "Při práci s databází byla signalizována chyba.~n~n" + &
				"Kód chyby  : " + String (ll_cislo) + "~n"+ &
				"Popis chyby: " + ls_text + "~n~nPokračovat v programu ?", StopSign!, YesNo!) 
		END IF	
	END IF
	lpo_updaterequestor.Dynamic Function of_SetDBErrorMsg(lnv_dberrorattrib)
else
	// Display the message immediately.
	IF gnv_app.is_jazyk = "C" OR gnv_app.is_jazyk = "S" THEN
//		IF SQLDBCode = -1 AND POS (SQLErrText, "referenced in another table") > 0 THEN
//			MessageBox ("Chyba DB", "Byla signalizována chyba integrity dat.~n~n" + &
//				"Některou větu nelze zrušit neboť se na ní váží informace v jiné tabulce.~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + ".", StopSign!)
//		ELSEIF SQLDBCode = -1 AND POS (SQLErrText, "is too big") > 0 AND POS (SQLErrText, "Bind parameter") > 0 THEN
//			MessageBox ("Chyba DB", "Některý z parametrů příkazu je větší než v databázi.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + ".", StopSign!)
//		ELSEIF SQLDBCode = -3 AND POS (SQLErrText, "ow changed between") > 0 THEN
//			MessageBox ("Chyba DB", "Některá z položek má v databázi již změněnou hodnotu.~n~n" + &
//				"Načtěte znovu data do obrazovky pomocí CTRL+R a změnu proveďte znovu.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + ".", StopSign!)
//		ELSEIF SQLDBCode = 8152 AND POS (SQLErrText, "would be truncated") > 0 THEN
//			MessageBox ("Chyba DB", "Některý z parametrů příkazu je větší (delší) než v databázi.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + ".", StopSign!)
//		ELSEIF SQLDBCode = -1 AND POS (SQLErrText, "37000") > 0 AND POS (SQLErrText, "Lock request time out period exceeded") > 0 THEN
//			MessageBox ("Chyba DB", "Požadovaná operace nemohla být dokončena.~n" + &
//				"Důvodem je blokování zdroje databáze jiným uživatelem.~n~n" + &
//				"Blokování je možno zobrazit v nabídce Soubor-Otevřít-Další volby-Aktivita v databázi.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + ".", StopSign!)
//		ELSEIF SQLDBCode = -1 AND POS (SQLErrText, "Database transaction information not available") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Spojení s databází bylo přerušeno.~n" + &
//				"Proveďte opětovné přihlášení pomocí dvou stisků klávesy F10.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF POS (SQLErrText, "Communication link failure") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Spojení s databází bylo přerušeno.~n" + &
//				"Proveďte opětovné přihlášení pomocí dvou stisků klávesy F10.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSEIF POS (SQLErrText, "Datetime field overflow") > 0 THEN
//			lnv_dberrorattrib.is_errormsg = "Datum mimo rozsah platnosti.~n~n" + &
//				"Kód chyby: " + String (SQLDBCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + "."
//		ELSE
//			MessageBox ("Chyba DB", "Při práci s databází byla signalizována chyba.~n~n" + &
//				"Kód chyby: " + String (SQLdbCode) + ".~n" + &
//				"Popis chyby: " + String (SQLErrText) + ".", StopSign!)
//		END IF		
		IF SQLCA.SQLCode = -1 THEN
			IF  POS (SQLCA.SQLErrText, 'referenced in another table') > 0 THEN
				li_odp =  MessageBox("Chyba DB", "Byla signalizována chyba integrity dat.~n~n" + &
					"Některou větu nelze zrušit neboť se na ni váží informace v jiné tabulce.~n" + &
					"Např. inzerce je již zařazena do FP nebo FP do FV.~n~n" + &
					"Kód chyby  : " + String (ll_cislo) + "~n"+ &
					"Popis chyby: " + ls_Text + "~n~nPokračovat v programu ?", StopSign!, YesNo!) 
			ELSEIF POS (SQLCA.SQLErrText, 'not connected') > 0 THEN
			ELSE
				li_odp =  MessageBox("Chyba DB", "Při práci s databází byla signalizována chyba.~n~n" + &
					"Kód chyby  : " + String (ll_cislo) + "~n"+ &
					"Popis chyby: " + ls_Text + "~n~nPokračovat v programu ?", StopSign!, YesNo!) 
			END IF
		ELSE
			li_odp =  MessageBox("Chyba DB", "Při práci s databází byla signalizována chyba.~n~n" + &
				"Kód chyby  : " + String (ll_cislo) + "~n"+ &
				"Popis chyby: " + ls_text + "~n~nPokračovat v programu ?", StopSign!, YesNo!) 
		END IF	
	ELSE
		If IsValid(gnv_app.inv_error) then
			ls_msgparm[1] = ls_message
			gnv_app.inv_error.of_Message ("pfc_dwdberror", ls_msgparm, &
						gnv_app.iapp_object.DisplayName)
		else
			of_MessageBox ("pfc_dberror", gnv_app.iapp_object.DisplayName, &
				ls_message, StopSign!, Ok!, 1)
		end if
	END IF
end if

ls_message = LEFT (sqlerrtext, 250)
IF Isvalid (lw_parent) THEN
	ls_title = LEFT (lw_parent.Title, 50)
END IF
IF sqldbcode <> 0 THEN
	INSERT INTO dbo.chyby (datum, zkrjm, okno, cislo, text)
		VALUES (current_timestamp, :gnv_app.ii_iduser, :ls_title, :sqldbcode, :ls_message);
	SQLCA.of_Chyba (0, 0)
	SQLCA.of_Commit ()
	SQLCA.of_Chyba (0, 0)
	IF LEN (gnv_app.is_mailerr) > 0 THEN
		ls_title += "~h0D~h0A" + "SQLCode: " + String (sqldbcode) + "~h0D~h0A"
		ls_title += SQLErrText
		mail_send (gnv_app.is_mailerr, gnv_app.iapp_object.DisplayName, ls_title, "")
	END IF
END IF

return 1
end event

event getfocus;call super::getfocus;w_master		lw_a
m_master		lm_a
Integer		li_style

This.of_GetParentWindow (lw_a)
IF lw_a.WindowType = Main! THEN   //pouze ty mají příslušnou volbu a menu
	lm_a = lw_a.MenuID
	IF This.RowCount () > 0 THEN
		//ikona pro Excel
		IF This.ib_excel THEN
			lm_a.m_file.m_save.Enabled = TRUE
		ELSE
			lm_a.m_file.m_save.Enabled = FALSE
		END IF
		//ikona pro export dat
		lm_a.m_file.m_saveas.Enabled = TRUE
	ELSE
		lm_a.m_file.m_saveas.Enabled = FALSE
		lm_a.m_file.m_save.Enabled = FALSE
	END IF
	//ikona pro pocet vet
	IF This.RowCount () > 1 THEN
		lm_a.m_data.m_pocet.Enabled = TRUE
	ELSE
		lm_a.m_data.m_pocet.Enabled = FALSE
	END IF
	//ikony pro editaci vet
	IF This.ib_potlacikony THEN
		lm_a.m_data.m_insertdat.Enabled = FALSE
		lm_a.m_data.m_deletedat.Enabled = FALSE
		lm_a.m_data.m_savedat.Enabled = FALSE
	END IF
	IF ib_retrieve THEN
		This.Event js_zaznamrec ()
		This.Event Pfc_Retrieve ()
		This.Event js_posunrec ()
	END IF
END IF

RETURN 0		
			
end event

event itemerror;call super::itemerror;RETURN 1  //no messageBox

end event

event itemfocuschanged;call super::itemfocuschanged;w_master		ldw_a
m_master		lm_a

IF NOT (LEFT (dwo.name, 4) = "pozn" OR dwo.name = "zmeny" OR &
	dwo.name = "upozorneni" OR dwo.name = "protokol" OR &
	dwo.name = "txtpred" OR dwo.name = "tisk") THEN
	This.Event Pfc_SelectAll ()
END IF

//nastaveni odlišné velikosti fontu pro datumové pole - hlavně NT
IF gnv_app.ii_font < 10 AND gnv_app.ii_font > 6 THEN
	IF dwo.format = "dd.mm.yyyy" OR dwo.EditMask.Mask = "dd.mm.yyyy" THEN
		dwo.Font.Height = - gnv_app.ii_font
	END IF
END IF

RETURN 0
end event

event itemchanged;call super::itemchanged;Date ld_a
String ls_a

IF dwo.format = "dd.mm.yyyy" OR dwo.EditMask.Mask = "dd.mm.yyyy" THEN
	ls_a = LEFT (data, 10)
	IF IsDate (ls_a) THEN
		ld_a = Date (ls_a)
		IF ld_a > Date ("2079-01-01") THEN
			MessageBox ("Pozor", "Zadaný datum '" + String (ld_a, "dd.mm.yyyy") + &
				"' je mimo rozsah platnosti databáze.", Exclamation!)
		END IF
		IF ld_a < Date ("1900-01-01") THEN
			MessageBox ("Pozor", "Zadaný datum '" + String (ld_a, "dd.mm.yyyy") + &
				"' je mimo rozsah platnosti databáze.", Exclamation!)
		END IF
	END IF
END IF

end event

event losefocus;call super::losefocus;w_master		ldw_a
m_master		lm_a

This.of_GetParentWindow (ldw_a)
IF ldw_a.WindowType = Main! THEN   //pouze ty mají příslušnou volbu a menu
	lm_a = ldw_a.MenuID
	IF This.ib_potlacikony THEN
		lm_a.m_data.m_insertdat.Enabled = TRUE
		lm_a.m_data.m_deletedat.Enabled = TRUE
		lm_a.m_data.m_savedat.Enabled = TRUE
	END IF
END IF

This.AcceptText ()

RETURN 0
end event

event pfc_deleterow;//////////////////////////////////////////////////////////////////////////////
//	Event:			pfc_deleterow
//	Arguments:		None
//	Returns:			Integer
//	 					1 = success
//  					0 = Row not deleted
//						-1 = error
//	Description:	Deletes the current or selected row(s)
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
// 					6.0 	Enhanced with PreDelete process.
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
integer	li_rc, li_return
long		ll_row, ll_pocet, ll_selected []
w_sheet	ldw_sheet, lw_opensheets[ ]
string 	ls_tag
Boolean	lb_retreive

// Perform Pre Delete process.
if this.Event pfc_predeleterow() <= PREVENT_ACTION then return NO_ACTION

lb_retreive = ib_retrieve
IF This.ib_retrieve THEN This.ib_retrieve = FALSE

//jmeno hlavního okna
li_rc = This.of_GetParentWindow (ldw_sheet)

// Delete row.
IF IsValid (inv_rowselect) THEN  //rušení více vět
	ll_pocet = This.inv_rowselect.of_SelectedCount (ll_selected)
	IF ll_pocet > 0 THEN
		IF MessageBox ("Dotaz", "Skutečně zrušit " + String (ll_pocet) + &
				" označených vět ?", Question!, YesNo!, 2) = 1 THEN
			li_rc = inv_rowmanager.of_DeleteSelected ()
		END IF
	ELSE
		ll_pocet = This.getRow ()
		This.SelectRow (0, FALSE)
		This.SelectRow (ll_pocet, TRUE)
		IF MessageBox ("Dotaz", "Skutečně zrušit tuto označenou větu ?", Question!, YesNo!, 2) = 1 THEN
			li_rc = This.DeleteRow (0)
		END IF
	END IF
ELSE
	IF ib_detail THEN
		IF li_rc = 1 THEN
			li_rc = MessageBox ("Dotaz", "Skutečně zrušit tuto větu ?~n~n" + &
				ldw_sheet.title, Question!, YesNo!, 2)
		ELSE
			li_rc = MessageBox ("Dotaz", "Skutečně zrušit tuto větu ?", Question!, YesNo!, 2)
		END IF
	ELSE
		ll_pocet = This.GetRow ()
		This.SelectRow (0, FALSE)
		This.SelectRow (ll_pocet, TRUE)
		li_rc = MessageBox ("Dotaz", "Skutečně zrušit tuto označenou větu ?", Question!, YesNo!, 2)
		IF This.GetRow () <> ll_pocet THEN
			This.ScrollToRow (ll_pocet)
		END IF
	END IF
	IF li_rc = 1 THEN
		if IsValid (inv_RowManager) then //tohle je originál
			li_rc = inv_RowManager.event pfc_deleterow () 
		else	
			li_rc = this.DeleteRow (0) 
		end if									//až sem
	ELSE
		li_rc = 0
	END IF
END IF

if li_rc > 0 then ll_row = 0 else ll_row = -1

//	Note: The deletion of multiple master rows is not supported by the linkage service.
if IsValid ( inv_Linkage ) then inv_Linkage.Event pfc_deleterow (ll_row) 

IF li_rc > 0 THEN   		//bylo rušení a udělám i COMMIT
	li_rc = This.Event Pfc_Update (TRUE, TRUE)
	IF li_rc = 1 THEN
		itr_object.of_Commit ()
		itr_object.of_chyba (0, 0)
		IF ib_closewin THEN
			ls_tag = ldw_sheet.tag 
			IF Right (ls_tag, 6) = "detail" THEN
				ls_tag = LEFT (ls_tag, LEN (ls_tag) - 6) + "prehled"
				IF ldw_sheet.is_volanoz = ls_tag THEN
					li_return = w_frame.inv_sheetmanager.of_GetSheetsByClass &
								(lw_opensheets, ls_tag)
					IF li_return = 1 THEN
						IF IsValid (lw_opensheets [1]) THEN
							lw_opensheets [1].Dynamic Event js_vybrat ()
						END IF
					END IF
				END IF
			END IF
			MessageBox ("Info", "Položka byla zrušena.")
			ldw_sheet.Post Event Pfc_Close ()
		ELSE
			is_veta = ""
			This.Event Pfc_Retrieve ()
		END IF
	ELSE
		itr_object.of_Rollback ()
		itr_object.of_chyba (0, 0)
		MessageBox ("Chyba", "Rušení nebylo provedeno.", Exclamation!)
	END IF
ELSE
	itr_object.of_Rollback ()
	itr_object.of_chyba (0, 0)
	li_rc = 1
END IF

ib_retrieve = lb_retreive

return li_rc
end event

event pfc_postinsertrow;call super::pfc_postinsertrow;//naplnění numerických polozek na 0 a znakových na ""
Long		ll_i, ll_poc
DateTime	ldt_a
String 	ls_coltype, ls_colname, ls_a

ll_poc = Long (This.Object.DataWindow.Column.Count)
FOR ll_i = 1 TO ll_poc
	ls_colname = This.Describe("#" + String (ll_i) + ".Name")
	ls_a = UPPER (ls_colname)
	ls_coltype = This.Describe (ls_colname + ".ColType")
	CHOOSE CASE UPPER (LEFT (ls_coltype, 3))
	CASE "CHA"
		This.SetItem (al_row, ll_i, "")
	CASE "INT", "DEC", "LON", "NUM", "REA", "ULO"
		IF ls_a = "ZKRJMV" OR ls_a = "ZKRJM" THEN
			This.SetItem (al_row, ll_i, gnv_app.ii_iduser)
		ELSE
			This.SetItem (al_row, ll_i, 0)
		END IF
	CASE ELSE
		IF ls_a = "DATUMV" OR ls_a = "DATUM" THEN
			ldt_a = DateTime (Today (), Now ())
			This.SetItem (al_row, ll_i, ldt_a)
		END IF
	END CHOOSE
NEXT

end event

event pfc_predeleterow;call super::pfc_predeleterow;IF This.of_IsUpdateAble () = FALSE THEN
	RETURN PREVENT_ACTION
END IF

RETURN CONTINUE_ACTION


end event

event pfc_update;//////////////////////////////////////////////////////////////////////////////
//	Event:  			pfc_update
//	Arguments:		ab_accepttext:	When applicable, specifying whether control should perform an
//											AcceptText prior to performing the update:
//						ab_resetflag:	Value specifying whether object should automatically 
//											reset its update flags.
//	Returns:			Integer
//	 					1 = The update was successful
//						-1 = The update failed
//	Description:	Specific Update logic.  Either perform a regular single dw
//						update or a Multiple table update.
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
// 					6.0 	Enhanced to include PreUpdate event.
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
integer	li_rc

// Verify passed arguments.
if IsNull(ab_accepttext) or IsNull(ab_resetflag) then return -1 

// Call for PreUpdate functionality.
if this.Event pfc_PreUpdate() < 0 then return -1

//zapamatovat si větu
This.Event js_ZaznamRec ()
// Call the multi-table update if applicable.
if IsValid (inv_MultiTable) then 
	li_rc = inv_MultiTable.of_Update (ab_accepttext, ab_resetflag)
else
	li_rc = this.Update(ab_accepttext, ab_resetflag)
end if

IF li_rc = 1 THEN
	itr_object.of_Commit ()
	itr_object.of_Chyba (0, 0)
	This.Event Pfc_Retrieve ()
	This.Event js_PosunRec ()
ELSE
	itr_object.of_Rollback ()
	itr_object.of_chyba (0, 0)
	MessageBox ("Chyba", "Aktualizace dat nebyla provedena.", Exclamation!)
END IF

return li_rc
end event

event rbuttonup;call super::rbuttonup;//////////////////////////////////////////////////////////////////////////////
//	Event:  			rbuttonup
//	Description:	Popup menu
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
//						5.0.04 Modified script to avoid 64K segment problem with 16bit machine code executables
// 					6.0	Added DataWindow Property to the popup menu.
// 					6.0 	Added check for the new RowManager.of_GetRestoreRow() switch.
// 					6.0.01 Added call to pfc_prermbmenuproperty to isolate calls to shared variable.
// 					6.0.01 Corrected so that dwo.protect works properly for protect expressions.
//  povolil jsem INSERT i pro počet vet = 0 a zrusil položku pro RESTOREROW
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
boolean		lb_frame
boolean		lb_desired
boolean		lb_readonly
boolean		lb_editstyleattrib
integer		li_tabsequence
long			ll_getrow
string		ls_editstyle
string		ls_val
string		ls_protect
string		ls_colname
string		ls_currcolname
string		ls_type
string		ls_expression
n_cst_conversion	lnv_conversion
m_dw					lm_dw
window				lw_parent
window				lw_frame
window				lw_sheet
window				lw_childparent

// Determine if RMB popup menu should occur
if not ib_RMBmenu or IsNull (dwo) then	return 1

// No RMB support for OLE objects and graphs
ls_type = dwo.Type
if ls_type = "ole" or ls_type = "tableblob" or ls_type = "graph" then return 1

// No RMB support for print preview mode
if this.Object.DataWindow.Print.Preview = "yes" then return 1

// Determine parent window for PointerX, PointerY offset
this.of_GetParentWindow (lw_parent)
if IsValid (lw_parent) then
	// Get the MDI frame window if available
	lw_frame = lw_parent
	do while IsValid (lw_frame)
		if lw_frame.windowtype = MDI! or lw_frame.windowtype = MDIHelp! then
			lb_frame = true
			exit
		else
			lw_frame = lw_frame.ParentWindow()
		end if
	loop
	
	if lb_frame then
		// If MDI frame window is available, use it as the reference point for the
		// popup menu for sheets (windows opened with OpenSheet function) or child windows
		if lw_parent.windowtype = Child! then
			lw_parent = lw_frame
		else
			lw_sheet = lw_frame.GetFirstSheet()
			if IsValid (lw_sheet) then
				do
					// Use frame reference for popup menu if the parentwindow is a sheet
					if lw_sheet = lw_parent then
						lw_parent = lw_frame
						exit
					end if
					lw_sheet = lw_frame.GetNextSheet (lw_sheet)
				loop until IsNull(lw_sheet) Or not IsValid (lw_sheet)
			end if
		end if
	else
		// SDI application.  All windows except for child windows will use the parent
		// window of the control as the reference point for the popmenu
		if lw_parent.windowtype = Child! then
			lw_childparent = lw_parent.ParentWindow()
			if IsValid (lw_childparent) then
				lw_parent = lw_childparent
			end if
		end if
	end if
else
	return 1
end if

// Create popup menu
lm_dw = create m_dw
lm_dw.of_SetParent (this)

//////////////////////////////////////////////////////////////////////////////
// Main popup menu operations
//////////////////////////////////////////////////////////////////////////////
ll_getrow = this.GetRow()

ls_val = this.Object.DataWindow.ReadOnly
lb_readonly = lnv_conversion.of_Boolean (ls_val)

choose case ls_type
	case "datawindow", "column", "compute", "text", "report", &
		"bitmap", "line", "ellipse", "rectangle", "roundrectangle"

		// Row operations based on readonly status
		lm_dw.m_table.m_insert.Enabled = not lb_readonly
		lm_dw.m_table.m_addrow.Enabled = not lb_readonly
		lm_dw.m_table.m_delete.Enabled = not lb_readonly

		// Menu item enablement for current row
		if not lb_readonly then
			lb_desired = False
			if ll_getrow > 0 then lb_desired = true
			lm_dw.m_table.m_delete.Enabled = lb_desired
			lm_dw.m_table.m_insert.Enabled = TRUE  //jsal
		end if
		
		IF POS (This.dataobject, "vyber") > 1 OR ib_potlacikony THEN   //JSAL
			lm_dw.m_table.m_insert.Enabled = FALSE
			lm_dw.m_table.m_delete.Enabled = FALSE
		END IF
		
	case else
		lm_dw.m_table.m_insert.Enabled = false
		lm_dw.m_table.m_delete.Enabled = false
		lm_dw.m_table.m_addrow.Enabled = false
end choose

// Get column properties
ls_currcolname = this.GetColumnName()
if ls_type = "column" then
	ls_editstyle = dwo.Edit.Style
	ls_colname = dwo.Name
	ls_protect = dwo.Protect
	if not IsNumber(ls_protect) then
		// Since it is not a number, it must be an expression.
		ls_expression = Right(ls_protect, Len(ls_protect) - Pos(ls_protect, "~t"))
		ls_expression = "Evaluate(~""+ls_expression+","+String(row)+")"
		ls_protect = this.Describe(ls_expression)
	end if
	ls_val = dwo.TabSequence
	if IsNumber (ls_val) then
		li_tabsequence = Integer (ls_val)
	end if
end if

//////////////////////////////////////////////////////////////////////////////
// Transfer operations.  Only enable for editable column edit styles
//////////////////////////////////////////////////////////////////////////////
lm_dw.m_table.m_copy.Enabled = false
lm_dw.m_table.m_cut.Enabled = false
lm_dw.m_table.m_paste.Enabled = false
lm_dw.m_table.m_selectall.Enabled = false

// Get the column/editystyle specific editable flag.
if ls_type = "column" and not lb_readonly then
	choose case ls_editstyle
		case "edit"
			ls_val = dwo.Edit.DisplayOnly
		case "editmask"
			ls_val = dwo.EditMask.Readonly
		case "ddlb"
			ls_val = dwo.DDLB.AllowEdit
		case "dddw"
			ls_val = dwo.DDDW.AllowEdit
		case else
			ls_val = ""
	end choose
	lb_editstyleattrib = lnv_conversion.of_Boolean (ls_val)
	if IsNull(lb_editstyleattrib) then lb_editstyleattrib = false
end if

if ls_type = "column" and not lb_readonly then
	if dwo.BitmapName = "no" and ls_editstyle <> "checkbox" and ls_editstyle <> "radiobuttons" then
		
		if Len (this.SelectedText()) > 0 and ll_getrow = row and ls_currcolname = ls_colname then
			// Copy
			lm_dw.m_table.m_copy.Enabled = true

			// Cut
			if li_tabsequence > 0 and ls_protect = "0" then
				lb_desired = false
				choose case ls_editstyle
					case "edit", "editmask"
						lb_desired = not lb_editstyleattrib
					case "ddlb", "dddw"
						lb_desired = lb_editstyleattrib
				end choose
				lm_dw.m_table.m_cut.Enabled = lb_desired
			end if
		end if
			
		if li_tabsequence > 0 and ls_protect = "0" then
			// Paste
			if Len (ClipBoard()) > 0 then
				lb_desired = false
				choose case ls_editstyle
					case "edit", "editmask"
						lb_desired = not lb_editstyleattrib
					case "ddlb", "dddw"
						lb_desired = lb_editstyleattrib
				end choose
				lm_dw.m_table.m_paste.Enabled = lb_desired
			end if

			// Select All
			if Len (this.GetText()) > 0 and ll_getrow = row and ls_currcolname = ls_colname then
				choose case ls_editstyle
					case "ddlb", "dddw"
						lb_desired = lb_editstyleattrib						
					case else
						lb_desired = true
				end choose
				lm_dw.m_table.m_selectall.Enabled = lb_desired				
			end if
		end if

	end if
end if

//////////////////////////////////////////////////////////////////////////////
// Services
//////////////////////////////////////////////////////////////////////////////
// Row Manager
if IsValid (inv_RowManager) AND FALSE then  //JSAL
	// Undelete capability
	if inv_RowManager.of_IsRestoreRow() then
		lm_dw.m_table.m_restorerow.Visible = true
		if this.DeletedCount() > 0 and not lb_readonly then
			lm_dw.m_table.m_restorerow.Enabled = true
		else
			lm_dw.m_table.m_restorerow.Enabled = false
		end if
	end if
else
	lm_dw.m_table.m_restorerow.Visible = false
	lm_dw.m_table.m_restorerow.Enabled = false
end if

//třídění záznamů
IF IsValid (This.inv_sort) THEN
	lm_dw.m_table.m_sort.Enabled = true
ELSE
	lm_dw.m_table.m_sort.Enabled = false
END IF

//výběr záznamů
IF IsValid (This.inv_filter) THEN
	lm_dw.m_table.m_filter.Enabled = true
ELSE
	lm_dw.m_table.m_filter.Enabled = false
END IF

//rowselection
IF IsValid (This.inv_rowselect) THEN
	lm_dw.m_table.m_invertselection.Enabled = true
	lm_dw.m_table.m_zrusselection.Enabled = true
ELSE
	lm_dw.m_table.m_invertselection.Enabled = false
	lm_dw.m_table.m_zrusselection.Enabled = false
END IF
IF This.ib_detail THEN
	lm_dw.m_table.m_rowselection.Enabled = false
	lm_dw.m_table.m_invertselection.Enabled = false
	lm_dw.m_table.m_zrusselection.Enabled = false
END IF	

// QueryMode
// Default to false
lm_dw.m_table.m_operators.Visible = false
lm_dw.m_table.m_operators.Enabled = false
lm_dw.m_table.m_values.Visible = false
lm_dw.m_table.m_values.Enabled = false
lm_dw.m_table.m_dash12.Visible = false

if IsValid (inv_QueryMode) then
	if inv_QueryMode.of_GetEnabled() then
		// Do not allow undelete while in querymode
		lm_dw.m_table.m_restorerow.Visible = false
		lm_dw.m_table.m_restorerow.Enabled = false		

		// Default visible to true if in querymode
		lm_dw.m_table.m_values.Visible = true
		lm_dw.m_table.m_operators.Visible = true
		lm_dw.m_table.m_dash12.Visible = true

		if ls_type = "column" and not lb_readonly then
			if dwo.bitmapname = "no" and ls_editstyle <> "checkbox" and ls_editstyle <> "radiobuttons" then
				if li_tabsequence > 0 and ls_protect = "0" then				
					lb_desired = false
					choose case ls_editstyle
						case "edit", "editmask"
							lb_desired = not lb_editstyleattrib
						case "ddlb", "dddw"
							lb_desired = lb_editstyleattrib
					end choose
					// Enablement based on column				
					lm_dw.m_table.m_values.Enabled = lb_desired
					lm_dw.m_table.m_operators.Enabled = lb_desired
				end if
			end if
		end if
	end if
end if

// DataWindow property entries. (isolate calls to shared variable)
this.event pfc_prermbmenuproperty (lm_dw)

// Allow for any other changes to the popup menu before it opens
this.event pfc_prermbmenu (lm_dw)

// Send rbuttonup notification to row selection service
if IsValid (inv_RowSelect) then inv_RowSelect.event pfc_rbuttonup (xpos, ypos, row, dwo)

// Popup menu
lm_dw.m_table.PopMenu (lw_parent.PointerX() + 5, lw_parent.PointerY() + 10)

destroy lm_dw

return 1
end event

event retrieveend;Long ll_row
w_master		lw_a

IF ib_retrieve THEN
	ib_Retrieve = FALSE
	This.Event Post js_nahodretrieve ()
END IF
//je-li neupdatovatelny GRID
ll_row = This.RowCount ()
This.of_GetParentWindow (lw_a)
IF lw_a.of_GetCloseStatus () = FALSE THEN
	IF ll_row > 0 THEN
		IF This.of_IsUpdateAble () = FALSE THEN
			//tohle mi pada pri nejake podmince na zavreni okna
			IF Integer (This.Object.DataWindow.Processing) = 1 THEN
				IF NOT IsValid (This.inv_rowselect) THEN
					This.Event js_rowSelect ()
				ELSE
					ll_row = This.GetRow ()
					IF ll_row > 0 THEN This.SelectRow (ll_row, TRUE)
				END IF
			END IF
		END IF
	END IF
	This.Event GetFocus ()
END IF

RETURN 0

end event

event updateend;call super::updateend;itr_object.of_Commit ()
itr_object.of_Chyba (0, 0)

end event

