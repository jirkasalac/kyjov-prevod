$PBExportHeader$w_sheet.srw
$PBExportComments$Extension Sheet Window class
forward
global type w_sheet from pfc_w_sheet
end type
end forward

global type w_sheet from pfc_w_sheet
integer x = 214
integer y = 221
event type integer js_resetdata ( powerobject apo_control[] )
end type
global w_sheet w_sheet

type variables
String 	is_volanoz
w_sheet 	iw_volanoz
boolean ib_editace = TRUE
boolean ib_ruseni = TRUE

end variables

forward prototypes
public function boolean js_zmeny ()
public subroutine js_resetdw ()
end prototypes

public function boolean js_zmeny ();//funkce zjistí, zda jsou v tomto okně neuložené změny
//pokud ano dá mu FOCUS
GraphicObject which_control
u_dw ldw_a

which_control = GetFocus( ) 

IF NOT IsNull(which_control) THEN
	IF TypeOf(which_control) = DataWindow! THEN
		ldw_a = which_control
		ldw_a.AcceptText ()
	END IF
END IF

IF This.of_UpdateChecks () = 1 THEN
	IF MessageBox ("Dotaz", "V okně " + This.TItle + " jsou neuložené změny.~n~n" + &
		"Chcete přerušit akci a změny nejprve ručně uložit ?", Question!, YesNo!) = 1 THEN
			IF w_frame.GetActiveSheet () <> This THEN
				This.SetFocus ()
			END IF
		 	RETURN TRUE
	END IF
END IF
RETURN FALSE

end function

public subroutine js_resetdw ();//funkce provede RESET všech datawindow v okně

//This.Event js_resetdata (This.control)

RETURN
end subroutine

on w_sheet.create
call super::create
end on

on w_sheet.destroy
call super::destroy
end on

event close;call super::close;w_frame.Post Ikony ()

IF NOT IsNull (iw_volanoz) THEN   //focus volajicimu oknu
	IF IsValid (iw_volanoz) THEN
		iw_volanoz.SetFocus ()
	END IF
END IF

end event

event closequery;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  closequery
//
//	Description:
//	Search for unsaved datawindows prompting the user if any
//	pending updates are found.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.04 Make sure the window is not minimized and behind other windows.
// JS - pouze překlad anglického originálu
//
//////////////////////////////////////////////////////////////////////////////
//
//	Copyright © 1996-1997 Sybase, Inc. and its subsidiaries.  All rights reserved.
//	Any distribution of the PowerBuilder Foundation Classes (PFC)
//	source code by other than Sybase, Inc. and its subsidiaries is prohibited.
//
//////////////////////////////////////////////////////////////////////////////

Integer	li_pendingrc
Integer	li_validationrc
Integer	li_accepttextrc
Integer	li_msg
Integer	li_rc
String	ls_msgparms[]

// Check if the CloseQuery process has been disabled
If ib_disableclosequery Then
	Return 0
End If

// Call event to perform any pre-CloseQuery processing
If This.Event pfc_preclose ( ) <> 1 Then
	// Prevent the window from closing
	Return 1  
End If

// Prevent validation error messages from appearing while the window is closing
// and allow others to check if the  CloseQuery process is in progress
ib_closestatus = True

// Check for any pending updates
li_rc = of_UpdateChecks()
If li_rc = 0 Then
	// Updates are NOT pending, allow the window to be closed.
	Return 0
ElseIf li_rc < 0 Then
	// Make sure the window is not minimized and behind other windows.
	If this.WindowState = Minimized! Then
		this.WindowState = Normal!
	End If
	this.BringToTop = True	
	
	// There are Updates pending, but at least one data entry error was found.
	// Give the user an opportunity to close the window without saving changes
	If IsValid(gnv_app.inv_error) Then
		li_msg = gnv_app.inv_error.of_Message('pfc_closequery_failsvalidation', &
					 ls_msgparms, gnv_app.iapp_object.DisplayName)
	Else
		li_msg = MessageBox (gnv_app.iapp_object.DisplayName, &
					"Vložené informace neodpovídají pravidlům a "  + &
					"před uložením musí být opraveny.~r~n~r~n" + &
					"Zavřít bez uložení změn ?", &
					exclamation!, YesNo!, 2)
	End If
	If li_msg = 1 Then
		Return 0
	End If
Else
	// Make sure the window is not minimized and behind other windows.
	If this.WindowState = Minimized! Then
		this.WindowState = Normal!
	End If
	this.BringToTop = True	
	
	// Changes are pending, prompt the user to determine if they should be saved
	If IsValid(gnv_app.inv_error) Then
		li_msg = gnv_app.inv_error.of_Message('pfc_closequery_savechanges',  &
					ls_msgparms, gnv_app.iapp_object.DisplayName)		
	Else
		li_msg = MessageBox ( gnv_app.iapp_object.DisplayName, &
					"Chcete uložit provedené změny ?", exclamation!, YesNoCancel!)
	End If
	Choose Case li_msg
		Case 1
			// YES - Update
			// If the update fails, prevent the window from closing
			If This.Event pfc_save() >= 1 Then
				// Successful update, allow the window to be closed
				Return 0
			End If
		Case 2
			// NO - Allow the window to be closed without saving changes
			Return 0
		Case 3
			// CANCEL -  Prevent the window from closing
	End Choose
End If

// Prevent the window from closing
ib_closestatus = False
Return 1
end event

event open;call super::open;
//nahození zavíracího čudlíku na okna

//IF w_frame.inv_sheetmanager.of_GetSheetCount() > 1 THEN
//	m_frame.m_file.m_zavriokna.ToolBarItemVisible = TRUE
//END IF
end event

event pfc_preopen;call super::pfc_preopen;//uchovani TAGu okna, které toto volalo
window activesheet

IF IsValid (w_frame) THEN
	activesheet = w_frame.GetActiveSheet( )
	IF NOT IsNull (activesheet) THEN
		IF IsValid (activesheet) THEN
			is_volanoz = activesheet.tag
			iw_volanoz = activesheet
		ELSE
			is_volanoz = ""
			SetNull (iw_volanoz)
		END IF
	END IF
END IF


end event

