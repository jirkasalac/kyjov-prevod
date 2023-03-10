$PBExportHeader$w_frame.srw
$PBExportComments$Extension Frame Window class
forward
global type w_frame from pfc_w_frame
end type
end forward

global type w_frame from pfc_w_frame
integer x = 107
integer width = 4608
integer height = 2744
end type
global w_frame w_frame

forward prototypes
public subroutine ikony ()
end prototypes

public subroutine ikony ();//nastavení ikon dle otevřených oken
end subroutine

on w_frame.create
call super::create
end on

on w_frame.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;this.of_SetSheetManager (TRUE)
this.of_SetStatusBar (TRUE)

end event

