$PBExportHeader$w_logon.srw
$PBExportComments$Extension Logon window
forward
global type w_logon from pfc_w_logon
end type
end forward

global type w_logon from pfc_w_logon
integer width = 2309
integer height = 984
string title = "Přihlášení do aplikace"
end type
global w_logon w_logon

on w_logon.create
call super::create
end on

on w_logon.destroy
call super::destroy
end on

event pfc_default;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  pfc_default
//
//	Arguments:  none
//
//	Returns:  none
//
//	Description:  Peform logon
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
// 6.0 	Enhanced to support multiple logon attempts.
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2005, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the GNU Lesser General
 * Public License Version 2.1, February 1999
 *
 * http://www.gnu.org/copyleft/lesser.html
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see http://pfc.codexchange.sybase.com
*/
//
//////////////////////////////////////////////////////////////////////////////

integer	li_rc

//////////////////////////////////////////////////////////////////////////////
// Check required fields
//////////////////////////////////////////////////////////////////////////////
if Len (sle_userid.text) = 0 then
	of_MessageBox ("pfc_logon_enterid", inv_logonattrib.is_appname, &
		"Zadejte prosím jméno uživatele.", exclamation!, OK!, 1)
	sle_userid.SetFocus()
	return
end if
if Len (sle_password.text) = 0 then
	of_MessageBox ("pfc_logon_enterpassword", inv_logonattrib.is_appname, &
		"Zadejte prosím své uživatelské heslo.", exclamation!, OK!, 1)
	sle_password.SetFocus()
	return
end if
if Isnull(inv_logonattrib.ipo_source) or Not IsValid (inv_logonattrib.ipo_source) then
	this.event pfc_cancel()
	return
End If

//////////////////////////////////////////////////////////////////////////////
// Attempt to logon
//////////////////////////////////////////////////////////////////////////////
ii_logonattempts --
li_rc = inv_logonattrib.ipo_source.dynamic event pfc_logon &
	(sle_userid.text, sle_password.text)
if IsNull (li_rc) then 
	this.event pfc_cancel()
	return
ElseIf li_rc <= 0 Then
	If ii_logonattempts > 0 Then
		// There are still have more attempts for a succesful login.
		of_MessageBox ("pfc_logon_incorrectpassword", "Login", &
			"Chybné heslo.", StopSign!, Ok!, 1)
		sle_password.SetFocus()
		Return
	Else
		// Failure return code
		inv_logonattrib.ii_rc = -1	
		CloseWithReturn (this, inv_logonattrib)
	End If
Else
	// Successful return code
	inv_logonattrib.ii_rc = 1
	inv_logonattrib.is_userid = sle_userid.text
	inv_logonattrib.is_password = sle_password.text	
	CloseWithReturn (this, inv_logonattrib)	
End if

Return
end event

type p_logo from pfc_w_logon`p_logo within w_logon
integer x = 5
integer y = 0
integer width = 1609
integer height = 336
boolean originalsize = false
string picturename = "C:\seznam_xml\prodata.BMP"
end type

type st_help from pfc_w_logon`st_help within w_logon
integer x = 0
integer y = 396
integer width = 2208
integer height = 92
integer textsize = -11
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Zadejte uživatelské jméno a heslo do aplikace "
alignment alignment = center!
end type

type cb_ok from pfc_w_logon`cb_ok within w_logon
integer x = 1778
integer y = 552
end type

type cb_cancel from pfc_w_logon`cb_cancel within w_logon
integer x = 1778
integer y = 656
string text = "Storno"
end type

type sle_userid from pfc_w_logon`sle_userid within w_logon
integer x = 1280
integer y = 552
integer width = 443
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
end type

type sle_password from pfc_w_logon`sle_password within w_logon
integer x = 1280
integer y = 656
integer width = 443
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
end type

type st_2 from pfc_w_logon`st_2 within w_logon
integer x = 681
integer y = 560
integer textsize = -9
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Uživatelské jméno:"
end type

type st_3 from pfc_w_logon`st_3 within w_logon
integer x = 681
integer y = 660
integer textsize = -9
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Heslo:"
end type

