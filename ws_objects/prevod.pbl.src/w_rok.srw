$PBExportHeader$w_rok.srw
forward
global type w_rok from w_response
end type
type ddlb_typ from u_ddlb within w_rok
end type
type st_2 from u_st within w_rok
end type
type cb_proved from u_cb within w_rok
end type
type cb_storno from u_cb_storno within w_rok
end type
type em_rok from u_em within w_rok
end type
type st_1 from u_st within w_rok
end type
end forward

global type w_rok from w_response
integer width = 736
integer height = 516
string title = "Rok pro výkony"
ddlb_typ ddlb_typ
st_2 st_2
cb_proved cb_proved
cb_storno cb_storno
em_rok em_rok
st_1 st_1
end type
global w_rok w_rok

on w_rok.create
int iCurrent
call super::create
this.ddlb_typ=create ddlb_typ
this.st_2=create st_2
this.cb_proved=create cb_proved
this.cb_storno=create cb_storno
this.em_rok=create em_rok
this.st_1=create st_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_typ
this.Control[iCurrent+2]=this.st_2
this.Control[iCurrent+3]=this.cb_proved
this.Control[iCurrent+4]=this.cb_storno
this.Control[iCurrent+5]=this.em_rok
this.Control[iCurrent+6]=this.st_1
end on

on w_rok.destroy
call super::destroy
destroy(this.ddlb_typ)
destroy(this.st_2)
destroy(this.cb_proved)
destroy(this.cb_storno)
destroy(this.em_rok)
destroy(this.st_1)
end on

type ddlb_typ from u_ddlb within w_rok
integer x = 270
integer y = 140
integer width = 229
integer height = 360
integer taborder = 20
boolean sorted = false
string item[] = {" ","S","B","C","H"}
end type

type st_2 from u_st within w_rok
integer x = 96
integer y = 144
integer width = 151
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Typ:"
alignment alignment = right!
end type

type cb_proved from u_cb within w_rok
integer x = 59
integer y = 284
integer width = 279
integer taborder = 30
string text = "Proveď"
end type

event clicked;call super::clicked;String ls_f, ls_a

ls_f = "rok='" + em_rok.text + "'"
ls_a = TRIM (ddlb_typ.text)
IF ls_a <> "" THEN ls_f += " AND typ = '" + ls_a + "'"
w_vys.dw_data.SetFilter (ls_f)
w_vys.dw_data.Filter ()
cb_storno.Post Event Clicked ()

end event

type cb_storno from u_cb_storno within w_rok
integer x = 366
integer y = 280
integer width = 279
integer taborder = 20
end type

type em_rok from u_em within w_rok
integer x = 270
integer y = 40
integer width = 229
integer height = 84
integer taborder = 10
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "2019"
alignment alignment = center!
string mask = "0000"
end type

type st_1 from u_st within w_rok
integer x = 105
integer y = 48
integer width = 142
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Rok:"
alignment alignment = right!
end type

