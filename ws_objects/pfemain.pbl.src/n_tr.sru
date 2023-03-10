$PBExportHeader$n_tr.sru
$PBExportComments$Extension Transaction class
forward
global type n_tr from pfc_n_tr
end type
end forward

global type n_tr from pfc_n_tr
end type
global n_tr n_tr

forward prototypes
public function integer of_execsql (string as_sqlstatement)
public function integer of_chyba (integer ai_kod1, integer ai_kod2)
end prototypes

public function integer of_execsql (string as_sqlstatement);//////////////////////////////////////////////////////////////////////////////
//	Public Function:  of_ExecSQL
//	Arguments:		as_sqlstatement:  the SQL statement to execute
//	Returns:			long - the SQLCode value after the SQL is executed
//								 -10	if there is no connection to the database.
//	Description:	Executes specified SQL
//////////////////////////////////////////////////////////////////////////////
//	Rev. History	Version
//						5.0   Initial version
//////////////////////////////////////////////////////////////////////////////
//	Copyright © 1996-1999 Sybase, Inc. and its subsidiaries.  All rights reserved.  Any distribution of the 
// PowerBuilder Foundation Classes (PFC) source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//////////////////////////////////////////////////////////////////////////////
//rozsireni of_Execute o kontrolu chyby
long	ll_rc = -10
string	ls_name

if of_IsConnected() then
	
	// If SQLSpy is available, add to the history
	if IsValid (gnv_app) then
		if IsValid (gnv_app.inv_debug) then
			if IsValid (gnv_app.inv_debug.inv_sqlspy) then
				ls_name = this.is_Name
				if Len (ls_name) = 0 then
					ls_name = this.ClassName()
				end if
				// Note:  as_sqlstatement is passed by reference
				gnv_app.inv_debug.inv_sqlspy.of_SQLSyntax &
					("Dynamic SQL using " + ls_name, as_SQLStatement, true)
			end if 
		end if
	end if
	
	execute immediate :as_SQLStatement using this;
	This.of_Chyba (0, 0)
	ll_rc = this.SQLCode
	
end if

return ll_rc
end function

public function integer of_chyba (integer ai_kod1, integer ai_kod2);window 	activesheet
String 	ls_title, ls_text, ls_a
Integer 	li_odp
Long 		ll_cislo

IF NOT gnv_app.ib_prihl THEN RETURN This.SQLCode

IF This.SQLCode = 0 THEN RETURN 0

IF This.SQLCode = ai_kod1 THEN RETURN This.SQLCode

IF This.SQLCode = ai_kod2 THEN RETURN This.SQLCode

IF This.SQLCode = 100 THEN
	MessageBox ("Upozornění", "Hledaná položka nebyla v databázi nalezena.")
	RETURN 100
END IF

ll_cislo = This.SQLCode
ls_text = LEFT (This.SQLErrText, 250)
ls_title = LEFT (ls_title, 50)

//SQL Server
//IF POS (ls_Text, "referenced in another table") > 0 THEN
//	li_odp = MessageBox ("Chyba DB", "Byla signalizována chyba integrity dat.~n~n" + &
//		"Některou větu nelze zrušit neboť se na ní váží informace v jiné tabulce.~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//ELSEIF POS (ls_Text, "is too big") > 0 AND POS (ls_Text, "Bind parameter") > 0 THEN
//	li_odp = MessageBox ("Chyba DB", "Některý z parametrů příkazu je větší (delší) než v databázi.~n~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//ELSEIF ll_cislo = -3 AND POS (ls_Text, "ow changed between") > 0 THEN
//	li_odp = MessageBox ("Chyba DB", "Některá z položek má v databázi již změněnou hodnotu.~n~n" + &
//		"Načtěte znovu data do obrazovky pomocí CTRL+R a změnu proveďte znovu.~n~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//ELSEIF ll_cislo = 8152 AND POS (ls_Text, "would be truncated") > 0 THEN
//	li_odp = MessageBox ("Chyba DB", "Některý z parametrů příkazu je větší (delší) než v databázi.~n~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//ELSEIF POS (ls_Text, "37000") > 0 AND POS (ls_Text, "Lock request time out period exceeded") > 0 THEN
//	li_odp = MessageBox ("Chyba DB", "Požadovaná operace nemohla být dokončena.~n" + &
//		"Důvodem je blokování zdroje databáze jiným uživatelem.~n~n" + &
//		"Blokování je možno zobrazit v nabídce Soubor-Otevřít-Další volby-Aktivita v databázi.~n~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//ELSEIF POS (ls_Text, "Communication link failure") > 0 OR &
//		POS (ls_Text, "Invalid descriptor index") > 0	OR & 
//		POS (ls_Text, "Neplatný index deskriptoru") > 0	OR & 
//		POS (ls_text, "Database transaction information not available") > 0 OR & 
//		POS (ls_Text, "Komunikační propojení selhalo") > 0 THEN
//	MessageBox ("Chyba DB", "Spojení s databází bylo přerušeno.~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//	HALT
//ELSEIF POS (ls_text, "Datetime field overflow") > 0 THEN
//	li_odp = MessageBox ("Chyba DB", "Datum mimo rozsah platnosti.~n~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//ELSE
//	li_odp = MessageBox ("Chyba DB", "Při práci s databází byla signalizována chyba.~n~n" + &
//		"Kód chyby: " + String (ll_cislo) + ".~n" + &
//		"Popis chyby: " + String (ls_Text) + ".~n~n" + &
//		"Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion () + &
//		".~n~nPokračovat v programu ?", StopSign!, YesNo!)
//END IF		

//pro pretah vysetreni
IF NOT gnv_app.ib_sqlerr THEN RETURN lL_cislo

This.of_Rollback ()

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

activesheet = w_frame.getActiveSheet ()

IF IsValid (activesheet) THEN
	ls_title = activesheet.title
ELSE
	ls_title = "Neurčeno"
END IF


IF ll_cislo <> 0 THEN
	ls_a = TRIM (LEFT (gnv_app.of_getUserID (), 20))
	INSERT INTO dbo.chyby (datum, zkrjm, okno, cislo, chyba)
		VALUES (current_timestamp, :ls_a, :ls_title, :ll_cislo, :ls_text);
	This.of_Commit ()
	
	IF LEN (gnv_app.is_mailerr) > 0 THEN
		ls_title += "~h0D~h0A" + "SQLCode: " + String (ll_cislo) + "~h0D~h0A"
		ls_title += ls_Text
		ls_title += "~n~n" + "Verze databáze " + String (gnv_app.ii_script) + " " + gnv_app.of_GetVersion ()
		mail_send (gnv_app.is_mailerr, gnv_app.iapp_object.DisplayName, ls_title, "")
	END IF
END IF

IF li_odp = 2 THEN 
	HALT
END IF

RETURN ll_cislo
end function

on n_tr.create
call super::create
end on

on n_tr.destroy
call super::destroy
end on

