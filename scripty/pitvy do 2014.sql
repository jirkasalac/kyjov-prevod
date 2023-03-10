-- pitvy
-- jejich ID je varchar(25), ROK v čísle vyšetření nemají
select p.ID, p.CisloPojistence as RC, p.JmenoPacienta as PRJM, 'P' as TYPVYS, (2000000 + cast (p.PoradoveCislo as int)) as CISLO, 
-- Datum úmrtí a pitvy má formát RRRR-MM-DD
p.DatumUmrti as ODBER, p.DatumPitvy as PRIJEM, p.HodinaPitvy as PRIJEM_CAS, 
replace(p.DgPozadavku, '.', '') as KLI_DIAG,
-- v tabulce Zadatele_PAT jsou nesmysly, proto jsem KLINIKY naplnil ručně, IČP je unikátní
ISNULL((select MAX(kliniky.cislo) from winzis_kyjov.dbo.kliniky where winzis_kyjov.dbo.kliniky.icp=p.IcpZadatele),0) as C_ODESLAL, p.Zadatel as ODESLAL, p.IcpZadatele as ICP,  p.OdbZadatele as ODEODB,
-- odřádkování v nálezu je CHAR(10)
-- v datech je lékař uveden textově, proto ho dohledávám v Per dle hodnoty v poli Fax
ISNULL((select per.c_dok from winzis_kyjov.dbo.PERSONAL per where p.Lekar=per.fax),0) as C_LEKAR,
ISNULL(p.KodZp,'') as KASA
from pitvy p where not exists (select 1 from vysetreni v where v.CisloVzorku=p.PoradoveCislo and v.CisloPojistence=p.CisloPojistence and left(p.DatumDoruceni,4)=left(v.DatumDoruceni,4) and v.TypVysetreni='NEKR' and p.klindg<>'')
and left(p.DatumDoruceni,4)=left(p.DatumPitvy,4)
order by PRIJEM
