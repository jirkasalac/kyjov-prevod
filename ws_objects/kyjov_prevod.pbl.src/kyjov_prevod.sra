$PBExportHeader$kyjov_prevod.sra
$PBExportComments$Generated Application Object
forward
global type kyjov_prevod from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
n_cst_appmanager gnv_app

n_tr SQLZIS

end variables

global type kyjov_prevod from application
string appname = "kyjov_prevod"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 2
long richtexteditx64type = 3
long richtexteditversion = 1
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "21.0.0.1509"
boolean manualsession = false
boolean unsupportedapierror = false
end type
global kyjov_prevod kyjov_prevod

on kyjov_prevod.create
appname="kyjov_prevod"
message=create message
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on kyjov_prevod.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event close;gnv_app.Event Pfc_Close ()
end event

event open;gnv_app = CREATE n_cst_appmanager
gnv_app.Event Pfc_Open (Commandline)

end event

