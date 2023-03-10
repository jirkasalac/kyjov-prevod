$PBExportHeader$w_zoom.srw
$PBExportComments$Extension Zoom dialog window
forward
global type w_zoom from pfc_w_zoom
end type
end forward

global type w_zoom from pfc_w_zoom
end type
global w_zoom w_zoom

on w_zoom.create
call super::create
end on

on w_zoom.destroy
call super::destroy
end on

type rb_custom from pfc_w_zoom`rb_custom within w_zoom
end type

type rb_200 from pfc_w_zoom`rb_200 within w_zoom
end type

type rb_100 from pfc_w_zoom`rb_100 within w_zoom
end type

type rb_75 from pfc_w_zoom`rb_75 within w_zoom
end type

type rb_50 from pfc_w_zoom`rb_50 within w_zoom
end type

type rb_25 from pfc_w_zoom`rb_25 within w_zoom
end type

type st_1 from pfc_w_zoom`st_1 within w_zoom
string text = "Procenta:"
end type

type em_zoom from pfc_w_zoom`em_zoom within w_zoom
end type

type cb_ok from pfc_w_zoom`cb_ok within w_zoom
integer x = 690
end type

type cb_cancel from pfc_w_zoom`cb_cancel within w_zoom
integer x = 1083
string text = "Storno"
end type

type cb_apply from pfc_w_zoom`cb_apply within w_zoom
integer x = 1477
string text = "&Použít"
end type

type dw_preview from pfc_w_zoom`dw_preview within w_zoom
end type

type gb_1 from pfc_w_zoom`gb_1 within w_zoom
string text = "Náhled"
end type

type gb_3 from pfc_w_zoom`gb_3 within w_zoom
string text = "Měřítko"
end type

type cb_dlghelp from pfc_w_zoom`cb_dlghelp within w_zoom
boolean visible = false
end type

