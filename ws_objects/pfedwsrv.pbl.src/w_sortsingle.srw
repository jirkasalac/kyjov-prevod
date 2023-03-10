$PBExportHeader$w_sortsingle.srw
$PBExportComments$Extension Simple Sort dialog window
forward
global type w_sortsingle from pfc_w_sortsingle
end type
end forward

global type w_sortsingle from pfc_w_sortsingle
string title = "Třídění záznamů"
end type
global w_sortsingle w_sortsingle

on w_sortsingle.create
call super::create
end on

on w_sortsingle.destroy
call super::destroy
end on

type cbx_asc from pfc_w_sortsingle`cbx_asc within w_sortsingle
string text = "Vzestupně"
end type

type cb_cancel from pfc_w_sortsingle`cb_cancel within w_sortsingle
string text = "Storno"
end type

type cb_ok from pfc_w_sortsingle`cb_ok within w_sortsingle
end type

type ddlb_sort from pfc_w_sortsingle`ddlb_sort within w_sortsingle
end type

type gb_sort from pfc_w_sortsingle`gb_sort within w_sortsingle
end type

type cb_dlghelp from pfc_w_sortsingle`cb_dlghelp within w_sortsingle
boolean visible = false
end type

