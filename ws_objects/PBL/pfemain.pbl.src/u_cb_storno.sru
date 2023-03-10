$PBExportHeader$u_cb_storno.sru
forward
global type u_cb_storno from u_cb
end type
end forward

global type u_cb_storno from u_cb
integer textsize = -9
integer weight = 700
string facename = "Arial"
string text = "Storno"
boolean cancel = true
end type
global u_cb_storno u_cb_storno

on u_cb_storno.create
call super::create
end on

on u_cb_storno.destroy
call super::destroy
end on

event clicked;call super::clicked;//Close (Parent)  tohle pada
w_master lw_parent

of_GetParentWindow (lw_parent)
lw_parent.Post Event pfc_Close ()

end event

