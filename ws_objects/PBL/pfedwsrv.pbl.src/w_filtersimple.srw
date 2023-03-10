$PBExportHeader$w_filtersimple.srw
$PBExportComments$Extension Simple-Style Filter dialog window
forward
global type w_filtersimple from pfc_w_filtersimple
end type
end forward

global type w_filtersimple from pfc_w_filtersimple
string title = "Filtrování záznamů"
end type
global w_filtersimple w_filtersimple

on w_filtersimple.create
call super::create
end on

on w_filtersimple.destroy
call super::destroy
end on

type cb_delete from pfc_w_filtersimple`cb_delete within w_filtersimple
string text = "&Zrušit"
end type

type cb_cancel from pfc_w_filtersimple`cb_cancel within w_filtersimple
string text = "Storno"
end type

type dw_filter from pfc_w_filtersimple`dw_filter within w_filtersimple
end type

type mle_originalfilter from pfc_w_filtersimple`mle_originalfilter within w_filtersimple
end type

type gb_originalfilter from pfc_w_filtersimple`gb_originalfilter within w_filtersimple
string text = "Původní podmínky"
end type

type cb_add from pfc_w_filtersimple`cb_add within w_filtersimple
string text = "&Přidat"
end type

type gb_newfilter from pfc_w_filtersimple`gb_newfilter within w_filtersimple
string text = "Nové podmínky"
end type

type cb_ok from pfc_w_filtersimple`cb_ok within w_filtersimple
end type

type cb_dlghelp from pfc_w_filtersimple`cb_dlghelp within w_filtersimple
boolean visible = false
end type

