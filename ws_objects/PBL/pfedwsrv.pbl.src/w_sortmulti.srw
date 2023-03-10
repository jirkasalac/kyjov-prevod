$PBExportHeader$w_sortmulti.srw
$PBExportComments$Extension DDLB-style Sort dialog window
forward
global type w_sortmulti from pfc_w_sortmulti
end type
end forward

global type w_sortmulti from pfc_w_sortmulti
string title = "Třídění záznamů"
end type
global w_sortmulti w_sortmulti

on w_sortmulti.create
call super::create
end on

on w_sortmulti.destroy
call super::destroy
end on

type dw_sort from pfc_w_sortmulti`dw_sort within w_sortmulti
end type

type cb_add from pfc_w_sortmulti`cb_add within w_sortmulti
string text = "&Přidat"
end type

type cb_delete from pfc_w_sortmulti`cb_delete within w_sortmulti
string text = "&Zrušit"
end type

type cb_insert from pfc_w_sortmulti`cb_insert within w_sortmulti
string text = "&Vložit"
end type

type cb_ok from pfc_w_sortmulti`cb_ok within w_sortmulti
end type

type cb_cancel from pfc_w_sortmulti`cb_cancel within w_sortmulti
string text = "Storno"
end type

type gb_sort from pfc_w_sortmulti`gb_sort within w_sortmulti
string text = "Třídění položkami"
end type

type cb_dlghelp from pfc_w_sortmulti`cb_dlghelp within w_sortmulti
boolean visible = false
end type

