$PBExportHeader$n_cst_appmanager.sru
$PBExportComments$Extension Application Manager service
forward
global type n_cst_appmanager from pfc_n_cst_appmanager
end type
end forward

global type n_cst_appmanager from pfc_n_cst_appmanager
end type
global n_cst_appmanager n_cst_appmanager

type variables
//tohle je obecné
n_cst_filesrvwin32 inv_filesrv
n_cst_platformwin32 inv_platform
n_cst_string inv_string
boolean ib_prihl = FALSE, ib_SQLERR = TRUE
String is_jazyk, is_mailerr, is_compname, is_rokexcel, is_email_zpusob = "O", is_patamail
integer ii_iduser, ii_script, ii_font, ii_zoom = 75


end variables

forward prototypes
public subroutine js_paramuser (string as_user)
end prototypes

public subroutine js_paramuser (string as_user);String ls_a
Long ll_poc

SELECT Count (*) INTO :ll_poc FROM dbo.parametry;
IF SQLCA.of_Chyba (0, 0) <> 0 THEN 
	MessageBox ("Chyba", "Program není připojen k převáděné databázi.", StopSign!)
	HALT
END IF

w_frame.Title = "Převod dat WinZis - " + as_user

end subroutine

on n_cst_appmanager.create
call super::create
end on

on n_cst_appmanager.destroy
call super::destroy
end on

event constructor;call super::constructor;/*  Set the Name of the application  */
iapp_object.DisplayName = "Převod"

/*  Set Microhelp Functionality  */
of_SetMicroHelp ( True )

/*  Set the name of the application INI file  */
of_SetAppIniFile ( "prevod.ini" )

/*  Set the name of the User INI file  */
of_SetUserIniFile ( "user.ini" )

/*  Set the Application registry key  */
//of_SetAppKey ( "HKEY_LOCAL_MACHINE\Software\<Your Company Name>\<ApplicationName>" )

/*  Set the User registry key  */
//of_SetUserKey ( "HKEY_CURRENT_USER\Software\<Your Company Name>\<ApplicationName>")

/*  Set the application's online help file  */
of_SetHelpFile ( "prevod.hlp" )

/*  Set the application version  */
of_SetVersion ( "Verze programu 1.0" )

/*  Set The application logo (bitmap file name)  */
of_SetLogo ( "prodata.bmp" )

/*  Set the Application copyright message  */
of_SetCopyright ( "Copyright © 2022 Prodata Praha s.r.o. Veškerá práva vyhrazena." )


end event

event pfc_close;call super::pfc_close;/*  Disconnect from the database  */
SQLCA.of_DisConnect ( )
SQLZIS.of_DisConnect ( )

end event

event pfc_logon;call super::pfc_logon;/*  Perform databse logon  */
Time lt_a
String ls_a
n_ds lds_a
Long ll_poc

SQLCA.of_SetUser ( as_userid, as_password )

If SQLCA.of_Connect ( ) < 0 Then Return FAILURE

Return SUCCESS


end event

event pfc_open;call super::pfc_open;String ls_userid, ls_userini, ls_password, ls_a, ls_b, ls_asa
Integer li_handle, li_i

f_setFileSrv (inv_filesrv, TRUE)
as_commandline = TRIM (as_commandline)
IF as_commandline <> "" THEN
	of_SetAppIniFile (as_commandline + "\prevod.ini")
END IF
IF NOT FileExists (of_GetAppIniFile ()) THEN
	MessageBox (iapp_object.DisplayName, "Nenalezen PREVOD.INI soubor.~n~n" + &
		This.of_GetAppIniFile () + "~n~nProgram bude ukončen.", StopSign!)
	HALT CLOSE
END IF

IF SQLCA.of_Init (is_appinifile, "Database" ) = -1 Then
	MessageBox (iapp_object.DisplayName, "Initialization failed from file " + is_appinifile )
	Halt
End If

Open (w_frame)
ls_userini = of_GetappIniFile ()
ls_a = UPPER (ProfileString (ls_userini, "database", "dbparm", ""))
ls_userini = of_GetUserIniFile ()
f_SetPlatform (inv_platform, TRUE)
ls_userid = "prevod"
ls_password = "prevod"
SQLCA.of_SetUser (ls_userid, ls_password)
if upper (SQLCA.DBMS) = "OLE DB" then // pro OLE DB musím (na rozdíl od ODBC) nastavit LogId a LogPass
	SQLCA.LogPass = ls_password
	SQLCA.LogId = ls_userid
end if
IF this.Event pfc_logon (ls_userid, ls_password) = 1 THEN
	IF ls_userid <> "" AND IsValid (w_frame) THEN
		ls_userini = of_GetappIniFile ()
		//zobrazení jména DSN v připojení
		ls_a = ProfileString (ls_userini, "database", "dbparm", "")
		li_i = POS (UPPER (ls_a), "DSN=")
		IF li_i > 0 THEN
			ls_a = MID (ls_a, li_i + 4)
			ls_a = LEFT (ls_a, LEN (ls_a) - 1)
			ls_asa = ls_a
		END IF
		ls_a = ProfileString (ls_userini, "param", "userini", "")
		IF ls_a <> "" THEN
			of_SetUserIniFile (ls_a + "\" + ls_userid + ".ini")
		ELSE
			of_SetUserIniFile (ls_userid + ".ini")
		END IF
		ls_userini = of_GetUserIniFile ()
		IF Not FileExists (ls_userini) THEN
			li_handle = FileOpen (ls_userini, LineMode!, Write!)
			FileClose (li_handle)
		END IF
		js_paramuser (ls_userid)
	END IF
	f_setFileSrv (inv_filesrv, FALSE)
	//zjisteni ODBC na databázi MS SQL
	ib_prihl = TRUE
	SQLZIS = CREATE n_tr
	ls_userini = of_GetappIniFile ()
	SQLZIS.of_init (ls_userini, "mssql") 
	This.of_SetUserID ("prevod")
	SQLZIS.of_SetUser ("prevod", "prevod")
	if upper (SQLZIS.DBMS) = "OLE DB" then // pro OLE DB musím (na rozdíl od ODBC) nastavit LogId a LogPass
		SQLZIS.LogPass = ls_password
		SQLZIS.LogId = ls_userid
	end if
	IF SQLZIS.of_Connect() >= 0 THEN 
		//napojeni O.K.
	ELSE
		MessageBox("Chyba","Napojení na databázi MS SQL nebylo provedeno.", Exclamation!)
		HALT
	END IF
	ls_a = ProfileString (ls_userini, "mssql", "dbparm", "")
	li_i = POS (UPPER (ls_a), "DSN=")
	IF li_i > 0 THEN
		ls_a = MID (ls_a, li_i + 4)
		ls_a = LEFT (ls_a, LEN (ls_a) - 1)
		SELECT current_user into :ls_b from parametry USING SQLZIS;
		sqlzis.of_Chyba (0, 0)
		w_frame.Title = "Převod dat WinZis MS SQL " + ls_asa + " -> " + ls_a + " (" + ls_b + ")"
	END IF
	m_frame.m_file.m_open.m_vysetr.Event Clicked ()
ELSE
	MessageBox ("Chyba", "Chyba napojení na převáděnou databázi.", StopSign!)
	halt
END IF
end event

event pfc_prelogondlg;call super::pfc_prelogondlg;/*  Give the user 3 attempts to logon  */
anv_logonattrib.ii_logonattempts = 3
end event

