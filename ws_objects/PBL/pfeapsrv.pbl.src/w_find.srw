$PBExportHeader$w_find.srw
$PBExportComments$Extension Find window
forward
global type w_find from pfc_w_find
end type
end forward

global type w_find from pfc_w_find
string title = "Hledat"
end type
global w_find w_find

on w_find.create
call super::create
end on

on w_find.destroy
call super::destroy
end on

type st_findwhere from pfc_w_find`st_findwhere within w_find
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Hledat v položc&e:"
alignment alignment = right!
end type

type st_searchfor from pfc_w_find`st_searchfor within w_find
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Hledat &hodnotu:"
alignment alignment = right!
end type

type ddlb_findwhere from pfc_w_find`ddlb_findwhere within w_find
end type

type st_searchdirection from pfc_w_find`st_searchdirection within w_find
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "&Směr hledání:"
alignment alignment = right!
end type

type cbx_wholeword from pfc_w_find`cbx_wholeword within w_find
integer y = 460
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Celé slovo"
end type

type cbx_matchcase from pfc_w_find`cbx_matchcase within w_find
integer y = 568
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Tahoma"
string text = "Rozlišovat velká a malá písmena"
end type

type cb_findnext from pfc_w_find`cb_findnext within w_find
string text = "&Najít další"
end type

type cb_cancel from pfc_w_find`cb_cancel within w_find
string text = "Storno"
end type

type sle_findwhat from pfc_w_find`sle_findwhat within w_find
end type

type ddlb_searchdirection from pfc_w_find`ddlb_searchdirection within w_find
end type

type cb_dlghelp from pfc_w_find`cb_dlghelp within w_find
boolean visible = false
end type

