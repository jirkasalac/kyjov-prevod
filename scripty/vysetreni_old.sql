-- histologie a cytologie
-- jejich ID je varchar(25), ROK v čísle vyšetření nemají
select ID, CisloPojistence as RC, JmenoPacienta as PRJM, (CASE WHEN TypVysetreni='CYT' THEN 'CO' ELSE 'HB' END) as TYPVYS, (CASE WHEN TypVysetreni='CYT' THEN (1000000 + cast (CisloVzorku as int)) ELSE cast (CisloVzorku as int) END) as CISLO, 
-- Datum příjmu a uzavření má formát RRRR-MM-DD, Datum odběru má formát RRRRMMDD
DatvVystavPozad as ODBER, DatumDoruceni as PRIJEM, CasDoruceni as PRIJEM_CAS, DatumVysetreni as VYSETR, CasVysetreni as VYSETR_CAS, material as KLINAL, 
-- FIXACE jsou různé texty do 12 znaků
fixace as FIXACE, PocPreparatu as POC_BLOKY, PocBloku as PARBLO, barveni as POC_BLOKY1, replace(DgPozadavku, '.', '') as KLI_DIAG,
-- v tabulce Zadatele_PAT jsou nesmysly, proto jsem KLINIKY naplnil ručně, IČP je unikátní
(select MAX(cislo) from winzis_kyjov.dbo.kliniky where winzis_kyjov.dbo.kliniky.icp=vysetreni.IcpZadatele) as C_ODESLAL, zaslal as ODESLAL, IcpZadatele as ICP,  OdbZadatele as ODEODB, 
-- v datech je lékař uveden textově, proto ho dohledávám v Per dle hodnoty v poli Fax
ISNULL((select p.c_dok from winzis_kyjov.dbo.PERSONAL p where VysetrilLekar=p.fax),0) as C_LEKAR,
-- odřádkování v makru a nálezu je CHAR(10)
NalezMakroskop as MAKRO, (CASE WHEN TypVysetreni='CYT' THEN Nalez ELSE NalezHistoPatol END) as NALEZ, ('Převzal: ' + VzorekPrijal) as POZNAMKA,
ISNULL(KodZp,'') as KASA
from vysetreni
where [TypVysetreni]<>'NEKR'
