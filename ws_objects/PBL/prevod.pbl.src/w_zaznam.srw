$PBExportHeader$w_zaznam.srw
forward
global type w_zaznam from w_response
end type
type cb_goto from u_cb within w_zaznam
end type
type cb_storno from u_cb_storno within w_zaznam
end type
type sle_1 from u_sle within w_zaznam
end type
type st_1 from u_st within w_zaznam
end type
end forward

global type w_zaznam from w_response
integer x = 214
integer y = 221
integer width = 1056
integer height = 572
cb_goto cb_goto
cb_storno cb_storno
sle_1 sle_1
st_1 st_1
end type
global w_zaznam w_zaznam

on w_zaznam.create
int iCurrent
call super::create
this.cb_goto=create cb_goto
this.cb_storno=create cb_storno
this.sle_1=create sle_1
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_goto
this.Control[iCurrent+2]=this.cb_storno
this.Control[iCurrent+3]=this.sle_1
this.Control[iCurrent+4]=this.st_1
end on

on w_zaznam.destroy
call super::destroy
destroy(this.cb_goto)
destroy(this.cb_storno)
destroy(this.sle_1)
destroy(this.st_1)
end on

type cb_goto from u_cb within w_zaznam
integer x = 178
integer y = 256
integer taborder = 40
string text = "GO TO"
end type

event clicked;call super::clicked;Long ll_row
String ls_a

ll_row = Long (sle_1.text)
IF ll_row > 0 AND lL_row < w_vys.dw_data.RowCount () THEN 
	w_vys.dw_data.ScrollToRow (ll_row)
	cb_storno.Post Event Clicked ()
END IF


end event

type cb_storno from u_cb_storno within w_zaznam
integer x = 567
integer y = 256
integer taborder = 30
end type

type sle_1 from u_sle within w_zaznam
integer x = 453
integer y = 80
integer width = 434
integer height = 92
integer taborder = 10
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
end type

type st_1 from u_st within w_zaznam
integer x = 73
integer y = 92
integer width = 343
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Záznam č.:"
alignment alignment = right!
end type

