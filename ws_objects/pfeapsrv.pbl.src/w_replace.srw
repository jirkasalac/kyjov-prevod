$PBExportHeader$w_replace.srw
$PBExportComments$Extension Replace window
forward
global type w_replace from pfc_w_replace
end type
end forward

global type w_replace from pfc_w_replace
integer height = 924
string title = "Náhrada"
end type
global w_replace w_replace

on w_replace.create
call super::create
end on

on w_replace.destroy
call super::destroy
end on

type st_findwhere from pfc_w_replace`st_findwhere within w_replace
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Hledat v položc&e:"
alignment alignment = right!
end type

type st_findwhat from pfc_w_replace`st_findwhat within w_replace
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Hledat &hodnotu:"
alignment alignment = right!
end type

type ddlb_findwhere from pfc_w_replace`ddlb_findwhere within w_replace
end type

type st_searchdirection from pfc_w_replace`st_searchdirection within w_replace
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "&Směr hledání:"
alignment alignment = right!
end type

type cbx_wholeword from pfc_w_replace`cbx_wholeword within w_replace
integer y = 560
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Celé slovo"
end type

type cbx_matchcase from pfc_w_replace`cbx_matchcase within w_replace
integer y = 656
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Rozlišovat velká a malá písmena"
end type

type cb_findnext from pfc_w_replace`cb_findnext within w_replace
string text = "&Najdi další"
end type

type cb_cancel from pfc_w_replace`cb_cancel within w_replace
string text = "Storno"
end type

type sle_findwhat from pfc_w_replace`sle_findwhat within w_replace
end type

type sle_replace from pfc_w_replace`sle_replace within w_replace
end type

type st_replace from pfc_w_replace`st_replace within w_replace
integer x = 5
integer width = 553
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Zamě&nit hodnotou:"
alignment alignment = right!
end type

type cb_replace from pfc_w_replace`cb_replace within w_replace
string text = "&Zaměnit"
end type

type cb_replaceall from pfc_w_replace`cb_replaceall within w_replace
integer width = 411
string text = "Zaměnit &vše"
end type

type ddlb_searchdirection from pfc_w_replace`ddlb_searchdirection within w_replace
end type

type cb_dlghelp from pfc_w_replace`cb_dlghelp within w_replace
boolean visible = false
end type

