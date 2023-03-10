$PBExportHeader$w_sukej.srw
forward
global type w_sukej from w_response
end type
type cb_storno from u_cb_storno within w_sukej
end type
type cb_ok from u_cb within w_sukej
end type
type em_cislo from u_em within w_sukej
end type
type st_2 from u_st within w_sukej
end type
type st_1 from u_st within w_sukej
end type
type em_rok from u_em within w_sukej
end type
end forward

global type w_sukej from w_response
integer x = 214
integer y = 221
integer width = 786
integer height = 548
cb_storno cb_storno
cb_ok cb_ok
em_cislo em_cislo
st_2 st_2
st_1 st_1
em_rok em_rok
end type
global w_sukej w_sukej

event open;call super::open;em_rok.SetFocus ()

end event

on w_sukej.create
int iCurrent
call super::create
this.cb_storno=create cb_storno
this.cb_ok=create cb_ok
this.em_cislo=create em_cislo
this.st_2=create st_2
this.st_1=create st_1
this.em_rok=create em_rok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_storno
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.em_cislo
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.em_rok
end on

on w_sukej.destroy
call super::destroy
destroy(this.cb_storno)
destroy(this.cb_ok)
destroy(this.em_cislo)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.em_rok)
end on

type cb_storno from u_cb_storno within w_sukej
integer x = 384
integer y = 304
integer width = 293
integer taborder = 40
end type

type cb_ok from u_cb within w_sukej
integer x = 59
integer y = 304
integer width = 293
integer taborder = 30
string text = "Hledej"
end type

event clicked;call super::clicked;Integer li_rok
Long ll_cislo, ll_row

li_rok = Integer (em_rok.text)
IF li_rok = 0 THEN
	MessageBox ("Chyba", "Zadej rok.", Exclamation!)
	em_rok.SetFocus ()
	RETURN
END IF
ll_cislo = Integer (em_cislo.text)
IF ll_cislo = 0 THEN
	MessageBox ("Chyba", "Zadej číslo.", Exclamation!)
	em_cislo.SetFocus ()
	RETURN
END IF
ll_row = w_vys.dw_data.Find ("rok='" + String (li_rok) + "' AND cislo=" + String (ll_cislo), 1, w_vys.dw_data.RowCount ())
IF ll_row > 0 THEN
	w_vys.dw_data.ScrollToRow (ll_row)
	RETURN
END IF





end event

type em_cislo from u_em within w_sukej
integer x = 270
integer y = 152
integer width = 361
integer height = 92
integer taborder = 20
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
alignment alignment = center!
string mask = "#,###,###"
end type

type st_2 from u_st within w_sukej
integer x = 64
integer y = 164
integer width = 174
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Číslo:"
alignment alignment = right!
end type

type st_1 from u_st within w_sukej
integer x = 64
integer y = 64
integer width = 174
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Rok:"
alignment alignment = right!
end type

type em_rok from u_em within w_sukej
integer x = 270
integer y = 52
integer width = 229
integer height = 92
integer taborder = 10
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
alignment alignment = center!
string mask = "####"
end type

