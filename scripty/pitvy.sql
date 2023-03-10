-- pitvy
-- jejich ID je varchar(25), ROK v čísle vyšetření nemají
select p.ID, p.CisloPojistence as RC, p.JmenoPacienta as PRJM, 'P' as TYPVYS, (2000000 + cast (p.PoradoveCislo as int)) as CISLO, 
-- Datum úmrtí a pitvy má formát RRRR-MM-DD
p.DatumUmrti as ODBER, p.DatumPitvy as PRIJEM, p.HodinaPitvy as PRIJEM_CAS, v.DatumVysetreni as VYSETR, v.CasVysetreni as VYSETR_CAS,
replace(p.DgPozadavku, '.', '') as KLI_DIAG,
-- v tabulce Zadatele_PAT jsou nesmysly, proto jsem KLINIKY naplnil ručně, IČP je unikátní
ISNULL((select MAX(kliniky.cislo) from winzis_kyjov.dbo.kliniky where winzis_kyjov.dbo.kliniky.icp=p.IcpZadatele),0) as C_ODESLAL, p.Zadatel as ODESLAL, p.IcpZadatele as ICP,  p.OdbZadatele as ODEODB,
-- odřádkování v nálezu je CHAR(10)
-- pitevní protokol se skládá z položek: Diagnóza klinická, Diagnóza patologicko - anatomická, Epikríza, Makropopis, Hmotnost těla a orgánů, Histologie, Volný text1, Volný text2
replace (p.KlinDg, char(10),char(13)+char(10)) as 'DiagnozaKlinicka', replace (p.AnatomDg, char(10),char(13)+char(10)) as 'DiagnozaPatologickoAnatomicka', 
replace (p.Epikriza, char(10),char(13)+char(10)) as 'Epikriza', replace (p.PitevNalez, char(10),char(13)+char(10)) as 'Makropopis',
-- blok Hmotnost těla a orgánů se musí poskládat z údajů Hmotnost těla, Mozek, Srdce, Plíce pravá, Plíce levá, Slezina, Ledvina levá, Ledvina pravá, Játra, Thymus, Thyreoidea, Pankreas a Nadledvinka, pod tím jsou ještě 2 volné texty
HmotTelo as HmotnostTela, HmotMozek as Mozek, HmotSrdce as Srdce, HmotPliceP as PlicePrava, HmotPliceL as PliceLeva, HmotSlezina as Slezina, HmotLedvinaL as LedvinaLeva, HmotLedvinaP as LedvinaPrava, HmotJatra as Jatra, HmotThymus as Thymus, HmotThyreus as Thyreoidea, HmotPankreas as Pankreas, HmotNadl as Nadledvinka, 
replace (HmotVolne1, char(10),char(13)+char(10)) as HmotnostVolnyText1, replace (HmotVolne2, char(10),char(13)+char(10)) as HmotnostVolnyText2,
replace (v.Nalez, char(10),char(13)+char(10)) as Histologie,
-- v datech je lékař uveden textově, proto ho dohledávám v Per dle hodnoty v poli Fax
ISNULL((select per.c_dok from winzis_kyjov.dbo.PERSONAL per where p.Lekar=per.fax),0) as C_LEKAR,
ISNULL(p.KodZp,'') as KASA
from pitvy p, vysetreni v where v.CisloVzorku=p.PoradoveCislo and v.CisloPojistence=p.CisloPojistence and left(p.DatumDoruceni,4)=left(v.DatumDoruceni,4) and v.TypVysetreni='NEKR' and p.klindg<>''
order by VYSETR
