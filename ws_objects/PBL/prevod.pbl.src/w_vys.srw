$PBExportHeader$w_vys.srw
forward
global type w_vys from w_sheet
end type
type ddlb_typ from u_ddlb within w_vys
end type
type mle_1 from u_mle within w_vys
end type
type cb_zaznam from u_cb within w_vys
end type
type st_zaz from u_st within w_vys
end type
type cb_zrus from u_cb within w_vys
end type
type cb_export from u_cb within w_vys
end type
type cb_nacti from u_cb within w_vys
end type
type cb_storno from u_cb_storno within w_vys
end type
type dw_data from u_dw within w_vys
end type
end forward

global type w_vys from w_sheet
string tag = "w_vys"
integer x = 214
integer y = 221
integer width = 5138
integer height = 2252
string title = "Převod vyšetření"
string menuname = "m_vys"
ddlb_typ ddlb_typ
mle_1 mle_1
cb_zaznam cb_zaznam
st_zaz st_zaz
cb_zrus cb_zrus
cb_export cb_export
cb_nacti cb_nacti
cb_storno cb_storno
dw_data dw_data
end type
global w_vys w_vys

type variables
String is_biopsie = 'H', is_cytologie = 'C', is_pitva = 'P'

end variables

forward prototypes
public function date wf_datum (string as_a)
public function time wf_cas (string as_par)
public subroutine wf_biopsie ()
public subroutine wf_pitvy ()
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
	ls_r = MID (ls_a, 1, 4)
	ls_m = MID (ls_a, 5, 2)
	ls_d = MID (ls_a, 7, 2)
END IF
IF IsDate (ls_d + "." + ls_m + "." + ls_r) THEN 
	IF Integer (ls_r) < Year (Today ()) - 2000 THEN ls_r = "2" + MID (ls_r, 2)
	ld_n = Date (ls_d + "." + ls_m + "." + ls_r)
	IF Year (ld_n) > 1900 AND Year (ld_n) < 2050 THEN RETURN ld_n
END IF
Setnull (ld_n)
RETURN ld_n
	

end function

public function time wf_cas (string as_par);//vrací čas
String ls_a

IF POS (as_par, "-") > 0 THEN
	RETURN Time (gnv_app.inv_string.of_GlobalReplace (as_par, "-", ":"))
END IF
RETURN Time (LEFT (as_par, 2) + ":" + MID (as_par, 3, 2))


end function

public subroutine wf_biopsie ();Long ll_pocet, ll_row, ll_i, ll_ok, ll_dupl, ll_err, ll_cislo, ll_poc, ll_idvysetr
String ls_dupl, ls_a, ls_id, ls_rc, ls_prjm, ls_klinal, ls_fixace, ls_kli_diag, ls_odeslal
String ls_icp, ls_odeodb,	ls_makro, ls_nalez, ls_informace, ls_kasa, ls_typvys, ls_fixace_puv
String ls_stav, ls_stavvys, ls_pohlavi, ls_primarni_vzorek, ls_vzorek, ls_platba, ls_diag
String ls_klislo, ls_lekar
Integer li_odp, li_rok, li_poc_bloky, li_parblo, li_poc_bloky1, li_c_odeslal, li_c_dok, li_blokace, li_bloknal
Integer li_tisk, li_tisk_archiv, li_xml, li_poc_bs, li_c_uvolnil, li_a
Date ld_odber, ld_prijem, ld_vysetr
Time lt_prijem_cas, lt_vysetr_cas, lt_odber_cas

ll_pocet = dw_data.RowCount ()
IF MessageBox ("Dotaz", "Skutečně chcete načíst celkem " + String (ll_pocet) + " vyšetření ?", Question!, YesNo!) = 1 THEN
	SetPointer (HourGlass!)
	ll_row = dw_data.getRow ()
	IF ll_row > 1 THEN
		li_odp = MessageBox ("Dotaz", "Skutečně začít od záznamu č." + String (ll_row) + " (XML = " + dw_data.getItemString (ll_row, "soubor") + "') ?", Question!, YesnoCancel!)
		IF li_odp = 2 THEN ll_row = 1
		IF li_odp = 3 THEN RETURN
	END IF
	SQLCA.of_Execute ("SET QUOTED_IDENTIFIER ON")
	SetNull (lt_odber_cas)
	for ll_i = ll_row to ll_pocet
		Yield ()
		w_frame.Event Pfc_Microhelp ("Zpracovávám záznam č. " + String (ll_i) + " z celkového počtu " + String (ll_pocet))
		ls_id = dw_data.GetItemString (ll_i, "id")
		ls_rc = dw_data.GetItemString (ll_i, "rc")
		ls_prjm = dw_data.GetItemString (ll_i, "prjm")
		ls_typvys = dw_data.GetItemString (ll_i, "typvys")
		ll_cislo = dw_data.GetItemNumber (ll_i, "cislo")
		IF ll_cislo > 9999999 THEN  //odstranění přetečení se zachováním první pozice
			ls_a = String (ll_cislo)
			ll_cislo = Long (LEFT (ls_a, 1) + MID (ls_a, 3))
		END IF
		ld_odber = wf_datum (dw_data.GetItemString (ll_i, "odber"))
		ld_prijem = wf_datum (dw_data.GetItemString (ll_i, "prijem"))
		li_rok = Year (ld_prijem)
		lt_prijem_cas = wf_cas (dw_data.GetItemString (ll_i, "prijem_cas"))
		ld_vysetr = wf_datum (dw_data.GetItemString (ll_i, "vysetr"))
		lt_vysetr_cas = wf_cas (dw_data.GetItemString (ll_i, "vysetr_cas"))
		ls_klinal = dw_data.GetItemString (ll_i, "klinal")
		ls_fixace = dw_data.GetItemString (ll_i, "fixace")
		IF LEFT (ls_fixace, 4) = "form" THEN 
			ls_fixace = "F"
			ls_fixace_puv = ""
		ELSE
			ls_fixace_puv = ls_fixace
			ls_fixace = UPPER (LEFT (ls_fixace, 1))
		END IF
		li_poc_bloky = Integer (dw_data.GetItemString (ll_i, "poc_bloky"))
		li_parblo = Integer (dw_data.GetItemString (ll_i, "parblo"))
		li_poc_bloky1 = Integer (dw_data.GetItemString (ll_i, "poc_bloky1"))
		ls_kli_diag = dw_data.GetItemString (ll_i, "kli_diag")
		ls_diag = LEFT (ls_kli_diag, 5)
		li_c_odeslal = Integer (dw_data.GetItemString (ll_i, "c_odeslal"))
		ls_odeslal = dw_data.GetItemString (ll_i, "odeslal")
		ls_icp = dw_data.GetItemString (ll_i, "icp")
		ls_odeodb = dw_data.GetItemString (ll_i, "odeodb")
		li_c_dok = dw_data.GetItemNumber (ll_i, "c_lekar")
		li_c_uvolnil = li_c_dok
		ls_makro = TRIM (dw_data.GetItemString (ll_i, "makro"))
		ls_nalez = dw_data.GetItemString (ll_i, "nalez")
		IF ls_typvys = "HB" THEN
			IF LEN (ls_makro) > 0 THEN
				ls_makro = "Nález makroskopický:~r~n~r~n" + ls_makro
				IF Right (ls_makro, 2) = "~r~n~r~n" THEN
				ELSEIF Right (ls_makro, 2) = "~r~n" THEN
					ls_makro += "~r~n"
				ELSE
					ls_makro += "~r~n~r~n"
				END IF
			END IF
			ls_nalez = ls_makro + "Nález histopatologický:~r~n~r~n" + ls_nalez
		ELSE
			ls_nalez = "Nález:~r~n~r~n" + ls_nalez
		END IF
		ls_informace = dw_data.GetItemString (ll_i, "poznamka")
		ls_kasa = dw_data.GetItemString (ll_i, "kasa")
		ls_informace = ls_id + "; " + ls_informace
		IF ls_fixace_puv <> "" THEN ls_informace += "; fixace: " + ls_fixace_puv
		ls_platba = 'D'
		ls_stav = 'Z'; ls_stavvys = '9'; li_blokace = 1; li_bloknal = 1; li_tisk = 1; li_tisk_archiv = 1; li_xml = 1
		IF IsNull (ld_vysetr) THEN
			ls_stav = 'K'; ls_stavvys = '6'; li_blokace = 0; li_bloknal = 0; li_tisk = 0; li_tisk_archiv = 0; li_xml = 0
		END IF
		ls_pohlavi = "F"
		IF POS ("56", MID (ls_rc, 3, 1)) > 0 THEN ls_pohlavi = "M"
		//odesílající
		li_c_odeslal = 0
		SELECT Count (*), MAX (cislo) INTO :ll_poc, :li_a FROM Dbo.kliniky WHERE icp = :ls_icp;
		IF SQLCA.of_Chyba (0, 100) = 0 AND lL_poc > 0 AND li_a > 0 THEN li_c_odeslal = li_a
		SELECT Count (*) INTO :ll_poc FROM Dbo.vysetr WHERE cislo = :ll_cislo AND rok = :li_rok;
		IF SQLZIS.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
			ll_dupl ++
			ls_dupl += ", " + String (ll_cislo) + "/" + String (li_rok)
		ELSE
			INSERT INTO dbo.vysetr (cislo, rok, typvys, rc, prjm, pohlavi, kasa, odber, prijem, vysetr, 
				c_odeslal, odeslal, icp, odeodb, poc_bloky, primarni_vzorek, vzorek, nalez, stav, stavvys, 
				blokace, blok_nal, tisk, tisk_archiv, xml, labor_pozn, fixace,
				c_dok, zaver, diag, kli_diag, platba, informace, barzkrjm, hlazkrjm, zkrjmv, zkrjm, klislo, lekar,
				makrofoto, parblo, odber_cas, prijem_cas, vysetr_cas, poc_bloky1, klinal, c_uvolnil, c_rescreen, c_prikrojil, poc_bs)
				VALUES (:ll_cislo, :li_rok, :ls_typvys, :ls_rc, :ls_prjm, :ls_pohlavi, :ls_kasa, :ld_odber, :ld_prijem, :ld_vysetr, 
				:li_c_odeslal, :ls_odeslal, :ls_icp, :ls_odeodb, :li_poc_bloky, :ls_primarni_vzorek, :ls_vzorek, :ls_nalez, :ls_stav, :ls_stavvys, 
				:li_blokace, :li_bloknal, :li_tisk, :li_tisk_archiv, :li_xml, '', :ls_fixace,
				:li_c_dok, '', :ls_diag, :ls_kli_diag, :ls_platba, :ls_informace, 0, 0, 0, 0, :ls_klislo, :ls_lekar,
				0, :li_parblo, :lt_odber_cas, :lt_prijem_cas, :lt_vysetr_cas, :li_poc_bloky1, :ls_klinal, :li_c_uvolnil, 0, 0, :li_poc_bs);
			IF SQLCA.of_Chyba (0, 100) = 0 THEN
				ll_ok ++
				SQLCA.of_Commit ()
			ELSE
				ll_err ++
				SQLCA.of_Rollback ()
			END IF
		END IF
	next
	SetPointer (Arrow!)
	w_frame.Event Pfc_Microhelp ("Hotovo")
	MessageBox ("Statistika", "Celkem načteno " + String (ll_pocet) + " záznamů.~r~n" + &
		"Celkem založeno " + String (ll_ok) + " nových vyšetření.~r~n" + &
		"Celkem " + String (ll_dupl) + " duplicitních vyšetření.~r~n" + &
		"Celkem " + String (ll_err) + " chyb při zpracování.")
	IF ll_dupl > 0 THEN MessageBox ("Duplicity", MID (ls_dupl, 3))
END IF

end subroutine

public subroutine wf_pitvy ();Long ll_pocet, ll_row, ll_i, ll_ok, ll_dupl, ll_err, ll_cislo, ll_poc, ll_idvysetr
String ls_dupl, ls_a, ls_id, ls_rc, ls_prjm, ls_kli_diag, ls_odeslal
String ls_icp, ls_odeodb,	ls_makropopis, ls_nalez, ls_informace, ls_kasa, ls_typvys
String ls_stav, ls_stavvys, ls_pohlavi, ls_primarni_vzorek, ls_vzorek, ls_platba, ls_diag
String ls_klislo, ls_lekar, ls_diagnozaklinicka, ls_diagnozapatologickoanatomicka, ls_epikriza
Integer li_hmotnosttela, li_mozek, li_srdce, li_pliceprava, li_pliceleva, li_slezina, li_ledvinaleva
Integer li_ledvinaprava, li_jatra, li_thymus, li_thyreoidea, li_pankreas, li_nadledvinka
String ls_hmotnostvolnytext1, ls_hmotnostvolnytext2, ls_histologie
Integer li_odp, li_rok, li_c_odeslal, li_c_dok, li_blokace, li_bloknal
Integer li_tisk, li_tisk_archiv, li_xml, li_poc_bs, li_c_uvolnil, li_a
Date ld_odber, ld_prijem, ld_vysetr
Time lt_prijem_cas, lt_vysetr_cas, lt_odber_cas

ll_pocet = dw_data.RowCount ()
IF MessageBox ("Dotaz", "Skutečně chcete načíst celkem " + String (ll_pocet) + " pitev ?", Question!, YesNo!) = 1 THEN
	SetPointer (HourGlass!)
	ll_row = dw_data.getRow ()
	IF ll_row > 1 THEN
		li_odp = MessageBox ("Dotaz", "Skutečně začít od záznamu č." + String (ll_row) + " (XML = " + dw_data.getItemString (ll_row, "soubor") + "') ?", Question!, YesnoCancel!)
		IF li_odp = 2 THEN ll_row = 1
		IF li_odp = 3 THEN RETURN
	END IF
	SQLCA.of_Execute ("SET QUOTED_IDENTIFIER ON")
	SetNull (lt_odber_cas)
	for ll_i = ll_row to ll_pocet
		Yield ()
		w_frame.Event Pfc_Microhelp ("Zpracovávám záznam č. " + String (ll_i) + " z celkového počtu " + String (ll_pocet))
		ls_id = dw_data.GetItemString (ll_i, "pitvy_id")
		ls_rc = dw_data.GetItemString (ll_i, "pitvy_rc")
		ls_prjm = dw_data.GetItemString (ll_i, "pitvy_prjm")
		ls_typvys = dw_data.GetItemString (ll_i, "typvys")
		ll_cislo = dw_data.GetItemNumber (ll_i, "cislo")
		IF ll_cislo > 9999999 THEN  //odstranění přetečení se zachováním první pozice
			ls_a = String (ll_cislo)
			ll_cislo = Long (LEFT (ls_a, 1) + MID (ls_a, 3))
		END IF
		ld_odber = wf_datum (dw_data.GetItemString (ll_i, "pitvy_odber"))
		ld_prijem = wf_datum (dw_data.GetItemString (ll_i, "pitvy_prijem"))
		li_rok = Year (ld_prijem)
		lt_prijem_cas = wf_cas (dw_data.GetItemString (ll_i, "pitvy_prijem_cas"))
		ld_vysetr = wf_datum (dw_data.GetItemString (ll_i, "vysetreni_vysetr"))
		lt_vysetr_cas = wf_cas (dw_data.GetItemString (ll_i, "vysetreni_vysetr_cas"))
		ls_kli_diag = dw_data.GetItemString (ll_i, "kli_diag")
		ls_diag = LEFT (ls_kli_diag, 5)
		li_c_odeslal = Integer (dw_data.GetItemString (ll_i, "c_odeslal"))
		ls_odeslal = dw_data.GetItemString (ll_i, "pitvy_odeslal")
		ls_icp = dw_data.GetItemString (ll_i, "pitvy_icp")
		ls_odeodb = dw_data.GetItemString (ll_i, "pitvy_odeodb")
		ls_diagnozaklinicka =  dw_data.GetItemString (ll_i, "diagnozaklinicka")
		ls_diagnozapatologickoanatomicka =  dw_data.GetItemString (ll_i, "diagnozapatologickoanatomicka")
		ls_epikriza =  dw_data.GetItemString (ll_i, "epikriza")
		ls_makropopis =  dw_data.GetItemString (ll_i, "makropopis")
		li_hmotnosttela =  Integer (dw_data.GetItemString (ll_i, "pitvy_hmotnosttela"))
		li_mozek =  Integer (dw_data.GetItemString (ll_i, "pitvy_mozek"))
		li_srdce =  Integer (dw_data.GetItemString (ll_i, "pitvy_srdce"))
		li_pliceprava =  Integer (dw_data.GetItemString (ll_i, "pitvy_pliceprava"))
		li_pliceleva =  Integer (dw_data.GetItemString (ll_i, "pitvy_pliceleva"))
		li_slezina =  Integer (dw_data.GetItemString (ll_i, "pitvy_slezina"))
		li_ledvinaleva =  Integer (dw_data.GetItemString (ll_i, "pitvy_ledvinaleva"))
		li_ledvinaprava =  Integer (dw_data.GetItemString (ll_i, "pitvy_ledvinaprava"))
		li_jatra =  Integer (dw_data.GetItemString (ll_i, "pitvy_jatra"))
		li_thymus =  Integer (dw_data.GetItemString (ll_i, "pitvy_thymus"))
		li_thyreoidea =  Integer (dw_data.GetItemString (ll_i, "pitvy_thyreoidea"))
		li_pankreas =  Integer (dw_data.GetItemString (ll_i, "pitvy_pankreas"))
		li_nadledvinka =  Integer (dw_data.GetItemString (ll_i, "pitvy_nadledvinka"))
		ls_hmotnostvolnytext1 =  dw_data.GetItemString (ll_i, "hmotnostvolnytext1")
		ls_hmotnostvolnytext2 =  dw_data.GetItemString (ll_i, "hmotnostvolnytext2")
		ls_histologie =  dw_data.GetItemString (ll_i, "histologie")
		li_c_dok = dw_data.GetItemNumber (ll_i, "c_lekar")
		li_c_uvolnil = li_c_dok
		ls_kasa = dw_data.GetItemString (ll_i, "kasa")
		ls_nalez = ""
		IF TRIM (ls_diagnozapatologickoanatomicka) <> "" THEN ls_nalez += "Diagnóza patologicko - anatomická~r~n~r~n" + ls_diagnozapatologickoanatomicka + "~r~n~r~n"
		IF TRIM (ls_epikriza) <> "" THEN ls_nalez += "Epikriza~r~n~r~n" + ls_epikriza + "~r~n~r~n"
		IF TRIM (ls_makropopis) <> "" THEN ls_nalez += "Makropopis~r~n~r~n" + ls_makropopis + "~r~n~r~n"
		ls_nalez += "Hmotnost těla a orgánů~r~n"
		IF li_hmotnosttela > 0 THEN ls_nalez += "Hmotnost těla: " + String (li_hmotnosttela) + "~r~n"
		IF li_mozek > 0 THEN ls_nalez += "Mozek: " + String (li_mozek) + "~r~n"
		IF li_srdce > 0 THEN ls_nalez += "Srdce: " + String (li_srdce) + "~r~n"
		IF li_pliceprava > 0 THEN ls_nalez += "Plíce pravá: " + String (li_pliceprava) + "~r~n"
		IF li_pliceleva > 0 THEN ls_nalez += "Plíce levá: " + String (li_pliceleva) + "~r~n"
		IF li_slezina > 0 THEN ls_nalez += "Slezina: " + String (li_slezina) + "~r~n"
		IF li_ledvinaprava > 0 THEN ls_nalez += "Ledvina pravá: " + String (li_ledvinaprava) + "~r~n"
		IF li_ledvinaleva > 0 THEN ls_nalez += "Ledvina levá: " + String (li_ledvinaleva) + "~r~n"
		IF li_jatra > 0 THEN ls_nalez += "Játra: " + String (li_jatra) + "~r~n"
		IF li_thymus > 0 THEN ls_nalez += "Thymus: " + String (li_thymus) + "~r~n"
		IF li_thyreoidea > 0 THEN ls_nalez += "Thyreoidea: " + String (li_thyreoidea) + "~r~n"
		IF li_pankreas > 0 THEN ls_nalez += "Pankreas: " + String (li_pankreas) + "~r~n"
		IF li_nadledvinka > 0 THEN ls_nalez += "Nadledvinka: " + String (li_nadledvinka) + "~r~n"
		IF trim (ls_hmotnostvolnytext1) <> "" THEN ls_nalez += ls_hmotnostvolnytext1 + "~r~n"
		IF trim (ls_hmotnostvolnytext2) <> "" THEN ls_nalez += ls_hmotnostvolnytext2 + "~r~n"
		IF TRIM (ls_histologie) <> "" THEN ls_nalez += "~r~nHistologie~r~n~r~n" + ls_histologie
		ls_informace = ls_id
		ls_platba = 'D'
		ls_stav = 'Z'; ls_stavvys = '9'; li_blokace = 1; li_bloknal = 1; li_tisk = 1; li_tisk_archiv = 1; li_xml = 1
		IF IsNull (ld_vysetr) THEN
			ls_stav = 'K'; ls_stavvys = '6'; li_blokace = 0; li_bloknal = 0; li_tisk = 0; li_tisk_archiv = 0; li_xml = 0
		END IF
		ls_pohlavi = "F"
		IF POS ("56", MID (ls_rc, 3, 1)) > 0 THEN ls_pohlavi = "M"
		//odesílající
		li_c_odeslal = 0
		SELECT Count (*), MAX (cislo) INTO :ll_poc, :li_a FROM Dbo.kliniky WHERE icp = :ls_icp;
		IF SQLCA.of_Chyba (0, 100) = 0 AND lL_poc > 0 AND li_a > 0 THEN li_c_odeslal = li_a
		SELECT Count (*) INTO :ll_poc FROM Dbo.vysetr WHERE cislo = :ll_cislo AND rok = :li_rok;
		IF SQLZIS.of_Chyba (0, 100) = 0 AND ll_poc > 0 THEN
			ll_dupl ++
			ls_dupl += ", " + String (ll_cislo) + "/" + String (li_rok)
		ELSE
			INSERT INTO dbo.vysetr (cislo, rok, typvys, rc, prjm, pohlavi, kasa, odber, prijem, vysetr, 
				c_odeslal, odeslal, icp, odeodb, primarni_vzorek, vzorek, nalez, stav, stavvys, 
				blokace, blok_nal, tisk, tisk_archiv, xml, labor_pozn, 
				c_dok, zaver, diag, kli_diag, platba, informace, barzkrjm, hlazkrjm, zkrjmv, zkrjm, klislo, lekar,
				makrofoto, odber_cas, prijem_cas, vysetr_cas, klinal, c_uvolnil, c_rescreen, c_prikrojil, poc_bs)
				VALUES (:ll_cislo, :li_rok, :ls_typvys, :ls_rc, :ls_prjm, :ls_pohlavi, :ls_kasa, :ld_odber, :ld_prijem, :ld_vysetr, 
				:li_c_odeslal, :ls_odeslal, :ls_icp, :ls_odeodb, :ls_primarni_vzorek, :ls_vzorek, :ls_nalez, :ls_stav, :ls_stavvys, 
				:li_blokace, :li_bloknal, :li_tisk, :li_tisk_archiv, :li_xml, '',
				:li_c_dok, '', :ls_diag, :ls_kli_diag, :ls_platba, :ls_informace, 0, 0, 0, 0, :ls_klislo, :ls_lekar,
				0, :lt_odber_cas, :lt_prijem_cas, :lt_vysetr_cas, :ls_diagnozaklinicka, :li_c_uvolnil, 0, 0, :li_poc_bs);
			IF SQLCA.of_Chyba (0, 100) = 0 THEN
				ll_ok ++
				SQLCA.of_Commit ()
			ELSE
				ll_err ++
				SQLCA.of_Rollback ()
			END IF
		END IF
	next
	SetPointer (Arrow!)
	w_frame.Event Pfc_Microhelp ("Hotovo")
	MessageBox ("Statistika", "Celkem načteno " + String (ll_pocet) + " záznamů.~r~n" + &
		"Celkem založeno " + String (ll_ok) + " nových pitev.~r~n" + &
		"Celkem " + String (ll_dupl) + " duplicitních pitev.~r~n" + &
		"Celkem " + String (ll_err) + " chyb při zpracování.")
	IF ll_dupl > 0 THEN MessageBox ("Duplicity", MID (ls_dupl, 3))
END IF

end subroutine

event resize;call super::resize;dw_data.width = newwidth - 10
dw_data.height = newheight - 10 - dw_data.y


end event

on w_vys.create
int iCurrent
call super::create
if this.MenuName = "m_vys" then this.MenuID = create m_vys
this.ddlb_typ=create ddlb_typ
this.mle_1=create mle_1
this.cb_zaznam=create cb_zaznam
this.st_zaz=create st_zaz
this.cb_zrus=create cb_zrus
this.cb_export=create cb_export
this.cb_nacti=create cb_nacti
this.cb_storno=create cb_storno
this.dw_data=create dw_data
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_typ
this.Control[iCurrent+2]=this.mle_1
this.Control[iCurrent+3]=this.cb_zaznam
this.Control[iCurrent+4]=this.st_zaz
this.Control[iCurrent+5]=this.cb_zrus
this.Control[iCurrent+6]=this.cb_export
this.Control[iCurrent+7]=this.cb_nacti
this.Control[iCurrent+8]=this.cb_storno
this.Control[iCurrent+9]=this.dw_data
end on

on w_vys.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_typ)
destroy(this.mle_1)
destroy(this.cb_zaznam)
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
//cb_nacti.Event Clicked ()

end event

type ddlb_typ from u_ddlb within w_vys
integer x = 1445
integer y = 16
integer width = 375
integer height = 268
integer taborder = 30
integer textsize = -9
fontcharset fontcharset = easteuropecharset!
string facename = "Arial"
string text = "Histo+cyto"
boolean allowedit = true
boolean sorted = false
string item[] = {"Histo+cyto","Pitvy"}
end type

event selectionchanged;call super::selectionchanged;IF LEFT (This.text, 1) = "H" THEN
	dw_data.DataObject = "d_vysetr"
	dw_data.Event Constructor ()
ELSEIF LEFT (This.text, 1) = "P" THEN
	dw_data.DataObject = "d_pitvy"
	dw_data.Event Constructor ()
ELSE
	MessageBox ("Chyba", "Neznám.", Exclamation!)
END IF
dw_data.SetFocus ()

end event

type mle_1 from u_mle within w_vys
integer x = 1975
integer y = 820
integer height = 252
integer taborder = 80
end type

type cb_zaznam from u_cb within w_vys
integer x = 1106
integer y = 16
integer width = 320
integer taborder = 20
string text = "Záznam č."
end type

event clicked;call super::clicked;IF dw_data.RowCount () > 0 THEN Open (w_zaznam)

end event

type st_zaz from u_st within w_vys
integer x = 1861
integer y = 24
integer width = 654
string text = ""
end type

type cb_zrus from u_cb within w_vys
integer x = 603
integer y = 16
integer width = 485
integer taborder = 50
string text = "Zrušit záznamy"
end type

event clicked;call super::clicked;Long ll_poc
String ls_typvys , ls_a, ls_typvys1

IF dw_data.DataObject = "d_pitvy" THEN
	ls_typvys = "P"
	ls_typvys1 = "PN"
	SELECT Count (*) INTO :ll_poc FROM Dbo.vysetr WHERE typvys IN (:ls_typvys, :ls_typvys1);
	ls_a = "Skutečně chcete zrušit celkem " + String (ll_poc) + " pitev ?"
ELSEIF dw_data.DataObject = "d_vysetr" THEN
	ls_typvys = 'HB'
	ls_typvys1 = 'CO'
	SELECT Count (*) INTO :ll_poc FROM Dbo.vysetr WHERE typvys IN (:ls_typvys, :ls_typvys1);
	ls_a = "Skutečně chcete zrušit celkem " + String (ll_poc) + " vyšetření HB a CO?"
END IF
SQLCA.of_Chyba (0, 100)
IF ll_poc = 0 THEN
	MessageBox ("Info", "Tabulka neobsahuje žádná vyšetření.")
ELSE
	IF MessageBox ("Dotaz", ls_a, Question!, yesNo!) = 1 THEN
		SetPointer (HourGlass!)
		UPDATE dbo.vysetr SET stavvys = '6' WHERE stavvys = '9' AND typvys IN (:ls_typvys, :ls_typvys1);
		IF SQLCA.of_chyba (0, 0) = 0 THEN
			SQLCA.of_Commit ()
			DELETE FROM dbo.vysetr WHERE typvys IN (:ls_typvys, :ls_typvys1);
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

type cb_export from u_cb within w_vys
integer x = 315
integer y = 16
integer width = 270
integer taborder = 30
boolean enabled = false
string text = "Export"
end type

event clicked;call super::clicked;IF dw_data.DataObject = "d_vysetr" THEN
	wf_biopsie ()
ELSEIF dw_data.DataObject = "d_pitvy" THEN
	wf_pitvy ()
END IF

end event

type cb_nacti from u_cb within w_vys
integer y = 16
integer width = 297
integer taborder = 10
string text = "Načíst"
end type

event clicked;call super::clicked;IF dw_data.Event Pfc_Retrieve () > 0 THEN
	cb_export.Enabled = TRUE
END IF

end event

type cb_storno from u_cb_storno within w_vys
integer x = 178
integer y = 272
integer taborder = 60
end type

type dw_data from u_dw within w_vys
integer y = 128
integer width = 2491
integer height = 508
integer taborder = 70
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

