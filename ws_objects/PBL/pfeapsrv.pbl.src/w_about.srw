$PBExportHeader$w_about.srw
$PBExportComments$Extension About window
forward
global type w_about from pfc_w_about
end type
end forward

global type w_about from pfc_w_about
integer height = 940
string title = "O aplikaci"
end type
global w_about w_about

on w_about.create
call super::create
end on

on w_about.destroy
call super::destroy
end on

event open;call super::open;String ls_a, ls_d = String (Today (), "dd.mm.yyyy ") + String (Now (), "hh:mm")

st_version.text = st_version.text + " ze dne " + ls_d

end event

type p_about from pfc_w_about`p_about within w_about
integer width = 1609
integer height = 336
boolean originalsize = false
string picturename = "prodata.bmp"
end type

type st_application from pfc_w_about`st_application within w_about
integer x = 59
integer y = 416
integer width = 1481
end type

type st_version from pfc_w_about`st_version within w_about
integer x = 59
integer y = 488
integer width = 1481
end type

type cb_ok from pfc_w_about`cb_ok within w_about
integer y = 700
end type

type st_copyright from pfc_w_about`st_copyright within w_about
integer x = 59
integer y = 560
integer width = 1481
integer height = 108
end type

