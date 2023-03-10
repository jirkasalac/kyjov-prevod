$PBExportHeader$w_vys_old.srw
forward
global type w_vys_old from w_sheet
end type
type cb_lekari from u_cb within w_vys_old
end type
type cb_pitvy from u_cb within w_vys_old
end type
type mle_1 from u_mle within w_vys_old
end type
type cbx_lekari from u_cbx within w_vys_old
end type
type dw_vykony from u_dw within w_vys_old
end type
type st_4 from u_st within w_vys_old
end type
type em_vyk from u_em within w_vys_old
end type
type st_3 from u_st within w_vys_old
end type
type st_2 from u_st within w_vys_old
end type
type dw_zkratky from u_dw within w_vys_old
end type
type ddlb_typ from u_ddlb within w_vys_old
end type
type cbx_cave from u_cbx within w_vys_old
end type
type cb_zaznam from u_cb within w_vys_old
end type
type cb_cave from u_cb within w_vys_old
end type
type sle_vzorek from u_sle within w_vys_old
end type
type em_primarni_vzorek from u_em within w_vys_old
end type
type st_1 from u_st within w_vys_old
end type
type st_zaz from u_st within w_vys_old
end type
type cb_zrus from u_cb within w_vys_old
end type
type cb_export from u_cb within w_vys_old
end type
type cb_nacti from u_cb within w_vys_old
end type
type cb_storno from u_cb_storno within w_vys_old
end type
type dw_data from u_dw within w_vys_old
end type
end forward

global type w_vys_old from w_sheet
string tag = "w_vys"
integer width = 5138
integer height = 2252
string title = "Převod vyšetření"
string menuname = "m_vys"
cb_lekari cb_lekari
cb_pitvy cb_pitvy
mle_1 mle_1
cbx_lekari cbx_lekari
dw_vykony dw_vykony
st_4 st_4
em_vyk em_vyk
st_3 st_3
st_2 st_2
dw_zkratky dw_zkratky
ddlb_typ ddlb_typ
cbx_cave cbx_cave
cb_zaznam cb_zaznam
cb_cave cb_cave
sle_vzorek sle_vzorek
em_primarni_vzorek em_primarni_vzorek
st_1 st_1
st_zaz st_zaz
cb_zrus cb_zrus
cb_export cb_export
cb_nacti cb_nacti
cb_storno cb_storno
dw_data dw_data
end type
global w_vys_old w_vys_old

type variables
Boolean ib_vse = FALSE, ib_pitvy
n_cst_String inv_string
long il_biopsie = 0, il_cytologie = 1000000, il_pitva = 2000000
String is_biopsie = 'H', is_cytologie = 'C', is_pitva = 'P'

end variables

forward prototypes
public function date wf_datum (string as_a)
public function integer wf_vytahni (string as_text, string as_uvod)
public function string wf_lekar (string as_text, string as_uvod)
public subroutine wf_biopsie (string as_parm)
public function integer wf_zkratka (long al_idvysetr, string as_zkratka, integer ai_pocet)
public function integer wf_vykony (long al_idvysetr, string as_zkratka, integer ai_pocet)
public function integer wf_lekar_zaloz (integer ai_cislo, string as_lekar)
public function datetime wf_datcas (string as_par)
end prototypes

public function date wf_datum (string as_a);String ls_r, ls_m, ls_d, ls_a
Date ld_n

ls_a = LEFT (as_a, 10)
IF POS (ls_a, "/") > 0 THEN
	ls_r = MID (ls_a, 7, 4)
	ls_m = MID (ls_a, 1, 2)
	ls_d = MID (ls_a, 4, 2)
ELSEIF POS (ls_a, "-") > 0 THEN
	ls_r = MID (ls_a, 1, 4)
	ls_m = MID (ls_a, 6, 2)
	ls_d = MID (ls_a, 9, 2)
ELSE
	ls_r = MID (ls_a, 7, 4)
	ls_m = MID (ls_a, 4, 2)
	ls_d = MID (ls_a, 1, 2)
END IF
IF IsDate (ls_d + "." + ls_m + "." + ls_r) THEN 
	IF Integer (ls_r) < Year (Today ()) - 2000 THEN ls_r = "2" + MID (ls_r, 2)
	ld_n = Date (ls_d + "." + ls_m + "." + ls_r)
	IF Year (ld_n) > 1900 AND Year (ld_n) < 2050 THEN RETURN ld_n
END IF
Setnull (ld_n)
RETURN ld_n
	

end function

public function integer wf_vytahni (string as_text, string as_uvod);//vytažení hodnoty v závorkách
Integer li_a, li_vr
String ls_a

li_a = POS (as_text, as_uvod)
IF li_a > 0 THEN
	ls_a = MID (as_text, li_a + LEN (as_uvod))
	li_a = POS (ls_a, "(")
	IF li_a > 0 THEN 
		ls_a = MID (ls_a, li_a + 1)
		li_a = POS (ls_a, ")")
		IF li_a > 0 THEN 
			ls_a = LEFT (ls_a, li_a - 1)
			li_vr = Integer (ls_a)
		END IF
	END IF
END IF
RETURN li_vr

end function

public function string wf_lekar (string as_text, string as_uvod);//vytažení jména lékaře
Integer li_a
String ls_a, ls_vr

ls_a = as_text
li_a = POS (ls_a, "Lékař:")
IF li_a > 0 THEN 
	ls_a = MID (ls_a, li_a + 6)
	li_a = POS (ls_a, ",")
	IF li_a > 0 THEN 
		ls_vr = TRIM (LEFT (ls_a, li_a - 1))
	END IF
END IF
RETURN ls_vr

end function

public subroutine wf_biopsie (string as_parm);Long ll_pocet, ll_row, ll_idvysetr, ll_ok, ll_dupl, ll_err, ll_poc, ll_kli, ll_cislodo, ll_cislo, ll_i, ll_idvys, ll_a, ll_dg, ll_j, ll_pocdg, ll_cis, ll_id, ll_emp, ll_zkr, ll_dod, ll_vyk, ll_lek
Integer li_odp, li_rok, li_c_odeslal, li_c_dok, li_a, li_klinal, li_nalez, li_potvrzeni, li_vykony, li_tisk, li_tisk_archiv, li_xml, li_c_uvolnil, li_r1 ,li_r2
Integer li_materialy, li_dodatek, li_bloky, li_skla, li_pristroje, li_klidg, li_zadatel, li_blokace, li_bloknal, li_pocet, li_i, li_uvo, li_poc_bs
String ls_primarni_vzorek, ls_vzorek, ls_typvys, ls_dupl, ls_icp, ls_soubor, ls_varsym, ls_cave, ls_dodatek, ls_lekardod
String ls_odeslal, ls_ulice, ls_psc, ls_obec, ls_rc, ls_prjm, ls_a, ls_pohlavi, ls_informace, ls_kasa, ls_cislo, ls_uvonalez, ls_nelek
String ls_rada, ls_lekar, ls_klinal, ls_nalez, ls_interni, ls_kli_diag, ls_klislo, ls_odeodb, ls_klinika, ls_nezkr, ls_xx, ls_cisdupl
String ls_diag, ls_platba = "D", ls_dg, ls_dodatky, ls_stavvys, ls_stav, ls_nal, ls_zkr, ls_pocet, ls_o, ls_poc, ls_zkratka, ls_dodpitva
DateTime ldt_a
Date ld_datnar, ld_prijem, ld_odber, ld_vysetr, ld_a, ld_vyk, ld_vys
Time lt_prijem_cas, lt_odber_cas, lt_vysetr_cas, lt_cas, lt_vys
n_ds lds_dg

ll_pocet = dw_data.RowCount ()
ld_vyk = Date (em_vyk.text)
IF IsNull (ld_vyk) OR Year (ld_vyk) < 2000 THEN
	em_vyk.SetFocus ()
	MessageBox ("Chyba", "Zadejte datum.", Exclamation!)
	RETURN
END IF
IF MessageBox ("Dotaz", "Skutečně chcete načíst celkem " + String (ll_pocet) + " vyšetření typu biopsie ?", Question!, YesNo!) = 1 THEN
	ls_primarni_vzorek = TRIM (em_primarni_vzorek.text)
	ls_vzorek = TRIM (sle_vzorek.text)
	SetPointer (HourGlass!)
	ll_row = dw_data.getRow ()
	IF ll_row > 1 THEN
		li_odp = MessageBox ("Dotaz", "Skutečně začít od záznamu č." + String (ll_row) + " (XML = " + dw_data.getItemString (ll_row, "soubor") + "') ?", Question!, YesnoCancel!)
		IF li_odp = 2 THEN ll_row = 1
		IF li_odp = 3 THEN RETURN
	END IF
	lds_dg = CREATE n_ds
	lds_dg.DataObject = "d_vysdg"
	lds_dg.of_SetTransObject (SQLZIS)
	SQLCA.of_Execute ("SET QUOTED_IDENTIFIER ON")
	for ll_i = ll_row to ll_pocet
		Yield ()
		w_frame.Event Pfc_Microhelp ("Zpracovávám záznam č. " + String (ll_i) + " z celkového počtu " + String (ll_pocet))
		ll_idvys = dw_data.getItemNumber (ll_i, "idvys")
		ls_soubor = dw_data.getItemString (ll_i, "soubor")
		ls_icp = dw_data.getItemString (ll_i, "icp")
		SELECT Count (*), MAX (cislo) INTO :ll_poc, :li_c_odeslal FROM dbo.kliniky WHERE icp = :ls_icp;
		IF NOT (SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 AND li_c_odeslal > 0) THEN
			ll_err ++
			ll_kli ++
			CONTINUE
		END IF
		ls_uvonalez = "Nález:"
		choose case LEFT (dw_data.getItemString (ll_i, "typvys"), 1)
		case "B"
			ls_typvys = is_biopsie
		case "C"
			ls_typvys = is_cytologie
		case "N"
			ls_typvys = is_pitva
			ls_uvonalez = "Anatomická diagnóza:"
		end choose
		ls_varsym = TRIM (dw_data.getItemString (ll_i, "kli_var"))
		IF isNull (ls_varsym) THEN ls_varsym = ''
		ls_odeslal = TRIM (dw_data.getItemString (ll_i, "odeslal"))
		IF isNull (ls_odeslal) THEN ls_odeslal = ''
		IF LEN (ls_odeslal) > 50 THEN ls_odeslal = LEFT (ls_odeslal, 50)
		ls_ulice = TRIM (dw_data.getItemString (ll_i, "kli_ulice"))
		IF isNull (ls_ulice) THEN ls_ulice = ''
		ls_psc = gnv_app.inv_string.of_GlobalReplace (TRIM (dw_data.getItemString (ll_i, "kli_psc")), " ", "")
		IF isNull (ls_psc) THEN ls_psc = ''
		ls_obec = TRIM (dw_data.getItemString (ll_i, "kli_obec"))
		IF isNull (ls_obec) THEN ls_obec = ''
		ls_cave = ""
		IF ls_obec <> "" OR ls_ulice <> "" THEN ls_cave = ls_ulice + ", " + ls_psc + " " + ls_obec
		ls_rc = TRIM (dw_data.getItemString (ll_i, "rc"))
		IF isNull (ls_rc) THEN ls_rc = ''
		ls_prjm = TRIM (dw_data.getItemString (ll_i, "prijmeni"))
		IF isNull (ls_prjm) THEN ls_prjm = ''
		ls_a = TRIM (dw_data.getItemString (ll_i, "jmeno"))
		IF isNull (ls_a) THEN ls_a = ''
		IF ls_a <> "" THEN ls_prjm += " " + ls_a
		ld_datnar = wf_datum (dw_data.getItemString (ll_i, "datnar"))
		IF NOT (IsNull (ld_datnar)) THEN 
			IF ls_cave = "" THEN
				ls_cave = "Narození: " + String (ld_datnar, "dd.mm.yyyy")
			ELSE
				ls_cave = "Narození: " + String (ld_datnar, "dd.mm.yyyy") + ", " + ls_cave
			END IF
		END IF
		ls_pohlavi = TRIM (dw_data.getItemString (ll_i, "pohlavi"))
		IF isNull (ls_pohlavi) THEN ls_pohlavi = ''
		ll_a = dw_data.getItemNumber (ll_i, "labcis")
		IF isNull (ll_a) THEN ll_a = 0
		ls_informace = ""
		IF ll_a > 0 THEN ls_informace = "Lab.číslo v NIS: " + String (ll_a)
		ls_kasa = TRIM (dw_data.getItemString (ll_i, "kasa"))
		IF isNull (ls_kasa) THEN ls_kasa = ''
		ls_a = TRIM (dw_data.getItemString (ll_i, "cislo"))
		ls_cisdupl = ls_a
		ls_rada = ""
		IF gnv_app.inv_string.of_IsAlpha (LEFT (ls_a, 1)) THEN
			ls_rada = LEFT (ls_a, 1)
			ls_a = MID (ls_a, 2)
		END IF
		ls_cislo = gnv_app.inv_string.of_getToken (ls_a, "/")
		li_rok = Integer (ls_a)
		IF li_rok <= 30 THEN
			li_rok += 2000
		ELSE
			li_rok += 1900
		END IF
		IF POS (ls_cislo, "-") > 0 THEN
			ls_a = gnv_app.inv_string.of_getToken (ls_cislo, "-")
			ll_cislo = Long (ls_a)
			IF ls_cislo = "00" THEN
				ls_a = LEFT (ls_a, LEN (ls_a) -2) + ls_cislo
				ll_cislodo = Long (ls_a) + 100
			ELSE
				ls_a = LEFT (ls_a, LEN (ls_a) -2) + ls_cislo
				ll_cislodo = Long (ls_a)
			END IF
		ELSE
			ll_cislo = Long (ls_cislo)
			ll_cislodo = 0
		END IF
		choose case ls_rada
		case "C"
			ll_cislo += 1000000
			IF ll_cislodo > 0 THEN ll_cislodo += 1000000
		case "N"
			ll_cislo += 2000000
			IF ll_cislodo > 0 THEN ll_cislodo += 2000000
		end choose
		ldt_a = dw_data.getItemDateTime (ll_i, "odber_datcas")
		ld_odber = Date (ldt_a)
		lt_odber_cas = Time (String (ldt_a, "hh:mm"))
		ldt_a = dw_data.getItemDateTime (ll_i, "prijem_datcas")
		IF Year (Date (ldt_a)) < 1950 THEN SetNull (ldt_a)
		ld_prijem = Date (ldt_a)
		lt_prijem_cas = Time (String (ldt_a, "hh:mm"))
		ldt_a = dw_data.getItemDateTime (ll_i, "vysetr_datcas")
		ld_vysetr = Date (ldt_a)
		lt_vysetr_cas = Time (String (ldt_a, "hh:mm"))
		ls_lekar = String (dw_data.getItemNumber (ll_i, "c_lekar"))
		li_c_dok = 0 
		IF ls_lekar <> "" THEN
			ls_a = "%" + ls_lekar + "%"
			SELECT Count (*), MAX (c_dok) INTO :ll_poc, :li_a FROM Dbo.personal WHERE fax LIKE :ls_a OR informace LIKE :ls_a;
			IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc = 1 THEN 
				li_c_dok = li_a
			ELSE
				IF POS (ls_nelek, ls_lekar) = 0 THEN
					IF ls_nelek <> "" THEN ls_nelek += ", "
					ls_nelek += ls_lekar
				END IF
			END IF
		END IF
		li_c_uvolnil = li_c_dok
		ls_a = dw_data.getItemString (ll_i, "nalez")
		ls_interni = ls_a
		IF POS (UPPER (ls_a), "EJAKULÁT") > 0 THEN ls_typvys = 'CAN'
		li_vykony = POS (ls_a, "Provedená vyšetření:")
		li_materialy = POS (ls_a, "Materiály:")
		li_pristroje = POS (ls_a, "Přístroje:")
		li_zadatel = POS (ls_a, "Žadatel:")
		li_klidg = POS (ls_a, "Diagnóza:")
		li_klinal = POS (ls_a, "Klinická diagnóza:")
		li_nalez = POS (ls_a, ls_uvonalez)
		li_potvrzeni = POS (ls_a, "Datum potvrzení:")
		li_dodatek = POS (ls_a, "Dodatek 1:")
		ls_klinal = ""; ls_nalez = ""; ls_dodatky = ""
		IF li_klinal > 0 AND li_nalez > 0 THEN ls_klinal = MID (ls_a, li_klinal, li_nalez - li_klinal)
		IF li_nalez > 0 THEN 
			IF li_dodatek > 0 THEN ls_dodatky = MID (ls_a, li_dodatek - 1)
			IF li_potvrzeni > 0 THEN
				ls_nalez = MID (ls_a, li_nalez, li_potvrzeni - li_nalez)
			ELSE
				ls_nalez = MID (ls_a, li_nalez)
			END IF
		END IF
		IF ls_dodatky <> "" THEN
			ls_dodpitva = ls_dodatky
			li_a = POS (ls_a, "Datum potvrzení: ")
			IF li_a > 0 THEN
				ls_xx = MID (ls_a, li_a + LEN ("Datum potvrzení: "))
				ldt_a = wf_datcas (ls_xx)
				ld_vys = Date (ldt_a)
				lt_vys = Time (ldt_a)
			END IF
			li_a = POS (ls_a, "Potvrzující lékař: ")
			IF li_a > 0 THEN
				ls_xx = MID (ls_a, li_a + LEN ("Potvrzující lékař: "))
				li_a = POS (ls_xx, "Dodatek")
				IF li_a > 0 THEN ls_xx = TRIM (LEFT (ls_xx, li_a - 2))
				IF Right (ls_xx, 1) = "~n" THEN ls_xx = LEFT (ls_xx, LEN (ls_xx) - 1)
				ls_xx = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_xx, "MUDr. ", ""))
				SELECT Count (*), MAX (c_dok) INTO :ll_poc, :li_a FROM dbo.personal WHERE prjm = :ls_xx;
				IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN 
					li_c_dok = li_a
				ELSE
					IF POS (ls_nelek, ls_xx) = 0 THEN
						IF ls_nelek <> "" THEN ls_nelek += ", "
						ls_nelek += ls_xx
					END IF
				END IF
			END IF
		END IF
		IF LEFT (ls_typvys, 1) = "P" THEN  //pro pitvu i uvolnujici
			li_c_uvolnil = 0
			li_r1 = POS (ls_interni, "Revidoval")
			li_r2 = POS (ls_interni, "Provedená vyšetření:")
			IF li_r1 > 0 AND li_r2 > 0 THEN
				ls_xx = LEFT (ls_interni, li_r2 - 1)
				ls_xx = TRIM (MID (ls_xx, li_r1 + LEN ("Revidoval")))
				ls_xx = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_xx, "~r~n", ""))
				ls_xx = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_xx, "~n", ""))
				IF LEN (ls_xx) > 0 THEN 
					ls_xx = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_xx, "MUDr. ", ""))
					SELECT Count (*), MAX (c_dok) INTO :ll_poc, :li_a FROM dbo.personal WHERE prjm = :ls_xx;
					IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN 
						li_c_uvolnil = li_a
					ELSE
						IF POS (ls_nelek, ls_xx) = 0 THEN
							IF ls_nelek <> "" THEN ls_nelek += ", "
							ls_nelek += ls_xx
						END IF
					END IF
				END IF
			END IF
		END IF
		ls_klinal = trim (gnv_app.inv_string.of_GlobalReplace (ls_klinal, "Klinická diagnóza: ", ""))
		IF LEFT (ls_klinal, 1) = "~r~n" THEN ls_klinal = MID (ls_klinal, 2)
		IF LEFT (ls_klinal, 1) = "~n" THEN ls_klinal = MID (ls_klinal, 2)
		ls_nalez = trim (gnv_app.inv_string.of_GlobalReplace (ls_nalez, ls_uvonalez + " ", ""))
		IF LEFT (ls_nalez, 1) = "~r~n" THEN ls_nalez = MID (ls_nalez, 2)
		IF LEFT (ls_nalez, 1) = "~n" THEN ls_nalez = MID (ls_nalez, 2)
		li_bloky = 0; li_skla = 0; li_poc_bs = 0
		IF li_materialy > 0 AND li_pristroje > 0 THEN
			li_bloky = wf_vytahni (MID (ls_a, li_materialy, li_pristroje - li_materialy), "blok - bloček")
			li_skla = wf_vytahni (MID (ls_a, li_materialy, li_pristroje - li_materialy), "sklo - sklo")
			IF ls_typvys = "C" THEN 
				li_poc_bs = li_skla
				li_skla = 0
			END IF
		END IF
		IF ls_rada = "N" THEN  //přidání dalšího textu pro pitvy
			li_a = POS (ls_interni, "Protokol:")
			IF li_a > 0 THEN
				ls_a = MID (ls_interni, li_a)
				IF LEFT (ls_a, 2) <> "~r~n" THEN ls_a = "~r~n" + ls_a
				ls_a = gnv_app.inv_string.of_GlobalReplace (ls_a, "~r~n~r~n~r~n", "~r~n")
				ls_a = gnv_app.inv_string.of_GlobalReplace (ls_a, "~n~n~n", "~n")
				ls_nalez += ls_a
			END IF
		END IF
		ls_kli_diag = ""
		IF li_klidg > 0 AND li_klinal > 0 THEN
			ls_kli_diag = MID (ls_a, li_klidg, li_klinal - li_klidg)
			ls_kli_diag = gnv_app.inv_string.of_GlobalReplace (ls_kli_diag, "Diagnóza: ", "")
		END IF
		ls_lekar = ""
		IF li_zadatel > 0 AND li_klidg > 0 THEN
			ls_lekar = wf_lekar (MID (ls_a, li_zadatel, li_klidg - li_zadatel), "Lékař:")
			IF LEN (ls_lekar) > 50 THEN ls_lekar = LEFT (ls_lekar, 50)
		END IF
		ll_idvysetr = 0
		SELECT Count (*), MAX (idvysetr) INTO :ll_poc, :ll_idvysetr FROM dbo.vysetr WHERE rok = :li_rok AND cislo = :ll_cislo;
		IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
			IF as_parm = "" THEN //není režim přidání výkonů
				ll_dupl ++
				IF LEN (ls_dupl) > 0 THEN ls_dupl += ", "
				ls_dupl += ls_cisdupl
				SELECT klislo INTO :ls_klislo FROM dbo.vysetr WHERE cislo = :ll_cislo AND rok = :li_rok;
				SQLCA.of_Chyba (0, 0)
				IF LEN (ls_klislo) > 0 THEN 
					ls_klislo += ", duplicita"
				ELSE
					ls_klislo = "duplicita"
				END IF
				UPDATE dbo.vysetr SET klislo = :ls_klislo WHERE cislo = :ll_cislo AND rok = :li_rok;
				SQLCA.of_Chyba (0, 0)
				SQLCA.of_Commit ()
				CONTINUE
			END IF
		ELSE
			SELECT odb, ozn INTO :ls_odeodb, :ls_klinika FROM Dbo.kliniky WHERE cislo = :li_c_odeslal;
			SQLCA.of_Chyba (0, 100)
			ls_diag = ""
			SELECT Count (*), MAX (kod) INTO :ll_poc, :ls_dg FROM dbo.vysdg WHERE idvys = :ll_idvys and poradi = 1 USING SQLZIS;
			IF SQLZIS.of_Chyba (0, 100) = 0 AND ll_poc = 1 THEN ls_diag = ls_dg
			ls_stav = "Z"; ls_stavvys = '9'; li_blokace = 1; li_bloknal = 1; li_tisk = 1; li_tisk_archiv = 1; li_xml = 1
			IF li_potvrzeni = 0 THEN 
				ls_stav = "K"; ls_stavvys = '3'; li_blokace = 0; li_bloknal = 0; li_tisk = 0; li_tisk_archiv = 0; li_xml = 0 
			END IF
			IF ls_lekar <> "" AND cbx_lekari.Checked THEN 
				ll_lek += wf_lekar_zaloz (li_c_odeslal, ls_lekar)
			END IF
			ls_klinal = gnv_app.inv_string.of_GlobalReplace (ls_klinal, Char (10), Char (13) + Char (10))
			ls_klinal = gnv_app.inv_string.of_GlobalReplace (ls_klinal, Char (13) + Char (13) + Char (10), Char (13) + Char (10))
			ls_nalez = gnv_app.inv_string.of_GlobalReplace (ls_nalez, Char (10), Char (13) + Char (10))
			ls_nalez = gnv_app.inv_string.of_GlobalReplace (ls_nalez, Char (13) + Char (13) + Char (10), Char (13) + Char (10))
			do while Right (ls_nalez, 1) = Char (10) OR Right (ls_nalez, 1) = Char (13)
				ls_nalez = LEFT (ls_nalez, LEN (ls_nalez) - 1)
			loop
			IF ls_typvys = "P" THEN //odstranění konce od Orgány:
				li_a = POS (ls_nalez, "Orgány:")
				IF li_a > 0 THEN ls_nalez = LEFT (ls_nalez, li_a - 1)
			END IF
			IF ls_typvys = "P" AND IsNull (ld_prijem) THEN ls_typvys = "PN"
			IF ls_typvys = "P" AND li_c_uvolnil = 0 THEN li_c_uvolnil = li_c_dok
			INSERT INTO dbo.vysetr (cislo, rok, typvys, rc, prjm, pohlavi, kasa, odber, prijem, vysetr, 
				c_odeslal, odeslal, icp, odeodb, poc_bloky, primarni_vzorek, vzorek, nalez, stav, stavvys, 
				blokace, blok_nal, tisk, tisk_archiv, xml, labor_pozn,
				c_dok, zaver, diag, kli_diag, platba, informace, barzkrjm, hlazkrjm, zkrjmv, zkrjm, klislo, lekar,
				makrofoto, parblo, odber_cas, prijem_cas, vysetr_cas, poc_bloky6, klinal, c_uvolnil, c_rescreen, c_prikrojil, poc_bs)
				VALUES (:ll_cislo, :li_rok, :ls_typvys, :ls_rc, :ls_prjm, :ls_pohlavi, :ls_kasa, :ld_odber, :ld_prijem, :ld_vysetr, 
				:li_c_odeslal, :ls_odeslal, :ls_icp, :ls_odeodb, 0, :ls_primarni_vzorek, :ls_vzorek, :ls_nalez, :ls_stav, :ls_stavvys, 
				:li_blokace, :li_bloknal, :li_tisk, :li_tisk_archiv, :li_xml, :ls_soubor,
				:li_c_dok, '', :ls_diag, :ls_diag, :ls_platba, :ls_informace, 0, 0, 0, 0, :ls_klislo, :ls_lekar,
				0, :li_bloky, :lt_odber_cas, :lt_prijem_cas, :lt_vysetr_cas, :li_skla, :ls_klinal, :li_c_uvolnil, 0, 0, :li_poc_bs);
			IF SQLCA.of_Chyba (0, 100) = 0 THEN
				SQLCA.of_Commit ()
				SELECT Count (*), MAX (idvysetr) INTO :ll_poc, :ll_idvysetr FROM Dbo.vysetr WHERE cislo = :ll_cislo AND rok = :li_rok;
				IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 AND ll_idvysetr > 0 THEN
					ll_ok ++
					//dodatky
					IF ls_dodatky <> "" THEN
						li_i = 1
						li_a = POS (ls_dodatky, "Dodatek")
						ls_dodatky = MID (ls_dodatky, li_a + LEN ("Dodatek 1:"))
						do while ls_dodatky <> ""
							li_a = POS (ls_dodatky, "Dodatek")
							IF li_a > 0 THEN
								ls_dodatek = LEFT (ls_dodatky, li_a - 1)
								ls_dodatky = MID (ls_dodatky, li_a + LEN ("Dodatek 1:"))
							ELSE
								ls_dodatek = ls_dodatky
								ls_dodatky = ""
							END IF
							ls_dodatek = gnv_app.inv_string.of_GlobalReplace (ls_dodatek, "~nDatum potvrzení", "~r~nDatum potvrzení")
							ls_dodatek = gnv_app.inv_string.of_GlobalReplace (ls_dodatek, "~nPotvrzující lékař", "~r~nPotvrzující lékař")
							Setnull (ld_a)
							ls_lekardod = ""
							li_uvo = 0
							li_a = POS (ls_dodatek, "Datum potvrzení: ")
							IF li_a > 0 THEN
								ls_a = LEFT (MID (ls_dodatek, li_a + LEN ("Datum potvrzení: ")), 16)
								ldt_a = wf_datcas (ls_a)
								ld_a = Date (ldt_a)
								lt_cas = Time (ldt_a)
								li_a = POS (ls_dodatek, "Potvrzující lékař: ")
								IF li_a > 0 THEN
									ls_lekardod = MID (ls_dodatek, li_a + LEN ("Potvrzující lékař: "))
									li_a = POS (ls_lekardod, "~r~n")
									IF li_a > 0 THEN
										ls_lekardod = LEFT (ls_lekardod, li_a -1)
									ELSE
										li_a = POS (ls_lekardod, "~n")
										IF li_a > 0 THEN ls_lekardod = LEFT (ls_lekardod, li_a -1)
									END IF
									IF LEN (ls_lekardod) > 100 THEN ls_lekardod = LEFT (ls_lekardod, 100)
									ls_lekardod = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_lekardod, CHAR(13)+CHAR(10), ""))
									ls_lekardod = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_lekardod, "~r~n", ""))
									ls_lekardod = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_lekardod, "~n", ""))
									ls_lekardod = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_lekardod, "~r", ""))
									ls_a = TRIM (gnv_app.inv_string.of_GlobalReplace (ls_lekardod, "MUDr. ", ""))
									SELECT Count (*), MAX (c_dok) INTO :ll_poc, :li_a FROM dbo.personal WHERE prjm = :ls_a;
									IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN li_uvo = li_a
									li_a = POS (ls_dodatek, "Datum potvrzení: ")
									ls_dodatek = LEFT (ls_dodatek, li_a - 1)
								END IF
							END IF
							IF ls_rada = "N" THEN
								ls_dodatek = ls_dodpitva
								ls_dodatky = ""
							END IF
							ls_dodatek = gnv_app.inv_string.of_GlobalReplace (ls_dodatek, Char (10), Char (13) + Char (10))
							ls_dodatek = gnv_app.inv_string.of_GlobalReplace (ls_dodatek, Char (13) + Char (13) + Char (10), Char (13) + Char (10))
							INSERT INTO dbo.sdeleni (idvysetr, typ, poradi, text, lekar, blokace, dne, c_dok, c_uvolnil, cas)
								VALUES (:ll_idvysetr, 'S', :li_i, :ls_dodatek, :ls_lekardod, 1, :ld_a, :li_uvo, :li_uvo, :lt_cas);
							IF SQLCA.of_Chyba (0, 0) = 0 THEN
								SQLCA.of_Commit ()
								li_i ++
								ll_dod ++
							ELSE
								SQLCA.of_Rollback ()
							END IF
						loop
						UPDATE dbo.vysetr SET stavvys = :ls_stavvys, tisk = :li_tisk, tisk_archiv = :li_tisk_archiv, xml = :li_xml WHERE idvysetr = :ll_idvysetr;
						IF SQLCA.of_Chyba (0, 0) = 0 THEN
							SQLCA.of_Commit ()
							UPDATE dbo.vysetr SET uzavreno = :ld_vys, uzavreno_cas = :lt_vys, vysetr = :ld_a, vysetr_cas = :lt_cas WHERE idvysetr = :ll_idvysetr;
							IF SQLCA.of_Chyba (0, 0) = 0 THEN
								SQLCA.of_Commit ()
							ELSE
								SQLCA.of_Rollback ()
							END IF
						ELSE
							SQLCA.of_Rollback ()
						END IF
						DELETE FROM dbo.stavy WHERE druh = 'V' AND id = :ll_idvysetr;
						IF SQLCA.of_Chyba (0, 0) = 0 THEN
							SQLCA.of_Commit ()
						ELSE
							SQLCA.of_Rollback ()
						END IF
					END IF
					//zápis Dg
					ll_pocdg = lds_dg.Retrieve (ll_idvys)
					for ll_j = 1 to ll_pocdg
						ls_dg = lds_dg.getItemString (ll_j, "kod")
						uf_zaloz_vykvys (ll_idvysetr, "G", ls_dg, 1, 0)
						ll_dg ++
					next
					//interni sdeleni
					INSERT INTO dbo.sdeleni (idvysetr, typ, poradi, text, lekar, blokace)
						VALUES (:ll_idvysetr, 'I', 1, :ls_interni, 'Stapro', 1);
					IF SQLCA.of_Chyba (0, 0) = 0 THEN
						SQLCA.of_Commit ()
					ELSE
						SQLCA.of_Rollback ()
					END IF
					//kopie vyšetření
					for ll_cis = ll_cislo + 1 to ll_cislodo
						ls_nal = "Viz. č. " + String (ll_cislo) + "/" + String (li_rok)
						INSERT INTO dbo.vysetr (cislo, rok, typvys, rc, prjm, pohlavi, kasa, odber, prijem, vysetr, 
							c_odeslal, odeslal, icp, odeodb, poc_bloky, primarni_vzorek, vzorek, nalez, stav, stavvys, 
							blokace, blok_nal, tisk, tisk_archiv, xml,
							c_dok, zaver, diag, kli_diag, platba, informace, barzkrjm, hlazkrjm, zkrjmv, zkrjm, klislo, lekar,
							makrofoto, parblo, odber_cas, prijem_cas, vysetr_cas, poc_bloky1, klinal, c_uvolnil, c_rescreen, c_prikrojil, poc_bs)
							VALUES (:ll_cis, :li_rok, :ls_typvys, :ls_rc, :ls_prjm, :ls_pohlavi, :ls_kasa, :ld_odber, :ld_prijem, :ld_vysetr, 
							:li_c_odeslal, :ls_odeslal, :ls_icp, :ls_odeodb, 0, :ls_primarni_vzorek, :ls_vzorek, :ls_nal, :ls_stav, :ls_stavvys, 
							:li_blokace, :li_bloknal, :li_tisk, :li_tisk_archiv, :li_xml,
							:li_c_dok, '', :ls_diag, :ls_diag, :ls_platba, :ls_informace, 0, 0, 0, 0, :ls_klislo, :ls_lekar,
							0, :li_bloky, :lt_odber_cas, :lt_prijem_cas, :lt_vysetr_cas, :li_skla, '', :li_c_dok, 0, 0, :li_poc_bs);
						IF SQLCA.of_Chyba (0, 100) = 0 THEN
							SQLCA.of_Commit ()
							ll_emp ++
							SELECT Count (*), MAX (idvysetr) INTO :ll_poc, :ll_id FROM Dbo.vysetr WHERE cislo = :ll_cis AND rok = :li_rok;
							IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 AND ll_id > 0 THEN
								INSERT INTO dbo.vazba (id1, id2) VALUES (:ll_idvysetr, :ll_id);
								IF SQLCA.of_Chyba (0, 0) = 0 THEN
									SQLCA.of_Commit ()
									INSERT INTO dbo.vazba (id2, id1) VALUES (:ll_idvysetr, :ll_id);
									IF SQLCA.of_Chyba (0, 0) = 0 THEN
										SQLCA.of_Commit ()
									ELSE
										SQLCA.of_Rollback ()
									END IF
								ELSE
									SQLCA.of_Rollback ()
								END IF
							END IF
						END IF
					next
					//CAVE
					SELECT Count (*) INTO :ll_poc FROM Dbo.rc WHERE rc = :ls_rc;
					IF NOT (SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0) THEN
						INSERT INTO dbo.rc (rc, cave) VALUES (:ls_rc, :ls_cave);
						IF SQLCA.of_Chyba (0, 0) = 0 THEN
							SQLCA.of_Commit ()
						ELSE
							SQLCA.of_Rollback ()
						END IF
					END IF
				END IF
			ELSE
				ll_err ++
			END IF
		END IF
		IF ll_idvysetr > 0 THEN  //doplnění výkonů
			SELECT Count (*) INTO :ll_poc FROM vykvys WHERE idvysetr = :ll_idvysetr AND druh = 'V';
			IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
				DELETE FROM vykvys WHERE idvysetr = :ll_idvysetr AND druh = 'V';
				IF SQLCA.of_Chyba (0, 0) = 0 THEN
					SQLCA.of_Commit ()
				ELSE
					SQLCA.of_Rollback ()
				END IF
			END IF
			IF li_materialy > 0 THEN
				ls_a = LEFT (ls_interni, li_materialy - 1)
				li_a = POS (ls_a, "Provedená vyšetření:")
				IF li_a > 0 THEN
					ls_a = MID (ls_a, li_a + LEN ("Provedená vyšetření:"))
					ls_o = ls_a
					li_a = POS (ls_a, " - ")
					do while li_a > 0 
						ls_zkr = TRIM (LEFT (ls_a, li_a - 1))
						ls_zkr = MID (ls_zkr, 2)  //je tam ještě odřádkování
						li_a = POS (ls_a, "x)")
						IF li_a > 0 THEN
							ls_poc = LEFT (ls_a, li_a - 1)
							ls_a = MID (ls_a, li_a + 2)
							ls_pocet = ""
							for li_i = LEN (ls_poc) to 1 step -1
								choose case MID (ls_poc, li_i, 1)
								case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"
									ls_pocet = MID (ls_poc, li_i, 1) + ls_pocet
								case else
									EXIT
								end choose
							next
							li_pocet = Integer (ls_pocet)
							ls_zkr = TRIM (ls_zkr)
							IF li_pocet > 0 THEN //nahrání výkonů
								SELECT Count (*), MAX (zkratka) INTO :ll_poc, :ls_zkratka FROM dbo.nazzkr WHERE zkratka = :ls_zkr OR puvzkr = :ls_zkr;
								IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
									IF ls_zkratka <> ls_zkr AND ls_zkratka <> "" THEN ls_zkr = ls_zkratka
									ll_zkr += wf_zkratka (ll_idvysetr, ls_zkr, li_pocet)
									IF IsNull (ld_vysetr) OR ld_vysetr > ld_vyk OR ls_stavvys <> '9' THEN   //založení výkonů zkratek
										ll_vyk += wf_vykony (ll_idvysetr, ls_zkr, li_pocet)
									END IF
								ELSE
									SELECT Count (*) INTO :ll_poc FROM dbo.vykony WHERE kod = :ls_zkr;
									IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
										uf_zaloz_vykvys (ll_idvysetr, 'V', ls_zkr, li_pocet, 0)
									ELSE
										wf_zkratka (ll_idvysetr, ls_zkr, li_pocet)
										IF POS (", " + ls_nezkr + ",", ", " + ls_zkr + ",") = 0 THEN
											IF ls_nezkr <> "" THEN ls_nezkr += ", "
											ls_nezkr += ls_zkr
										END IF
									END IF
								END IF
							END IF
							li_a = POS (ls_a, " - ")
						ELSE
							EXIT
						END IF
					loop
				END IF
				DELETE FROM dbo.zmeny WHERE druh = 'V' AND id = :ll_idvysetr;
				IF SQLCA.of_Chyba (0, 100) = 0 THEN
					SQLCA.of_Commit ()
				ELSE
					SQLCA.of_Rollback ()
				END IF
			END IF
		END IF
	next
	Destroy lds_dg
	SetPointer (Arrow!)
	w_frame.Event Pfc_Microhelp ("Hotovo")
	MessageBox ("Statistika", "Celkem načteno " + String (ll_pocet) + " záznamů.~r~n" + &
		"Celkem založeno " + String (ll_ok) + " nových vyšetření.~r~n" + &
		"Celkem založeno " + String (ll_dod) + " dodatků.~r~n" + &
		"Celkem založeno " + String (ll_emp) + " prázdných vyšetření ve vazbě.~r~n" + &
		"Celkem založeno " + String (ll_dg) + " záznamů Dg.~r~n" + &
		"Celkem založeno " + String (ll_zkr) + " balíčků.~r~n" + &
		"Celkem založeno " + String (ll_vyk) + " výkonů dle balíčků.~r~n" + &
		"Celkem založeno " + String (ll_lek) + " lékařů odesílajících zařízení.~r~n" + &
		"Celkem " + String (ll_dupl) + " duplicitních vyšetření.~r~n" + &
		"Celkem " + String (ll_kli) + " nedohledaných kliniků.~r~n" + &
		"Celkem " + String (ll_err) + " chyb při zpracování.")
	IF ll_dupl > 0 THEN
		MessageBox ("Duplicity", ls_dupl)
	END IF
	IF TRIM (ls_nezkr) <> "" THEN
		mle_1.text = ls_nezkr
		mle_1.SelectText (1, LEN (ls_nezkr))
		mle_1.Copy ()
		MessageBox ("Nedohledané zkratky v Clipboardu", ls_nezkr)
	END IF
	IF TRIM (ls_nelek) <> "" THEN
		mle_1.text = ls_nelek
		mle_1.SelectText (1, LEN (ls_nelek))
		mle_1.Copy ()
		MessageBox ("Nedohledaní lékaři v Clipboardu", ls_nelek)
	END IF
END IF

end subroutine

public function integer wf_zkratka (long al_idvysetr, string as_zkratka, integer ai_pocet);//založení balíčku
Long ll_pocet, ll_row, ll_idvykvys_txt, ll_poc
String ls_kod, ls_text
Integer li_automat 

//není to výkon ?
SELECT Count (*), MAX (naz) INTO :ll_poc, :ls_text FROM Dbo.vykony WHERE kod = :as_zkratka;
IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
	li_automat = 1
	IF LEN (ls_text) > 40 THEN ls_text = LEFT (ls_text, 40)
ELSE
	ll_row = dw_zkratky.Find ("UPPER (LEFT(zkratka, " + String (len (as_zkratka)) + ")) = '" + UPPER (as_zkratka) + "'", 1, dw_zkratky.RowCount ())
	IF ll_row = 0 THEN
		ll_row = dw_zkratky.Find ("UPPER (LEFT(puvzkr, " + String (len (as_zkratka)) + ")) = '" + UPPER (as_zkratka) + "'", 1, dw_zkratky.RowCount ())
	END IF
	IF ll_row > 0 THEN ls_text = LEFT (dw_zkratky.getItemString (ll_row, "popis"), 40)
END IF
IF IsNull (ls_text) THEN ls_text = ""
IF ls_text = "" THEN ls_text = "Neuvedeno"
SELECT Count (*), MAX (idvykvys_txt) INTO :ll_poc, :ll_idvykvys_txt FROM dbo.vykvys_txt WHERE text = :ls_text;
IF NOT (SQLZIS.of_Chyba (0, 100) = 0 AND ll_poc > 0) THEN
	INSERT INTO dbo.vykvys_txt (text) VALUES (:ls_text);
	SQLCA.of_chyba (0, 0)
	SQLCA.of_commit ()
	SELECT Count (*), MAX (idvykvys_txt) INTO :ll_poc, :ll_idvykvys_txt FROM dbo.vykvys_txt WHERE text = :ls_text;
	SQLCA.of_chyba (0, 0)
END IF
INSERT INTO dbo.vykvys (idvysetr, druh, kod, idvykvys_txt, pocet, ind, automat)
	VALUES (:al_idvysetr, 'B', :as_zkratka, :ll_idvykvys_txt, :ai_pocet, 'A', :li_automat);
IF SQLCA.of_Chyba (0, 0) = 0 THEN
	SQLCA.of_Commit ()
ELSE
	SQLCA.of_Rollback ()
	RETURN 0
END IF

RETURN 1

end function

public function integer wf_vykony (long al_idvysetr, string as_zkratka, integer ai_pocet);//založení výkonů dle zkratek
Long ll_pocet, ll_row, ll_idvykvys_txt, ll_poc, ll_vyk, ll_i
String ls_kod, ls_text, ls_zkratka
Integer li_pocet

SELECT Count (*), MAX (zkratka) INTO :ll_poc, :ls_zkratka FROM dbo.nazzkr WHERE zkratka = :as_zkratka OR puvzkr = :as_zkratka;
IF SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
	dw_vykony.SetFilter ("UPPER (TRIM (zkratka)) = '" + TRIM (as_zkratka) + "' and druh = 'V'")
	dw_vykony.Filter ()
	ll_pocet = dw_vykony.RowCount ()
	for ll_i = 1 to ll_pocet
		ls_kod = dw_vykony.getItemString (ll_i, "kod")
		li_pocet = dw_vykony.getItemNumber (ll_i, "pocet") * ai_pocet
		ll_idvykvys_txt = dw_vykony.getItemNumber (ll_i, "idvykvys_txt")
		INSERT INTO dbo.vykvys (idvysetr, druh, kod, idvykvys_txt, pocet, ind, automat)
			VALUES (:al_idvysetr, 'V', :ls_kod, :ll_idvykvys_txt, :li_pocet, 'A', 1);
		IF SQLCA.of_Chyba (0, 0) = 0 THEN 
			SQLCA.of_Commit ()
			ll_vyk ++
		ELSE
			SQLCA.of_Rollback ()
		END IF
	next
END IF

RETURN ll_vyk
end function

public function integer wf_lekar_zaloz (integer ai_cislo, string as_lekar);//Založení lékaře u kliniky
String ls_prjm, ls_titul, ls_tituly [] = {"MUDR.", "PRIM.MUDr.", "PRIM. MUDr.", "DR.", "DOC.", "MUDR ", "PRIM "}
Integer li_i, li_poc, li_len
Long ll_poc

ls_prjm = as_lekar
li_poc = UpperBound (ls_tituly)
for li_i = 1 to li_poc
	li_len = LEN (ls_tituly [li_i])
	IF LEFT (UPPER (ls_prjm), li_len) = UPPER (ls_tituly [li_i]) THEN 
		ls_titul = TRIM (LEFT (ls_prjm, li_len))
		ls_prjm = TRIM (MID (ls_prjm, li_len + 1))
	END IF
next
SELECT Count (*) INTO :ll_poc FROM dbo.lekari WHERE cislo = :ai_cislo AND prjm = :ls_prjm;
IF NOT (SQLCA.of_Chyba (0, 100) = 0 AND ll_poc > 0) THEN
	INSERT INTO dbo.lekari (cislo, prjm, titul) VALUES (:ai_cislo, :ls_prjm, :ls_titul);
	IF SQLCA.of_Chyba (0, 0) = 0 THEN
		SQLCA.of_Commit ()
		RETURN 1
	ELSE
		SQLCA.of_Rollback ()
	END IF
END IF
RETURN 0
end function

public function datetime wf_datcas (string as_par);//vrací vytažený datum a čas
String ls_a, ls_vr
Integer li_a

ls_a = as_par
li_a = POS (ls_a, " ")
IF li_a > 0 THEN
	ls_vr = LEFT (ls_a, li_a) + " "
	ls_a = MID (ls_a, li_a + 1)
	ls_vr += gnv_app.inv_string.of_GetToken (ls_a, ":") + ":"
	ls_vr += gnv_app.inv_string.of_GetToken (ls_a, ":") 
END IF

RETURN DateTime (ls_vr)
end function

event resize;call super::resize;dw_data.width = newwidth - 10
dw_data.height = newheight - 10 - dw_data.y


end event

on w_vys_old.create
int iCurrent
call super::create
if this.MenuName = "m_vys" then this.MenuID = create m_vys
this.cb_lekari=create cb_lekari
this.cb_pitvy=create cb_pitvy
this.mle_1=create mle_1
this.cbx_lekari=create cbx_lekari
this.dw_vykony=create dw_vykony
this.st_4=create st_4
this.em_vyk=create em_vyk
this.st_3=create st_3
this.st_2=create st_2
this.dw_zkratky=create dw_zkratky
this.ddlb_typ=create ddlb_typ
this.cbx_cave=create cbx_cave
this.cb_zaznam=create cb_zaznam
this.cb_cave=create cb_cave
this.sle_vzorek=create sle_vzorek
this.em_primarni_vzorek=create em_primarni_vzorek
this.st_1=create st_1
this.st_zaz=create st_zaz
this.cb_zrus=create cb_zrus
this.cb_export=create cb_export
this.cb_nacti=create cb_nacti
this.cb_storno=create cb_storno
this.dw_data=create dw_data
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_lekari
this.Control[iCurrent+2]=this.cb_pitvy
this.Control[iCurrent+3]=this.mle_1
this.Control[iCurrent+4]=this.cbx_lekari
this.Control[iCurrent+5]=this.dw_vykony
this.Control[iCurrent+6]=this.st_4
this.Control[iCurrent+7]=this.em_vyk
this.Control[iCurrent+8]=this.st_3
this.Control[iCurrent+9]=this.st_2
this.Control[iCurrent+10]=this.dw_zkratky
this.Control[iCurrent+11]=this.ddlb_typ
this.Control[iCurrent+12]=this.cbx_cave
this.Control[iCurrent+13]=this.cb_zaznam
this.Control[iCurrent+14]=this.cb_cave
this.Control[iCurrent+15]=this.sle_vzorek
this.Control[iCurrent+16]=this.em_primarni_vzorek
this.Control[iCurrent+17]=this.st_1
this.Control[iCurrent+18]=this.st_zaz
this.Control[iCurrent+19]=this.cb_zrus
this.Control[iCurrent+20]=this.cb_export
this.Control[iCurrent+21]=this.cb_nacti
this.Control[iCurrent+22]=this.cb_storno
this.Control[iCurrent+23]=this.dw_data
end on

on w_vys_old.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_lekari)
destroy(this.cb_pitvy)
destroy(this.mle_1)
destroy(this.cbx_lekari)
destroy(this.dw_vykony)
destroy(this.st_4)
destroy(this.em_vyk)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.dw_zkratky)
destroy(this.ddlb_typ)
destroy(this.cbx_cave)
destroy(this.cb_zaznam)
destroy(this.cb_cave)
destroy(this.sle_vzorek)
destroy(this.em_primarni_vzorek)
destroy(this.st_1)
destroy(this.st_zaz)
destroy(this.cb_zrus)
destroy(this.cb_export)
destroy(this.cb_nacti)
destroy(this.cb_storno)
destroy(this.dw_data)
end on

event pfc_postopen;call super::pfc_postopen;Date ld_a

ld_a = Today ()
IF Day (ld_a) < 5 THEN ld_a = RelativeDate (ld_a, -30)
em_vyk.text = "01." + String (ld_a, "mm.yyyy")
//cb_nacti.Event Clicked ()
em_primarni_vzorek.text = ""
sle_vzorek.text = ""
dw_zkratky.Retrieve ()
dw_vykony.Retrieve ()

end event

type cb_lekari from u_cb within w_vys_old
integer x = 2697
integer y = 16
integer width = 315
integer taborder = 30
string text = "Lékaři ?"
end type

event clicked;call super::clicked;Long lL_pocet, ll_i, ll_poc, ll_ne
String ls_lekar, ls_nelek, ls_a

IF MessageBox ("Dotaz", "Zobrazit nedohledané lékaře dle uvedených čísel ?", Question!, YesNo!) = 1 THEN
	SetPointer (HourGlass!)
	ll_pocet = dw_data.RowCount ()
	for ll_i = 1 to ll_pocet
		ls_lekar = String (dw_data.getItemNumber (ll_i, "c_lekar"))
		IF ls_lekar = "" THEN
			ll_ne ++
		ELSE
			ls_a = "%" + ls_lekar + "%"
			SELECT Count (*) INTO :ll_poc FROM Dbo.personal WHERE fax LIKE :ls_a OR informace LIKE :ls_a;
			IF NOT (SQLCA.of_Chyba (0, 100) = 0 AND ll_poc = 1) THEN 
				IF POS (ls_nelek, ls_lekar) = 0 THEN
					IF ls_nelek <> "" THEN ls_nelek += ", "
					ls_nelek += ls_lekar
				END IF
			END IF
		END IF
	next
	ls_a = ""
	IF ll_ne > 0 THEN ls_a =  "Neuvedený lékař u " + String (ll_ne) + " záznamů.~r~n~r~n"
	IF ls_nelek <>"" THEN ls_a += "Nenalezené kódy: " + ls_nelek
	IF ls_a = "" THEN ls_a = "Vše v pořádku."
	SetPointer (Arrow!)
	MessageBox ("Info", ls_a)
END IF
dw_data.SetFocus ()

end event

type cb_pitvy from u_cb within w_vys_old
integer x = 2331
integer y = 16
integer width = 347
integer taborder = 40
string text = "Pouze pitvy"
end type

event clicked;call super::clicked;IF MessageBox ("Dotaz", "Zobrazit pouze pitvy ?", Question!, YesNo!) = 1 THEN
	dw_data.SetFilter ("typvys='Nekropsie'")
	dw_data.Filter ()
	ib_pitvy = TRUE
END IF
dw_data.SetFocus ()

end event

type mle_1 from u_mle within w_vys_old
integer x = 1975
integer y = 820
integer height = 252
integer taborder = 60
end type

type cbx_lekari from u_cbx within w_vys_old
integer x = 837
integer y = 128
integer width = 462
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Lékaři zařízení"
boolean checked = true
end type

type dw_vykony from u_dw within w_vys_old
integer x = 571
integer y = 1080
integer width = 1216
integer taborder = 60
string dataobject = "d_zkratky"
end type

event constructor;call super::constructor;This.of_SetTransObject (SQLCA)

end event

type st_4 from u_st within w_vys_old
integer x = 2071
integer y = 128
integer width = 366
integer height = 72
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "+ neuzavřené"
end type

type em_vyk from u_em within w_vys_old
integer x = 1609
integer y = 124
integer width = 430
integer height = 84
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
alignment alignment = center!
maskdatatype maskdatatype = datemask!
string mask = "dd.mm.yyyy"
boolean dropdowncalendar = true
end type

type st_3 from u_st within w_vys_old
integer x = 1280
integer y = 132
integer width = 315
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Výkony po:"
alignment alignment = right!
end type

type st_2 from u_st within w_vys_old
integer x = 256
integer y = 132
integer width = 325
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Generovat:"
alignment alignment = right!
end type

type dw_zkratky from u_dw within w_vys_old
integer x = 571
integer y = 784
integer width = 1216
integer taborder = 50
string dataobject = "d_nazzkr"
end type

event constructor;call super::constructor;This.of_SetTransObject (SQLCA)

end event

type ddlb_typ from u_ddlb within w_vys_old
integer x = 603
integer y = 16
integer width = 480
integer height = 272
integer taborder = 40
integer textsize = -9
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Vyšetření"
boolean sorted = false
string item[] = {"Vyšetření","Výkony"}
end type

type cbx_cave from u_cbx within w_vys_old
integer x = 603
integer y = 128
integer width = 233
integer height = 68
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Cave"
boolean checked = true
end type

type cb_zaznam from u_cb within w_vys_old
integer x = 1993
integer y = 16
integer width = 320
integer taborder = 20
string text = "Záznam č."
end type

event clicked;call super::clicked;IF dw_data.RowCount () > 0 THEN Open (w_zaznam)

end event

type cb_cave from u_cb within w_vys_old
integer x = 1605
integer y = 16
integer width = 370
integer taborder = 30
string text = "Zrušit CAVE"
end type

event clicked;call super::clicked;
IF MessageBox ("Dotaz", "Skutečně chcete zrušit údaje CAVE ?", Question!, yesNo!) = 1 THEN
	SetPointer (HourGlass!)
	DELETE FROM dbo.rc;
	IF SQLCA.of_chyba (0, 0) = 0 THEN
		SQLCA.of_Commit ()
		SetPointer (Arrow!)
		MessageBox ("Info", "Veškeré údaje CAVE byly zrušeny.")
	ELSE
		SQLCA.of_Rollback ()
		SetPointer (Arrow!)
		MessageBox ("Chyba", "Údaje CAVE nebyly zrušeny.")
	END IF
END IF	

end event

type sle_vzorek from u_sle within w_vys_old
integer x = 2921
integer y = 120
integer width = 507
integer height = 84
integer taborder = 10
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
end type

type em_primarni_vzorek from u_em within w_vys_old
integer x = 2706
integer y = 120
integer width = 197
integer height = 84
integer taborder = 60
integer textsize = -10
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
alignment alignment = center!
maskdatatype maskdatatype = stringmask!
string mask = "!!!"
end type

type st_1 from u_st within w_vys_old
integer x = 2542
integer y = 128
integer width = 142
integer textsize = -9
integer weight = 700
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "PV:"
alignment alignment = right!
end type

type st_zaz from u_st within w_vys_old
integer x = 3031
integer y = 24
integer width = 654
string text = ""
end type

type cb_zrus from u_cb within w_vys_old
integer x = 1102
integer y = 16
integer width = 485
integer taborder = 40
string text = "Zrušit záznamy"
end type

event clicked;call super::clicked;Long ll_poc
String ls_typvys = "_", ls_a

IF ib_pitvy THEN
	ls_typvys = "P%"
	SELECT Count (*) INTO :ll_poc FROM Dbo.vysetr WHERE typvys LIKE :ls_typvys;
	ls_a = "Skutečně chcete zrušit celkem " + String (ll_poc) + " pitev ?"
ELSE
	ls_typvys = "%"
	SELECT Count (*) INTO :ll_poc FROM Dbo.vysetr WHERE typvys LIKE :ls_typvys;
	ls_a = "Skutečně chcete zrušit celkem " + String (ll_poc) + " vyšetření ?"
END IF
SQLCA.of_Chyba (0, 100)
IF ll_poc = 0 THEN
	MessageBox ("Info", "Tabulka neobsahuje žádná vyšetření.")
ELSE
	IF MessageBox ("Dotaz", ls_a, Question!, yesNo!) = 1 THEN
		SetPointer (HourGlass!)
		UPDATE dbo.vysetr SET stavvys = '6' WHERE stavvys = '9' AND typvys LIKE :ls_typvys;
		IF SQLCA.of_chyba (0, 0) = 0 THEN
			SQLCA.of_Commit ()
			DELETE FROM dbo.vysetr WHERE typvys LIKE :ls_typvys;
			IF SQLCA.of_chyba (0, 0) = 0 THEN
				SQLCA.of_Commit ()
				DELETE FROM dbo.ruseni;
				IF SQLCA.of_chyba (0, 0) = 0 THEN
					SQLCA.of_Commit ()
				ELSE
					SQLCA.of_Rollback ()
				END IF
				SetPointer (Arrow!)
				MessageBox ("Info", "Veškerá vyšetření byla zrušena.")
			ELSE
				SQLCA.of_Rollback ()
				SetPointer (Arrow!)
				MessageBox ("Chyba", "Vyšetření nebyla zrušena.")
			END IF
		ELSE
			SQLCA.of_Rollback ()
			SetPointer (Arrow!)
			MessageBox ("Chyba", "Chyba změny stavu.")
		END IF
	END IF
END IF
end event

type cb_export from u_cb within w_vys_old
integer x = 315
integer y = 16
integer width = 270
integer taborder = 20
boolean enabled = false
string text = "Export"
end type

event clicked;call super::clicked;choose case LEFT (ddlb_typ.text, 3)
case "Vyš"
	wf_biopsie ("")
case "Výk"
	wf_biopsie ("V")
case else
	MessageBox ("Chyba", "Nevím co mám dělat." ,Exclamation!)
end choose

end event

type cb_nacti from u_cb within w_vys_old
integer y = 16
integer width = 297
integer taborder = 10
string text = "Načíst"
end type

event clicked;call super::clicked;choose case LEFT (ddlb_typ.text, 1)
case "V"
	dw_data.DataObject = "d_vysetr"
case "D"
	dw_data.DataObject = "d_vykvys"
case else
	MessageBox ("Chyba", "Neznám.", Exclamation!)
	RETURN
end choose
dw_data.Event Constructor ()
IF dw_data.Event Pfc_Retrieve () > 0 THEN
	cb_export.Enabled = TRUE
END IF

end event

type cb_storno from u_cb_storno within w_vys_old
integer x = 178
integer y = 272
integer taborder = 40
end type

type dw_data from u_dw within w_vys_old
integer y = 220
integer width = 2491
integer height = 508
integer taborder = 40
boolean bringtotop = true
string dataobject = "d_vysetr"
boolean hscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = stylebox!
boolean ib_excel = true
end type

event constructor;call super::constructor;This.of_SetTransObject (SQLZIS)
This.of_SetUpdateAble (FALSE)
This.SetRowFocusIndicator (hand!)
ib_excel = TRUE
This.of_SetSort (TRUE)
This.inv_sort.of_SetColumnHeader (TRUE)


end event

event pfc_retrieve;call super::pfc_retrieve;Long ll_pocet

SetPointer (HourGlass!)
ll_pocet = This.Retrieve ()
This.SetFocus ()
SetPointer (Arrow!)

RETURN ll_pocet
	

end event

event rowfocuschanged;call super::rowfocuschanged;st_zaz.text = "Věta č." + String (This.GetRow ()) + " z " + String (This.RowCount ())
end event

