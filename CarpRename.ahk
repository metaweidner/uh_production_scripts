#NoEnv
; #Warn
#persistent
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance, force

; =====================================VARIABLES

type = Item
pad = 000
sequence := 1
; sequence_string .= Format("{:03i}", 1)

; =====================================GUI

Gui, Color, d0d0d0, d0d0d0
Gui, Show, h0 w0, Carpenters Rename

; ===========================================MENUS
; see MENU FUNCTIONS at end of file

; File menu
; Menu, FileMenu, Add, Display &Standard Values, DisplayStandardValues
; Menu, FileMenu, Add, Display &User-Defined Values, DisplayUserValues
; Menu, FileMenu, Add
Menu, FileMenu, Add, &Reload, Reload
Menu, FileMenu, Add, E&xit, Exit

; Edit menu
; Menu, EditMenu, Add, Ctrl + &8, Control8
; Menu, EditMenu, Add, Ctrl + &9, Control9
; Menu, EditMenu, Add, Ctrl + &0, Control0
Menu, EditMenu, Add, Object Type, Type
Menu, EditMenu, Add, Start Sequence, Sequence

; Help menu
; Menu, HelpMenu, Add, &Documentation, Documentation
; Menu, HelpMenu, Add, &Newspaper Notes, NewspaperNotes
Menu, HelpMenu, Add, &About, About

; create menus
Menu, MyMenuBar, Add, &File, :FileMenu
Menu, MyMenuBar, Add, &Edit, :EditMenu
Menu, MyMenuBar, Add, &Help, :HelpMenu

; create menu bar
Gui, Menu, MyMenuBar

; ===========================================LABELS
Gui, Font,, Arial

Gui, Add, Text, x18  y10 w100 h20, Object Label
Gui, Add, Text, x190 y10 w100 h20, Sequence
Gui, Add, Text, x275 y10 w100 h20, Edit Sequence

; ===========================================DATA
Gui, Font, s15,

Gui, Add, Text, x30  y30 w150 h25, %type%
Gui, Add, Text, x205 y30 w35  h25, % (SubStr(pad, 1, StrLen(pad) - StrLen(sequence)) . sequence)
Gui, Add, Button, x275 y28 w30 h30 gPlus, +
Gui, Add, Button, x310 y28 w30 h30 gMinus, -
; Gui, Add, Edit, x275 y30 w75  h25
; Gui, Add, UpDown, vsequence gUpdateSequence Range1-999, %sequence%

; ===========================================BOXES

; labels section
Gui, Add, GroupBox, x10 y-5 w250 h70,
; edit section
Gui, Add, GroupBox, x265 y-5 w85 h70,

; object
Gui, Add, GroupBox, x18  y15 w165 h45,
; sequence
Gui, Add, GroupBox, x190 y15 w65 h45,

; ===========================================GUI

WinGetPos, winX, winY, winWidth, winHeight, Carpenters Rename
winX+=%winWidth%
Gui, Show, x%winX% y%winY% h70 w355, Carpenters Rename
winactivate, Carpenters Rename

; ========================================SCRIPTS

^!p::
  Sleep, 100
  sequence_display := (SubStr(pad, 1, StrLen(pad) - StrLen(sequence)) . sequence)
  Send, %type% %sequence_display%
  Sleep, 100
  Send, {Enter}
  sequence+=1
  ControlSetText, Static5, % (SubStr(pad, 1, StrLen(pad) - StrLen(sequence)) . sequence), Carpenters Rename
Return

; ====================================MENU FUNCTIONS

; =================FILE

; reload application
Reload:
Reload

; exit application
Exit:
ExitApp

; =================EDIT

; Object Type input
Type:
  InputBox, input, Object Type, Enter the object type label,, 250, 125,,,,,%type%
  	if ErrorLevel
  		Return
  	else
  		type = %input%
      ControlSetText, Static4, %type%, Carpenters Rename
Return

; Start Sequence input
Sequence:
  InputBox, input, Start Sequence, Enter the start sequence number,, 250, 125,,,,,%sequence%
  	if ErrorLevel
  		Return
  	else
  		sequence = %input%
      sequence_display := (SubStr(pad, 1, StrLen(pad) - StrLen(sequence)) . sequence)
      ControlSetText, Static5, %sequence_display%, Carpenters Rename
Return

Plus:
  sequence+=1
  sequence_display := (SubStr(pad, 1, StrLen(pad) - StrLen(sequence)) . sequence)
  ControlSetText, Static5, %sequence_display%, Carpenters Rename
Return

Minus:
  sequence-=1
  sequence_display := (SubStr(pad, 1, StrLen(pad) - StrLen(sequence)) . sequence)
  ControlSetText, Static5, %sequence_display%, Carpenters Rename
Return

; =================HELP

; display version info
About:
MsgBox CarpRename`nVersion 0.1`najweidner@uh.edu
Return

; ; open NewspaperNotes.ahk wiki page
; Documentation:
; 	Run, https://github.com/drewhop/AutoHotkey/wiki/NewspaperNotes
; Return
;
; ; open Newspaper Notes input standard wiki page
; NewspaperNotes:
; 	Run, http://digitalprojects.library.unt.edu/projects/index.php/Newspaper_Notes
; Return

GuiClose:
ExitApp
